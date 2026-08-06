#!/usr/bin/env python3
"""
Stock Chart Generator with Candlesticks, MAs, and RSI
"""

import pandas as pd
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import warnings
warnings.filterwarnings('ignore')

# ──────────────────────────────────────────────────────────────
# 1.  READ AND VALIDATE CSV
# ──────────────────────────────────────────────────────────────

def validate_and_map_columns(df):
    """
    Validate that the DataFrame has required OHLCV columns and map them.
    Returns a dict with column mappings.
    """
    # Define possible column name variations
    column_mappings = {
        'date': ['date', 'Date', 'DATE', 'datetime', 'DateTime', 'dt', 'DT', 'DateStr', 'datestr'],
        'open': ['open', 'Open', 'OPEN', 'opnp', 'OPNP', 'o', 'O'],
        'high': ['high', 'High', 'HIGH', 'maxp', 'MAXP', 'h', 'H'],
        'low': ['low', 'Low', 'LOW', 'minp', 'MINP', 'l', 'L'],
        'close': ['close', 'Close', 'CLOSE', 'price', 'Price', 'PRICE', 'c', 'C'],
        'volume': ['volume', 'Volume', 'VOLUME', 'qty', 'Qty', 'QTY', 'v', 'V'],
        'ticker': ['name', 'Name', 'NAME', 'ticker', 'Ticker', 'TICKER', 'symbol', 'Symbol']
    }
    
    # Find actual column names in the DataFrame
    found_columns = {}
    
    for required, variations in column_mappings.items():
        found = None
        for var in variations:
            # Case-insensitive matching
            matches = [col for col in df.columns if col.lower() == var.lower()]
            if matches:
                found = matches[0]
                break
            # Also check if variation is a substring
            if len(var) >= 3:
                for col in df.columns:
                    if var.lower() in col.lower() or col.lower() in var.lower():
                        if required == 'open' and 'opnp' in col.lower():
                            found = col
                            break
                        elif required == 'close' and 'price' in col.lower():
                            found = col
                            break
                        elif required == 'high' and 'maxp' in col.lower():
                            found = col
                            break
                        elif required == 'low' and 'minp' in col.lower():
                            found = col
                            break
                        elif required == 'volume' and 'qty' in col.lower():
                            found = col
                            break
                if found:
                    break
        
        if found:
            found_columns[required] = found
        else:
            print(f"⚠️  Warning: Could not find column for '{required}'")
            print(f"   Available columns: {list(df.columns)}")
            print(f"   Tried variations: {column_mappings[required]}")
    
    return found_columns

def clean_and_prepare_data(df, column_map):
    """
    Clean the data: remove invalid rows, sort by date, handle duplicates.
    Returns cleaned DataFrame and cleaning report.
    """
    df_clean = df.copy()
    cleaning_report = {
        'original_rows': len(df_clean),
        'rows_excluded': 0,
        'duplicates_removed': 0,
        'invalid_rows_removed': 0,
        'date_range': None,
        'tickers': []
    }
    
    # Check if we have all required columns
    required = ['date', 'open', 'high', 'low', 'close', 'volume']
    missing = [col for col in required if col not in column_map]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")
    
    # Standardize column names
    rename_dict = {v: k for k, v in column_map.items()}
    df_clean = df_clean.rename(columns=rename_dict)
    
    # Convert date to datetime
    df_clean['date'] = pd.to_datetime(df_clean['date'], errors='coerce')
    
    # Remove rows with invalid dates
    before = len(df_clean)
    df_clean = df_clean.dropna(subset=['date'])
    invalid_dates = before - len(df_clean)
    cleaning_report['invalid_rows_removed'] += invalid_dates
    
    # Sort by date
    df_clean = df_clean.sort_values('date')
    
    # Remove duplicate dates (keep first occurrence)
    before = len(df_clean)
    df_clean = df_clean.drop_duplicates(subset=['date'], keep='first')
    duplicates = before - len(df_clean)
    cleaning_report['duplicates_removed'] += duplicates
    
    # Convert numeric columns to float, remove invalid values
    numeric_cols = ['open', 'high', 'low', 'close', 'volume']
    for col in numeric_cols:
        if col in df_clean.columns:
            df_clean[col] = pd.to_numeric(df_clean[col], errors='coerce')
    
    # Remove rows with any missing numeric values
    before = len(df_clean)
    df_clean = df_clean.dropna(subset=numeric_cols)
    missing_numeric = before - len(df_clean)
    cleaning_report['invalid_rows_removed'] += missing_numeric
    
    # Remove rows with zero or negative prices/volumes
    before = len(df_clean)
    df_clean = df_clean[
        (df_clean['open'] > 0) &
        (df_clean['high'] > 0) &
        (df_clean['low'] > 0) &
        (df_clean['close'] > 0) &
        (df_clean['volume'] >= 0)
    ]
    zero_values = before - len(df_clean)
    cleaning_report['invalid_rows_removed'] += zero_values
    
    # Get ticker info if available
    if 'ticker' in df_clean.columns:
        cleaning_report['tickers'] = df_clean['ticker'].unique().tolist()
        # Keep only first ticker if multiple
        if len(cleaning_report['tickers']) > 1:
            print(f"⚠️  Multiple tickers found: {cleaning_report['tickers']}")
            print("   Using first ticker for analysis")
            df_clean = df_clean[df_clean['ticker'] == cleaning_report['tickers'][0]]
    else:
        df_clean['ticker'] = 'UNKNOWN'
        cleaning_report['tickers'] = ['UNKNOWN']
    
    cleaning_report['rows_excluded'] = cleaning_report['original_rows'] - len(df_clean)
    cleaning_report['date_range'] = f"{df_clean['date'].min().strftime('%Y-%m-%d')} → {df_clean['date'].max().strftime('%Y-%m-%d')}"
    
    return df_clean, cleaning_report

# ──────────────────────────────────────────────────────────────
# 2.  CALCULATE INDICATORS
# ──────────────────────────────────────────────────────────────

def calculate_sma(data, period):
    """Calculate Simple Moving Average"""
    return data['close'].rolling(window=period).mean()

def calculate_rsi(data, period=14):
    """Calculate RSI using Wilder's smoothing"""
    delta = data['close'].diff()
    gain = (delta.where(delta > 0, 0)).rolling(window=period).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(window=period).mean()
    
    # Handle division by zero
    rs = gain / loss
    rsi = 100 - (100 / (1 + rs))
    
    # First RSI value calculation (alternative method for first value)
    if len(data) > period:
        first_gain = delta.iloc[1:period+1].where(delta.iloc[1:period+1] > 0, 0).mean()
        first_loss = (-delta.iloc[1:period+1].where(delta.iloc[1:period+1] < 0, 0)).mean()
        if first_loss != 0:
            first_rs = first_gain / first_loss
            first_rsi = 100 - (100 / (1 + first_rs))
            rsi.iloc[period] = first_rsi
    
    return rsi

def calculate_indicators(df):
    """Calculate all technical indicators"""
    df = df.copy()
    
    # Moving averages
    df['sma_20'] = calculate_sma(df, 20)
    df['sma_50'] = calculate_sma(df, 50)
    
    # RSI
    df['rsi_14'] = calculate_rsi(df, 14)
    
    return df

# ──────────────────────────────────────────────────────────────
# 3.  CREATE INTERACTIVE CHART
# ──────────────────────────────────────────────────────────────

def create_candlestick_chart(df, ticker, cleaning_report):
    """
    Create an interactive Plotly chart with candlesticks, volume, MA lines, and RSI.
    """
    # Prepare data
    df = df.copy()
    
    # Get ticker name
    ticker_name = ticker if ticker else 'Stock'
    
    # Create subplots with 3 rows
    fig = make_subplots(
        rows=3, cols=1,
        shared_xaxes=True,
        vertical_spacing=0.03,
        row_heights=[0.6, 0.2, 0.2],
        subplot_titles=(
            f'{ticker_name} · Candlestick with Moving Averages',
            'Volume',
            'RSI (14)'
        )
    )
    
    # ── 1. Candlestick chart ──
    fig.add_trace(
        go.Candlestick(
            x=df['date'],
            open=df['open'],
            high=df['high'],
            low=df['low'],
            close=df['close'],
            name='OHLC',
            increasing_line_color='#4ade80',
            decreasing_line_color='#f87171',
            showlegend=True
        ),
        row=1, col=1
    )
    
    # Add moving averages
    fig.add_trace(
        go.Scatter(
            x=df['date'],
            y=df['sma_20'],
            mode='lines',
            name='SMA (20)',
            line=dict(color='#f97316', width=1.5)
        ),
        row=1, col=1
    )
    
    fig.add_trace(
        go.Scatter(
            x=df['date'],
            y=df['sma_50'],
            mode='lines',
            name='SMA (50)',
            line=dict(color='#8b5cf6', width=1.5)
        ),
        row=1, col=1
    )
    
    # ── 2. Volume chart ──
    # Color volume bars to match candle direction
    volume_colors = ['#4ade80' if close >= open else '#f87171' 
                     for close, open in zip(df['close'], df['open'])]
    
    fig.add_trace(
        go.Bar(
            x=df['date'],
            y=df['volume'],
            name='Volume',
            marker_color=volume_colors,
            opacity=0.7,
            showlegend=False
        ),
        row=2, col=1
    )
    
    # ── 3. RSI chart ──
    fig.add_trace(
        go.Scatter(
            x=df['date'],
            y=df['rsi_14'],
            mode='lines',
            name='RSI (14)',
            line=dict(color='#fbbf24', width=2)
        ),
        row=3, col=1
    )
    
    # Add RSI reference lines
    for level, color, label in [(70, '#f87171', 'Overbought'), 
                                 (30, '#4ade80', 'Oversold')]:
        fig.add_hline(
            y=level, 
            line_dash="dash", 
            line_color=color,
            opacity=0.6,
            row=3, col=1,
            annotation_text=label,
            annotation_position="right"
        )
    
    # Add RSI midline
    fig.add_hline(
        y=50, 
        line_dash="dot", 
        line_color="#64748b",
        opacity=0.4,
        row=3, col=1,
        annotation_text="Midline",
        annotation_position="right"
    )
    
    # ── Layout ──
    fig.update_layout(
        title={
            'text': f'{ticker_name} · {cleaning_report["date_range"]}',
            'font': {'size': 20, 'color': '#f0f3f8'}
        },
        template='plotly_dark',
        paper_bgcolor='#0f131a',
        plot_bgcolor='#0f131a',
        font={'color': '#94a3b8'},
        hovermode='x unified',
        legend={
            'orientation': 'h',
            'yanchor': 'bottom',
            'y': 1.02,
            'xanchor': 'center',
            'x': 0.5,
            'font': {'color': '#94a3b8'},
            'bgcolor': 'rgba(15,19,26,0.8)'
        },
        xaxis_rangeslider_visible=False,
        height=800,
        margin={'l': 60, 'r': 60, 't': 80, 'b': 50}
    )
    
    # Update y-axes
    fig.update_yaxes(title_text="Price (THB)", row=1, col=1, gridcolor='#1e2630')
    fig.update_yaxes(title_text="Volume", row=2, col=1, gridcolor='#1e2630')
    fig.update_yaxes(title_text="RSI", row=3, col=1, gridcolor='#1e2630', range=[0, 100])
    
    fig.update_xaxes(title_text="Date", row=3, col=1, gridcolor='#1e2630')
    
    return fig

# ──────────────────────────────────────────────────────────────
# 4.  GENERATE HTML OUTPUT
# ──────────────────────────────────────────────────────────────

def generate_report_html(df, cleaning_report, output_file='stock_chart.html'):
    """
    Generate a standalone HTML file with the interactive chart.
    """
    import json
    
    # Create chart
    ticker = cleaning_report['tickers'][0] if cleaning_report['tickers'] else 'Stock'
    fig = create_candlestick_chart(df, ticker, cleaning_report)
    
    # Calculate values for stats (handle NaN)
    last_close = df['close'].iloc[-1]
    first_close = df['close'].iloc[0]
    change_pct = ((last_close - first_close) / first_close * 100) if first_close != 0 else 0
    
    sma20_val = df['sma_20'].iloc[-1]
    sma20_display = f"{sma20_val:.2f}" if not pd.isna(sma20_val) else '—'
    
    sma50_val = df['sma_50'].iloc[-1]
    sma50_display = f"{sma50_val:.2f}" if not pd.isna(sma50_val) else '—'
    
    rsi_val = df['rsi_14'].iloc[-1]
    rsi_display = f"{rsi_val:.1f}" if not pd.isna(rsi_val) else '—'
    
    # Determine RSI color class
    if not pd.isna(rsi_val):
        if rsi_val > 70:
            rsi_class = 'red'
        elif rsi_val < 30:
            rsi_class = 'green'
        else:
            rsi_class = 'amber'
    else:
        rsi_class = 'amber'
    
    volume_val = df['volume'].iloc[-1]
    change_class = 'green' if change_pct >= 0 else 'red'
    
    # Convert figure to JSON with proper formatting
    fig_json = fig.to_json()
    
    # Create HTML content with embedded chart
    html_content = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{ticker} · Candlestick Chart with Indicators</title>
    <script src="https://cdn.plot.ly/plotly-3.0.1.min.js"></script>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; }}
        body {{
            background: #0b0e14;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }}
        .container {{
            max-width: 1400px;
            width: 100%;
            background: #14181f;
            border-radius: 20px;
            padding: 28px 30px 20px 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.7);
            border: 1px solid #2a303a;
        }}
        .header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 16px;
        }}
        .title {{
            color: #f0f3f8;
            font-weight: 700;
            font-size: 26px;
        }}
        .title span {{
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }}
        .subtitle {{
            color: #94a3b8;
            font-size: 14px;
            background: #1e2630;
            padding: 6px 16px;
            border-radius: 40px;
            border: 1px solid #2f3845;
        }}
        .stats-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px;
            margin-top: 16px;
            margin-bottom: 16px;
        }}
        .stat-card {{
            background: #1a2129;
            border-radius: 10px;
            padding: 12px 16px;
            border: 1px solid #29323e;
        }}
        .stat-card .label {{
            color: #94a3b8;
            font-size: 12px;
            font-weight: 400;
        }}
        .stat-card .value {{
            color: #f1f5f9;
            font-size: 18px;
            font-weight: 700;
            margin-top: 2px;
        }}
        .stat-card .value.green {{ color: #4ade80; }}
        .stat-card .value.red {{ color: #f87171; }}
        .stat-card .value.amber {{ color: #fbbf24; }}
        #chart {{
            width: 100%;
            height: 800px;
            border-radius: 12px;
            background: #0f131a;
        }}
        .cleaning-note {{
            background: #1a2129;
            border-left: 3px solid #f59e0b;
            padding: 10px 16px;
            margin-top: 12px;
            border-radius: 6px;
            font-size: 13px;
            color: #cbd5e1;
        }}
        .cleaning-note strong {{ color: #fbbf24; }}
        .footer {{
            color: #475569;
            font-size: 12px;
            text-align: center;
            margin-top: 16px;
            border-top: 1px solid #1e2630;
            padding-top: 16px;
        }}
        @media (max-width: 640px) {{
            .container {{ padding: 16px; }}
            .title {{ font-size: 20px; }}
            #chart {{ height: 600px; }}
            .stat-card .value {{ font-size: 15px; }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="title">📈 <span>{ticker}</span> · Technical Analysis</div>
            <div class="subtitle">{cleaning_report['date_range']} · {len(df)} days</div>
        </div>
        
        <div class="stats-grid" id="stats">
            <div class="stat-card">
                <div class="label">Latest Close</div>
                <div class="value">{last_close:.2f}</div>
            </div>
            <div class="stat-card">
                <div class="label">Change</div>
                <div class="value {change_class}">{change_pct:+.2f}%</div>
            </div>
            <div class="stat-card">
                <div class="label">SMA (20)</div>
                <div class="value">{sma20_display}</div>
            </div>
            <div class="stat-card">
                <div class="label">SMA (50)</div>
                <div class="value">{sma50_display}</div>
            </div>
            <div class="stat-card">
                <div class="label">RSI (14)</div>
                <div class="value {rsi_class}">{rsi_display}</div>
            </div>
            <div class="stat-card">
                <div class="label">Volume</div>
                <div class="value">{volume_val:,.0f}</div>
            </div>
        </div>
        
        <div id="chart"></div>
        
        <div class="cleaning-note">
            <strong>🧹 Data Cleaning Summary:</strong>
            Original: {cleaning_report['original_rows']} rows · Excluded: {cleaning_report['rows_excluded']} rows 
            ({cleaning_report['duplicates_removed']} duplicates, {cleaning_report['invalid_rows_removed'] - cleaning_report['duplicates_removed']} invalid values) ·
            Trading days: {len(df)}
        </div>
        
        <div class="footer">
            Data: {ticker} · Candles: <span style="color:#4ade80;">green ↑ up</span>, <span style="color:#f87171;">red ↓ down</span> ·
            MA(20): <span style="color:#f97316;">orange</span>, MA(50): <span style="color:#8b5cf6;">purple</span> ·
            RSI(14) with overbought/oversold levels
        </div>
    </div>
    
    <script>
        // ──────────────────────────────────────────────────────────
        //  EMBED CHART DATA
        // ──────────────────────────────────────────────────────────
        const chartData = {fig_json};
        
        // Render the chart
        Plotly.react('chart', chartData.data, chartData.layout);
    </script>
</body>
</html>'''
    
    # Write to file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"✅ HTML report saved to: {output_file}")
    return output_file

# ──────────────────────────────────────────────────────────────
# 5.  MAIN EXECUTION
# ──────────────────────────────────────────────────────────────

def main(csv_file_path, output_file='stock_chart.html'):
    """
    Main function to process CSV and generate interactive chart.
    """
    print(f"📊 Processing: {csv_file_path}")
    print("-" * 50)
    
    # Read CSV
    try:
        df = pd.read_csv(csv_file_path)
        print(f"✅ Loaded {len(df)} rows")
        print(f"   Columns: {list(df.columns)}")
    except Exception as e:
        print(f"❌ Error reading CSV: {e}")
        return None
    
    # Validate and map columns
    column_map = validate_and_map_columns(df)
    print(f"\n📋 Column mapping:")
    for k, v in column_map.items():
        print(f"   {k} → '{v}'")
    
    # Clean data
    df_clean, cleaning_report = clean_and_prepare_data(df, column_map)
    
    print(f"\n🧹 Cleaning Summary:")
    print(f"   Original rows: {cleaning_report['original_rows']}")
    print(f"   Rows excluded: {cleaning_report['rows_excluded']}")
    print(f"   Duplicates removed: {cleaning_report['duplicates_removed']}")
    print(f"   Invalid values removed: {cleaning_report['invalid_rows_removed'] - cleaning_report['duplicates_removed']}")
    print(f"   Final rows: {len(df_clean)}")
    print(f"   Date range: {cleaning_report['date_range']}")
    print(f"   Ticker(s): {cleaning_report['tickers']}")
    
    if len(df_clean) < 20:
        print(f"\n⚠️  Warning: Only {len(df_clean)} rows remain after cleaning.")
        print("   At least 20 rows are needed for SMA(20) and RSI(14) calculations.")
    
    # Calculate indicators
    df_with_indicators = calculate_indicators(df_clean)
    
    # Generate HTML report
    output_path = generate_report_html(df_with_indicators, cleaning_report, output_file)
    
    print(f"\n✅ Done! Open {output_path} in your browser to view the chart.")
    return output_path

# ──────────────────────────────────────────────────────────────
# 6.  RUN THE SCRIPT
# ──────────────────────────────────────────────────────────────

if __name__ == "__main__":
    # Replace with your CSV file path
    CSV_FILE = "'TVO'.csv"  # Update this path to your CSV file
    
    # Generate the chart
    main(CSV_FILE, output_file='TVO_candlestick_chart.html')