--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15
-- Dumped by pg_dump version 10.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.standings DROP CONSTRAINT fk_rails_e9d6ea91b3;
ALTER TABLE ONLY public.fixtures DROP CONSTRAINT fk_rails_e99c2e4db6;
ALTER TABLE ONLY public.fixtures DROP CONSTRAINT fk_rails_9af4cca3ac;
ALTER TABLE ONLY public.fixtures DROP CONSTRAINT fk_rails_45a97a2b64;
ALTER TABLE ONLY public.results DROP CONSTRAINT fk_rails_24208fad15;
ALTER TABLE ONLY public.fixtures DROP CONSTRAINT fk_rails_0c45715fb6;
DROP INDEX public.index_teams_on_year_and_name;
DROP INDEX public.index_teams_on_year_and_group;
DROP INDEX public.index_teams_on_name_and_year;
DROP INDEX public.index_standings_on_team_id_and_year;
DROP INDEX public.index_standings_on_team_id;
DROP INDEX public.index_results_on_fixture_id;
DROP INDEX public.index_fixtures_on_year;
DROP INDEX public.index_fixtures_on_session_id;
DROP INDEX public.index_fixtures_on_round_id;
DROP INDEX public.index_fixtures_on_criterium_id;
DROP INDEX public.index_fixtures_on_channel_id;
ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_pkey;
ALTER TABLE ONLY public.standings DROP CONSTRAINT standings_pkey;
ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.rounds DROP CONSTRAINT rounds_pkey;
ALTER TABLE ONLY public.results DROP CONSTRAINT results_pkey;
ALTER TABLE ONLY public.fixtures DROP CONSTRAINT fixtures_pkey;
ALTER TABLE ONLY public.criteria DROP CONSTRAINT criteria_pkey;
ALTER TABLE ONLY public.channels DROP CONSTRAINT channels_pkey;
ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
ALTER TABLE public.teams ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.standings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.sessions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.rounds ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.results ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.fixtures ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.criteria ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.channels ALTER COLUMN id DROP DEFAULT;
DROP TABLE public.temp_table;
DROP SEQUENCE public.teams_id_seq;
DROP TABLE public.teams;
DROP SEQUENCE public.standings_id_seq;
DROP TABLE public.standings;
DROP SEQUENCE public.sessions_id_seq;
DROP TABLE public.sessions;
DROP TABLE public.schema_migrations;
DROP SEQUENCE public.rounds_id_seq;
DROP TABLE public.rounds;
DROP SEQUENCE public.results_id_seq;
DROP TABLE public.results;
DROP SEQUENCE public.fixtures_id_seq;
DROP TABLE public.fixtures;
DROP SEQUENCE public.criteria_id_seq;
DROP TABLE public.criteria;
DROP SEQUENCE public.channels_id_seq;
DROP TABLE public.channels;
DROP TABLE public.ar_internal_metadata;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: channels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channels (
    id bigint NOT NULL,
    number integer,
    name character varying,
    logo character varying,
    url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.channels OWNER TO postgres;

--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channels_id_seq OWNER TO postgres;

--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channels_id_seq OWNED BY public.channels.id;


--
-- Name: criteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.criteria (
    id bigint NOT NULL,
    show_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.criteria OWNER TO postgres;

--
-- Name: criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.criteria_id_seq OWNER TO postgres;

--
-- Name: criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.criteria_id_seq OWNED BY public.criteria.id;


--
-- Name: fixtures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fixtures (
    id bigint NOT NULL,
    round_id bigint,
    date date,
    session_id bigint,
    home_id integer,
    away_id integer,
    channel_id bigint,
    criterium_id bigint DEFAULT 1,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    year integer DEFAULT 2022 NOT NULL
);


ALTER TABLE public.fixtures OWNER TO postgres;

--
-- Name: fixtures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fixtures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fixtures_id_seq OWNER TO postgres;

--
-- Name: fixtures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fixtures_id_seq OWNED BY public.fixtures.id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.results (
    id bigint NOT NULL,
    fixture_id bigint,
    home_goals integer,
    away_goals integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    year integer
);


ALTER TABLE public.results OWNER TO postgres;

--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.results_id_seq OWNER TO postgres;

--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.results_id_seq OWNED BY public.results.id;


--
-- Name: rounds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rounds (
    id bigint NOT NULL,
    sequence integer,
    name character varying,
    year integer DEFAULT 2022 NOT NULL
);


ALTER TABLE public.rounds OWNER TO postgres;

--
-- Name: rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rounds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rounds_id_seq OWNER TO postgres;

--
-- Name: rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rounds_id_seq OWNED BY public.rounds.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    sequence integer,
    "time" time without time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: standings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standings (
    id bigint NOT NULL,
    team_id bigint,
    wins integer,
    draws integer,
    losses integer,
    goals_for integer,
    goals_against integer,
    points integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    year integer DEFAULT 2022 NOT NULL
);


ALTER TABLE public.standings OWNER TO postgres;

--
-- Name: standings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.standings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.standings_id_seq OWNER TO postgres;

--
-- Name: standings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.standings_id_seq OWNED BY public.standings.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    name character varying,
    "group" character varying,
    ranking integer,
    flag character varying,
    year integer DEFAULT 2022 NOT NULL
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: temp_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_table (
    team_id bigint,
    "W" bigint,
    "D" bigint,
    "L" bigint,
    "GF" bigint,
    "GA" bigint,
    "Pts" bigint
);


ALTER TABLE public.temp_table OWNER TO postgres;

--
-- Name: channels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);


--
-- Name: criteria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criteria ALTER COLUMN id SET DEFAULT nextval('public.criteria_id_seq'::regclass);


--
-- Name: fixtures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures ALTER COLUMN id SET DEFAULT nextval('public.fixtures_id_seq'::regclass);


--
-- Name: results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results ALTER COLUMN id SET DEFAULT nextval('public.results_id_seq'::regclass);


--
-- Name: rounds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rounds ALTER COLUMN id SET DEFAULT nextval('public.rounds_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: standings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standings ALTER COLUMN id SET DEFAULT nextval('public.standings_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2022-11-21 17:22:21.890609	2022-11-21 17:22:21.890609
\.


--
-- Data for Name: channels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.channels (id, number, name, logo, url, created_at, updated_at) FROM stdin;
2	5	CH5	CH 5.png	app.tv5.co.th/	2018-06-10 16:13:14.611403	2018-06-10 16:23:59.578644
3	34	Amarin	AMARIN.png	www.amarintv.com/live-tv/	2018-06-10 16:27:21.124476	2018-06-10 16:34:05.182991
4	24	True4U	true4you2.jpg	tv.trueid.net/live/true4U	2018-06-10 16:27:49.544774	2018-06-10 16:27:49.544774
5	29	MONO29	MONO29.PNG	www.mono29.com	2026-06-13 15:57:54.499427	2026-06-13 15:57:54.499427
\.


--
-- Data for Name: criteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.criteria (id, show_date, created_at, updated_at) FROM stdin;
1	2022-12-04	2022-11-22 04:34:27.721077	2022-12-12 14:23:29.355734
2	2026-06-11	2026-06-12 00:54:37.822431	2026-06-12 00:54:37.822431
\.


--
-- Data for Name: fixtures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fixtures (id, round_id, date, session_id, home_id, away_id, channel_id, criterium_id, created_at, updated_at, year) FROM stdin;
3	1	2022-11-20	4	4	1	4	1	2022-11-22 07:43:35.616576	2022-11-22 07:43:35.616576	2022
4	1	2022-11-21	2	5	8	4	1	2022-11-22 13:06:59.101057	2022-11-22 13:06:59.101057	2022
5	1	2022-11-21	4	2	3	4	1	2022-11-22 13:13:29.022972	2022-11-22 13:13:29.022972	2022
6	1	2022-11-22	5	6	7	4	1	2022-11-22 13:14:47.925186	2022-11-22 13:14:47.925186	2022
7	1	2022-11-22	1	9	10	4	1	2022-11-22 13:15:23.81442	2022-11-22 13:15:23.81442	2022
8	1	2022-11-22	2	15	16	4	1	2022-11-22 15:12:08.677809	2022-11-22 15:12:08.677809	2022
9	1	2022-11-22	4	11	12	4	1	2022-11-22 17:24:47.532501	2022-11-22 17:24:47.532501	2022
10	1	2022-11-23	5	13	14	4	1	2022-11-22 17:28:14.268089	2022-11-22 17:28:14.268089	2022
11	1	2022-11-23	1	23	24	4	1	2022-11-23 07:55:32.302944	2022-11-23 07:55:32.302944	2022
12	1	2022-11-23	2	19	20	4	1	2022-11-23 07:55:53.47912	2022-11-23 07:55:53.47912	2022
13	1	2022-11-23	4	17	18	4	1	2022-11-23 07:56:14.269312	2022-11-23 07:56:14.269312	2022
14	1	2022-11-24	5	21	22	4	1	2022-11-23 07:56:56.892843	2022-11-23 07:56:56.892843	2022
15	1	2022-11-24	1	27	28	4	1	2022-11-24 07:20:31.347379	2022-11-24 07:20:31.347379	2022
16	1	2022-11-24	2	31	32	4	1	2022-11-24 07:21:02.576296	2022-11-24 07:21:02.576296	2022
17	1	2022-11-24	4	29	30	4	1	2022-11-24 07:21:27.265304	2022-11-24 07:21:27.265304	2022
18	1	2022-11-25	5	25	26	4	1	2022-11-24 07:21:57.983564	2022-11-24 07:21:57.983564	2022
19	1	2022-11-25	1	7	8	4	1	2022-11-25 02:41:01.64087	2022-11-25 02:41:01.64087	2022
20	1	2022-11-25	2	4	2	4	1	2022-11-25 02:41:22.148967	2022-11-25 02:41:22.148967	2022
21	1	2022-11-25	4	3	1	4	1	2022-11-25 02:42:08.094302	2022-11-25 02:42:17.399769	2022
22	1	2022-11-26	5	5	6	4	1	2022-11-25 02:42:48.02977	2022-11-25 02:42:48.02977	2022
23	1	2022-11-26	1	16	14	4	1	2022-11-26 07:04:59.615825	2022-11-26 07:04:59.615825	2022
24	1	2022-11-26	2	12	10	4	1	2022-11-26 07:05:41.100867	2022-11-26 07:05:41.100867	2022
25	1	2022-11-26	4	13	15	4	1	2022-11-26 07:06:17.836136	2022-11-26 07:06:17.836136	2022
26	1	2022-11-27	5	9	11	4	1	2022-11-26 07:10:16.61921	2022-11-26 07:10:16.61921	2022
27	1	2022-11-27	1	20	18	4	1	2022-11-27 08:37:50.383283	2022-11-27 08:37:50.383283	2022
28	1	2022-11-27	2	21	23	4	1	2022-11-27 08:38:19.982702	2022-11-27 08:38:19.982702	2022
29	1	2022-11-27	4	24	22	4	1	2022-11-27 08:38:46.745604	2022-11-27 08:38:46.745604	2022
30	1	2022-11-28	5	17	19	4	1	2022-11-27 08:39:28.253552	2022-11-27 08:39:28.253552	2022
31	1	2022-11-28	1	28	26	4	1	2022-11-28 09:05:55.595194	2022-11-28 09:05:55.595194	2022
32	1	2022-11-28	2	32	30	4	1	2022-11-28 09:06:36.012753	2022-11-28 09:06:36.012753	2022
33	1	2022-11-28	4	25	27	4	1	2022-11-28 09:06:59.390576	2022-11-28 09:06:59.390576	2022
34	1	2022-11-29	5	29	31	4	1	2022-11-28 09:07:25.266562	2022-11-28 09:07:25.266562	2022
35	1	2022-11-29	3	3	4	4	1	2022-11-29 08:06:24.205668	2022-11-29 08:06:24.205668	2022
36	1	2022-11-29	3	1	2	4	1	2022-11-29 08:06:41.418024	2022-11-29 08:06:41.418024	2022
37	1	2022-11-30	5	7	5	4	1	2022-11-29 08:07:28.893813	2022-11-29 08:07:28.893813	2022
38	1	2022-11-30	5	8	6	4	1	2022-11-29 08:07:47.257756	2022-11-29 08:07:47.257756	2022
39	1	2022-11-30	3	14	15	4	1	2022-11-30 08:30:10.328299	2022-11-30 08:30:10.328299	2022
40	1	2022-11-30	3	16	13	4	1	2022-11-30 08:30:24.224901	2022-11-30 08:30:24.224901	2022
41	1	2022-12-01	5	12	9	4	1	2022-11-30 08:32:03.047244	2022-11-30 08:32:03.047244	2022
42	1	2022-12-01	5	10	11	4	1	2022-11-30 08:32:31.137329	2022-11-30 08:32:31.137329	2022
43	1	2022-12-01	3	24	21	4	1	2022-12-01 03:02:18.490902	2022-12-01 03:02:18.490902	2022
44	1	2022-12-01	3	22	23	4	1	2022-12-01 03:02:49.43359	2022-12-01 03:02:49.43359	2022
46	1	2022-12-02	5	18	19	4	1	2022-12-01 03:03:47.375419	2022-12-01 03:03:47.375419	2022
45	1	2022-12-02	5	20	17	4	1	2022-12-01 03:03:19.697138	2022-12-01 03:04:08.027905	2022
47	1	2022-12-02	3	30	31	4	1	2022-12-02 08:17:16.232151	2022-12-02 08:17:16.232151	2022
48	1	2022-12-02	3	32	29	4	1	2022-12-02 08:17:57.447047	2022-12-02 08:17:57.447047	2022
49	1	2022-12-03	5	26	27	4	1	2022-12-03 07:05:14.547495	2022-12-03 07:05:14.547495	2022
50	1	2022-12-03	5	28	25	4	1	2022-12-03 07:05:36.395587	2022-12-03 07:05:36.395587	2022
51	2	2022-12-03	3	3	6	4	1	2022-12-03 07:13:51.584836	2022-12-03 07:13:51.584836	2022
52	2	2022-12-04	5	9	14	4	1	2022-12-03 07:14:12.852179	2022-12-03 07:14:12.852179	2022
53	2	2022-12-04	3	13	12	4	1	2022-12-04 07:29:16.661601	2022-12-04 07:30:37.865824	2022
54	2	2022-12-05	5	5	2	4	1	2022-12-04 07:30:03.626269	2022-12-04 07:30:51.476568	2022
55	2	2022-12-05	3	20	24	4	1	2022-12-05 08:49:02.040068	2022-12-05 08:49:02.040068	2022
56	2	2022-12-06	5	25	32	4	1	2022-12-05 08:49:21.865285	2022-12-05 08:49:21.865285	2022
57	2	2022-12-06	3	23	17	4	1	2022-12-06 09:38:36.380987	2022-12-06 09:38:36.380987	2022
58	2	2022-12-07	5	29	27	4	1	2022-12-06 09:39:01.957305	2022-12-06 09:39:01.957305	2022
65	5	2022-12-17	3	24	23	4	1	2022-12-18 15:20:50.494928	2022-12-18 15:20:50.494928	2022
66	6	2022-12-18	3	9	13	4	1	2022-12-18 15:22:07.237708	2022-12-18 15:22:07.237708	2022
59	3	2022-12-09	3	24	25	4	1	2022-12-07 10:00:44.913156	2022-12-07 16:13:24.680051	2022
61	3	2022-12-10	3	23	29	4	1	2022-12-11 06:47:41.752767	2022-12-11 06:47:41.752767	2022
62	3	2022-12-11	5	5	13	4	1	2022-12-11 06:48:04.283549	2022-12-11 06:48:04.283549	2022
60	3	2022-12-10	5	3	9	4	1	2022-12-07 10:01:01.766384	2022-12-11 06:51:23.062674	2022
63	4	2022-12-14	5	9	24	4	1	2022-12-11 07:02:35.722569	2022-12-11 07:02:35.722569	2022
64	4	2022-12-15	5	13	23	4	1	2022-12-11 07:02:55.766001	2022-12-11 07:02:55.766001	2022
76	18	2026-06-14	10	128	129	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
77	18	2026-06-14	12	132	133	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
71	18	2026-06-12	11	119	121	4	1	2026-06-12 15:44:06.516588	2026-06-12 16:32:18.846325	2026
72	18	2026-06-13	5	122	125	3	1	2026-06-12 15:44:06.516588	2026-06-12 16:56:38.74148	2026
73	18	2026-06-13	10	130	131	5	1	2026-06-12 15:44:06.516588	2026-06-13 08:58:28.190429	2026
74	18	2026-06-14	5	124	123	4	1	2026-06-12 15:44:06.516588	2026-06-13 16:46:19.976452	2026
70	18	2026-06-12	5	118	120	5	1	2026-06-12 15:44:06.516588	2026-06-13 16:46:48.107194	2026
75	18	2026-06-14	8	126	127	5	2	2026-06-12 15:44:06.516588	2026-06-13 22:17:29.060728	2026
78	18	2026-06-15	6	134	135	5	1	2026-06-12 15:44:06.516588	2026-06-14 02:39:29.340809	2026
79	18	2026-06-15	7	138	139	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
80	18	2026-06-15	9	136	137	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
81	18	2026-06-15	11	140	141	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
84	18	2026-06-16	8	147	148	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
85	18	2026-06-16	10	143	145	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
87	18	2026-06-17	8	153	152	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
88	18	2026-06-17	10	154	156	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
89	18	2026-06-17	12	155	157	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
90	18	2026-06-18	6	158	161	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
91	18	2026-06-18	7	162	163	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
92	18	2026-06-18	9	164	165	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
93	18	2026-06-18	11	160	159	\N	1	2026-06-12 15:44:06.516588	2026-06-12 15:44:06.516588	2026
82	18	2026-06-15	4	146	149	5	1	2026-06-12 15:44:06.516588	2026-06-15 18:02:43.618743	2026
83	18	2026-06-16	5	142	144	3	1	2026-06-12 15:44:06.516588	2026-06-15 23:49:17.149163	2026
86	18	2026-06-17	5	150	151	2	1	2026-06-12 15:44:06.516588	2026-06-16 23:38:36.249874	2026
\.


--
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.results (id, fixture_id, home_goals, away_goals, created_at, updated_at, year) FROM stdin;
101	73	4	1	2026-06-13 03:32:07.953656	2026-06-13 03:32:07.953656	2026
102	74	1	1	2026-06-14 02:33:09.967524	2026-06-14 02:33:09.967524	2026
103	75	1	1	2026-06-14 02:33:33.353342	2026-06-14 02:33:33.353342	2026
104	76	0	1	2026-06-14 08:06:44.779432	2026-06-14 08:06:44.779432	2026
105	77	2	0	2026-06-14 08:07:20.16052	2026-06-14 08:07:20.16052	2026
109	81	5	1	2026-06-15 18:01:40.530878	2026-06-15 18:01:40.530878	2026
110	82	0	0	2026-06-15 18:01:58.653922	2026-06-15 18:01:58.653922	2026
111	83	1	1	2026-06-16 02:14:11.927973	2026-06-16 02:14:11.927973	2026
113	85	2	2	2026-06-16 14:51:42.195476	2026-06-16 14:51:42.195476	2026
114	86	3	1	2026-06-16 23:39:26.683043	2026-06-16 23:39:26.683043	2026
115	87	1	4	2026-06-17 09:16:34.191422	2026-06-17 09:16:34.191422	2026
118	90	1	1	2026-06-18 02:18:52.914403	2026-06-18 02:18:52.914403	2026
119	91	4	2	2026-06-18 02:19:09.350155	2026-06-18 02:19:09.350155	2026
121	93	1	3	2026-06-18 07:47:01.415142	2026-06-18 07:47:01.415142	2026
1	3	0	2	2022-11-22 09:14:20.301813	2022-11-22 09:14:20.301813	2022
2	4	6	2	2022-11-22 13:12:31.733841	2022-11-22 13:12:31.733841	2022
3	5	0	2	2022-11-22 13:14:10.694816	2022-11-22 13:14:10.694816	2022
4	6	1	1	2022-11-22 13:14:59.428784	2022-11-22 13:14:59.428784	2022
5	7	1	2	2022-11-22 13:15:38.194578	2022-11-22 13:15:38.194578	2022
6	8	0	0	2022-11-22 15:14:28.605434	2022-11-22 15:14:28.605434	2022
7	9	0	0	2022-11-22 17:56:02.392279	2022-11-22 17:56:02.392279	2022
40	10	4	1	2022-11-23 07:51:25.708155	2022-11-23 07:51:25.708155	2022
41	11	0	0	2022-11-23 12:15:30.30391	2022-11-23 12:15:30.30391	2022
42	12	1	2	2022-11-23 15:00:23.086765	2022-11-23 15:00:23.086765	2022
43	13	7	0	2022-11-24 07:19:48.468503	2022-11-24 07:19:48.468503	2022
44	14	1	0	2022-11-24 07:19:58.270421	2022-11-24 07:19:58.270421	2022
45	15	1	0	2022-11-24 12:14:01.254747	2022-11-24 12:14:01.254747	2022
46	16	0	0	2022-11-24 15:16:16.130776	2022-11-24 15:16:16.130776	2022
47	17	3	2	2022-11-24 17:58:30.271114	2022-11-24 17:58:30.271114	2022
48	18	2	0	2022-11-25 02:40:35.639219	2022-11-25 02:40:35.639219	2022
49	19	0	2	2022-11-25 13:02:43.452439	2022-11-25 13:02:43.452439	2022
50	20	1	3	2022-11-25 15:36:23.187307	2022-11-25 15:36:23.187307	2022
51	21	1	1	2022-11-25 17:56:52.618778	2022-11-25 17:56:52.618778	2022
52	22	0	0	2022-11-26 07:04:28.479352	2022-11-26 07:04:28.479352	2022
53	23	0	1	2022-11-26 14:53:49.041101	2022-11-26 14:53:49.041101	2022
54	24	2	0	2022-11-26 15:02:46.825374	2022-11-26 15:02:46.825374	2022
55	25	2	1	2022-11-26 17:56:45.021753	2022-11-26 17:56:45.021753	2022
56	26	2	0	2022-11-27 08:37:00.10665	2022-11-27 08:37:00.10665	2022
57	27	0	1	2022-11-27 12:19:20.628343	2022-11-27 12:19:20.628343	2022
58	28	0	2	2022-11-27 15:11:54.16325	2022-11-27 15:11:54.16325	2022
59	29	4	1	2022-11-27 18:00:06.706077	2022-11-27 18:00:06.706077	2022
60	30	1	1	2022-11-28 09:05:15.011266	2022-11-28 09:05:15.011266	2022
61	31	3	3	2022-11-28 13:03:07.942769	2022-11-28 13:03:07.942769	2022
62	32	2	3	2022-11-28 15:26:44.018853	2022-11-28 15:26:44.018853	2022
63	33	1	0	2022-11-29 08:05:26.978814	2022-11-29 08:05:26.978814	2022
64	34	2	0	2022-11-29 08:05:37.002777	2022-11-29 08:05:37.002777	2022
65	35	2	0	2022-11-30 08:28:55.366829	2022-11-30 08:28:55.366829	2022
66	36	1	2	2022-11-30 08:29:10.445125	2022-11-30 08:29:10.445125	2022
67	37	0	3	2022-11-30 08:29:22.137935	2022-11-30 08:29:22.137935	2022
68	38	0	1	2022-11-30 08:29:33.652494	2022-11-30 08:29:33.652494	2022
69	39	1	0	2022-11-30 16:55:35.471279	2022-11-30 16:55:35.471279	2022
70	40	1	0	2022-11-30 16:55:47.851385	2022-11-30 16:55:47.851385	2022
71	41	0	2	2022-12-01 03:00:17.28184	2022-12-01 03:00:17.28184	2022
72	42	1	2	2022-12-01 03:00:44.676919	2022-12-01 03:00:44.676919	2022
73	43	0	0	2022-12-02 08:15:40.685549	2022-12-02 08:15:40.685549	2022
74	44	1	2	2022-12-02 08:15:56.164178	2022-12-02 08:15:56.164178	2022
75	45	2	1	2022-12-02 08:16:10.758752	2022-12-02 08:16:10.758752	2022
76	46	2	4	2022-12-02 08:16:23.781469	2022-12-02 08:16:23.781469	2022
77	47	0	2	2022-12-03 07:02:30.42475	2022-12-03 07:02:30.42475	2022
78	48	2	1	2022-12-03 07:03:36.541857	2022-12-03 07:03:36.541857	2022
79	49	2	3	2022-12-03 07:07:01.483089	2022-12-03 07:07:01.483089	2022
80	50	1	0	2022-12-03 07:07:15.545315	2022-12-03 07:07:15.545315	2022
81	51	3	1	2022-12-04 07:28:28.110944	2022-12-04 07:28:28.110944	2022
82	52	2	1	2022-12-04 07:28:42.253293	2022-12-04 07:28:42.253293	2022
83	53	3	1	2022-12-05 08:48:23.725795	2022-12-05 08:48:23.725795	2022
84	54	3	0	2022-12-05 08:48:35.097955	2022-12-05 08:48:35.097955	2022
85	55	1	3	2022-12-06 09:37:49.045987	2022-12-06 09:37:49.045987	2022
86	56	4	1	2022-12-06 09:38:02.492357	2022-12-06 09:38:02.492357	2022
87	57	3	0	2022-12-06 18:05:57.69384	2022-12-06 18:05:57.69384	2022
88	58	6	1	2022-12-07 10:00:08.757491	2022-12-07 10:00:08.757491	2022
89	59	4	2	2022-12-09 17:47:51.668729	2022-12-09 17:47:51.668729	2022
90	60	3	4	2022-12-11 06:45:06.532538	2022-12-11 06:45:06.532538	2022
91	61	1	0	2022-12-11 06:48:54.073827	2022-12-11 06:48:54.073827	2022
92	62	1	2	2022-12-11 06:49:06.843063	2022-12-11 06:49:06.843063	2022
93	64	2	0	2022-12-18 15:19:02.892788	2022-12-18 15:19:02.892788	2022
94	63	3	0	2022-12-18 15:19:30.419251	2022-12-18 15:19:30.419251	2022
95	65	2	1	2022-12-18 15:22:20.900403	2022-12-18 15:22:20.900403	2022
97	66	4	2	2022-12-18 17:55:13.163658	2022-12-18 17:55:13.163658	2022
98	70	2	0	2026-06-12 16:54:47.234467	2026-06-12 16:54:47.234467	2026
99	71	2	1	2026-06-12 16:55:08.015989	2026-06-12 16:55:08.015989	2026
100	72	1	1	2026-06-12 23:27:08.183367	2026-06-12 23:27:08.183367	2026
106	78	7	1	2026-06-15 02:26:26.098584	2026-06-15 02:26:26.098584	2026
107	79	2	2	2026-06-15 02:26:53.985665	2026-06-15 02:26:53.985665	2026
108	80	1	0	2026-06-15 02:29:16.565495	2026-06-15 02:29:16.565495	2026
112	84	1	1	2026-06-16 02:14:30.98098	2026-06-16 02:14:30.98098	2026
116	88	3	0	2026-06-17 09:17:02.020929	2026-06-17 09:17:02.020929	2026
117	89	3	1	2026-06-17 09:18:11.001949	2026-06-17 09:18:11.001949	2026
120	92	1	0	2026-06-18 02:20:42.847571	2026-06-18 02:20:42.847571	2026
\.


--
-- Data for Name: rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rounds (id, sequence, name, year) FROM stdin;
1	1	RD1	2022
2	2	RD2	2022
3	3	QF	2022
4	4	SF	2022
5	5	3RD	2022
6	6	FIN	2022
18	1	Group	2026
19	2	Round of 32	2026
20	3	Round of 16	2026
21	4	Quarter-finals	2026
22	5	Semi-finals	2026
23	6	Final	2026
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20221121172059
20221121172439
20221122040622
20221122041013
20221122041729
20221122041829
20221122042036
20221122075844
20260611095309
20260611100604
20260612164408
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, sequence, "time") FROM stdin;
6	1	00:00:00
5	2	02:00:00
7	3	03:00:00
8	4	05:00:00
9	5	06:00:00
10	6	08:00:00
11	7	09:00:00
12	8	11:00:00
1	9	17:00:00
2	10	20:00:00
3	11	22:00:00
4	12	23:00:00
\.


--
-- Data for Name: standings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standings (id, team_id, wins, draws, losses, goals_for, goals_against, points, created_at, updated_at, year) FROM stdin;
1	1	1	1	1	4	3	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
2	2	2	0	1	5	4	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
3	3	2	1	0	5	1	7	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
4	4	0	0	3	1	7	0	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
5	5	2	1	0	9	2	7	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
6	6	1	2	0	2	1	5	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
7	7	0	1	2	1	6	1	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
8	8	1	0	2	4	7	3	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
9	9	2	0	1	5	2	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
10	10	1	0	2	3	5	3	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
11	11	1	1	1	2	3	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
12	12	1	1	1	2	2	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
13	13	2	0	1	6	3	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
14	14	2	0	1	3	4	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
15	15	0	1	2	1	3	1	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
16	16	1	1	1	1	1	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
17	17	1	1	1	9	3	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
18	18	1	0	2	3	11	3	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
19	19	1	1	1	6	5	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
20	20	2	0	1	4	3	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
21	21	1	1	1	1	2	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
22	22	0	0	3	2	7	0	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
23	23	2	1	0	4	1	7	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
24	24	1	2	0	4	1	5	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
25	25	2	0	1	3	1	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
26	26	0	1	2	5	8	1	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
27	27	2	0	1	4	3	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
28	28	1	1	1	4	4	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
29	29	2	0	1	6	4	6	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
30	30	1	0	2	5	7	3	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
31	31	1	1	1	2	2	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
32	32	1	1	1	4	4	4	2022-11-21 17:27:03.07805	2022-11-21 17:27:03.07805	2022
117	118	1	0	0	2	0	3	2026-06-11 15:06:48.288677	2026-06-12 16:54:47.229284	2026
119	120	0	0	1	0	2	0	2026-06-11 15:06:48.297976	2026-06-12 16:54:47.233575	2026
118	119	1	0	0	2	1	3	2026-06-11 15:06:48.292791	2026-06-12 16:55:08.012168	2026
120	121	0	0	1	1	2	0	2026-06-11 15:06:48.300992	2026-06-12 16:55:08.01524	2026
121	122	0	1	0	1	1	1	2026-06-11 15:06:48.303985	2026-06-12 23:27:08.180207	2026
124	125	0	1	0	1	1	1	2026-06-11 15:06:48.313681	2026-06-12 23:27:08.182658	2026
123	124	0	1	0	1	1	1	2026-06-11 15:06:48.310421	2026-06-14 02:33:09.96272	2026
122	123	0	1	0	1	1	1	2026-06-11 15:06:48.306995	2026-06-14 02:33:09.966732	2026
125	126	0	1	0	1	1	1	2026-06-11 15:06:48.316638	2026-06-14 02:33:33.350503	2026
129	130	1	0	0	4	1	3	2026-06-11 15:06:48.329875	2026-06-13 03:32:07.949675	2026
130	131	0	0	1	1	4	0	2026-06-11 15:06:48.332811	2026-06-13 03:32:07.951691	2026
126	127	0	1	0	1	1	1	2026-06-11 15:06:48.319582	2026-06-14 02:33:33.352615	2026
127	128	0	0	1	0	1	0	2026-06-11 15:06:48.323244	2026-06-14 08:06:44.774303	2026
128	129	1	0	0	1	0	3	2026-06-11 15:06:48.326816	2026-06-14 08:06:44.778516	2026
131	132	1	0	0	2	0	3	2026-06-11 15:06:48.335732	2026-06-14 08:07:20.156402	2026
132	133	0	0	1	0	2	0	2026-06-11 15:06:48.338681	2026-06-14 08:07:20.159588	2026
133	134	1	0	0	7	1	3	2026-06-11 15:06:48.342014	2026-06-15 02:26:26.094845	2026
134	135	0	0	1	1	7	0	2026-06-11 15:06:48.345172	2026-06-15 02:26:26.097725	2026
137	138	0	1	0	2	2	1	2026-06-11 15:06:48.354001	2026-06-15 02:26:53.982577	2026
138	139	0	1	0	2	2	1	2026-06-11 15:06:48.356914	2026-06-15 02:26:53.984841	2026
135	136	1	0	0	1	0	3	2026-06-11 15:06:48.348122	2026-06-15 02:29:16.562936	2026
136	137	0	0	1	0	1	0	2026-06-11 15:06:48.351053	2026-06-15 02:29:16.564842	2026
139	140	1	0	0	5	1	3	2026-06-11 15:06:48.36083	2026-06-15 18:01:40.527298	2026
140	141	0	0	1	1	5	0	2026-06-11 15:06:48.363809	2026-06-15 18:01:40.530104	2026
145	146	0	1	0	0	0	1	2026-06-11 15:06:48.380093	2026-06-15 18:01:58.651425	2026
148	149	0	1	0	0	0	1	2026-06-11 15:06:48.390131	2026-06-15 18:01:58.653291	2026
141	142	0	1	0	1	1	1	2026-06-11 15:06:48.366744	2026-06-16 02:14:11.924032	2026
143	144	0	1	0	1	1	1	2026-06-11 15:06:48.372622	2026-06-16 02:14:11.927226	2026
146	147	0	1	0	1	1	1	2026-06-11 15:06:48.383551	2026-06-16 02:14:30.977292	2026
147	148	0	1	0	1	1	1	2026-06-11 15:06:48.386712	2026-06-16 02:14:30.980158	2026
142	143	0	1	0	2	2	1	2026-06-11 15:06:48.369693	2026-06-16 14:51:42.188673	2026
144	145	0	1	0	2	2	1	2026-06-11 15:06:48.3768	2026-06-16 14:51:42.193526	2026
149	150	1	0	0	3	1	3	2026-06-11 15:06:48.393364	2026-06-16 23:39:26.680483	2026
150	151	0	0	1	1	3	0	2026-06-11 15:06:48.396418	2026-06-16 23:39:26.682381	2026
152	153	0	0	1	1	4	0	2026-06-11 15:06:48.402321	2026-06-17 09:16:34.188945	2026
151	152	1	0	0	4	1	3	2026-06-11 15:06:48.399364	2026-06-17 09:16:34.190756	2026
153	154	1	0	0	3	0	3	2026-06-11 15:06:48.405922	2026-06-17 09:17:02.018012	2026
155	156	0	0	1	0	3	0	2026-06-11 15:06:48.41241	2026-06-17 09:17:02.02027	2026
154	155	1	0	0	3	1	3	2026-06-11 15:06:48.409379	2026-06-17 09:18:10.999364	2026
156	157	0	0	1	1	3	0	2026-06-11 15:06:48.41537	2026-06-17 09:18:11.001287	2026
157	158	0	1	0	1	1	1	2026-06-11 15:06:48.418327	2026-06-18 02:18:52.911732	2026
160	161	0	1	0	1	1	1	2026-06-11 15:06:48.427796	2026-06-18 02:18:52.913733	2026
161	162	1	0	0	4	2	3	2026-06-11 15:06:48.430784	2026-06-18 02:19:09.347665	2026
162	163	0	0	1	2	4	0	2026-06-11 15:06:48.433745	2026-06-18 02:19:09.349502	2026
163	164	1	0	0	1	0	3	2026-06-11 15:06:48.437341	2026-06-18 02:20:42.844865	2026
164	165	0	0	1	0	1	0	2026-06-11 15:06:48.440325	2026-06-18 02:20:42.846892	2026
159	160	0	0	1	1	3	0	2026-06-11 15:06:48.424632	2026-06-18 07:47:01.409969	2026
158	159	1	0	0	3	1	3	2026-06-11 15:06:48.421473	2026-06-18 07:47:01.414326	2026
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (id, name, "group", ranking, flag, year) FROM stdin;
1	Ecuador	A	1	ecu.png	2022
2	Senegal	A	2	sen.png	2022
3	Netherlands	A	3	ned.png	2022
4	Qatar	A	4	qat.png	2022
5	England 	B	1	eng.png	2022
6	United States	B	2	usa.png	2022
7	Wales	B	3	wal.png	2022
8	Iran	B	4	irn.png	2022
9	Argentina	C	1	arg.png	2022
10	Saudi Arabia	C	2	ksa.png	2022
11	Mexico	C	3	mex.png	2022
12	Poland 	C	4	pol.png	2022
13	France 	D	1	fra.png	2022
14	Australia	D	2	aus.png	2022
15	Denmark 	D	3	den.png	2022
16	Tunisia	D	4	tun.png	2022
17	Spain 	E	1	esp.png	2022
18	Costa Rica	E	2	crc.png	2022
19	Germany 	E	3	ger.png	2022
20	Japan	E	4	jpn.png	2022
21	Belgium 	F	1	bel.png	2022
22	Canada	F	2	can.png	2022
23	Morocco	F	3	mar.png	2022
24	Croatia	F	4	cro.png	2022
25	Brazil	G	1	bra.png	2022
26	Serbia 	G	2	srb.png	2022
27	Switzerland 	G	3	sui.png	2022
28	Cameroon	G	4	cmr.png	2022
29	Portugal 	H	1	por.png	2022
30	Ghana	H	2	gha.png	2022
31	Uruguay	H	3	uru.png	2022
32	South Korea	H	4	kor.png	2022
133	Turkey	D	22	turkiye_flag.png	2026
136	Ivory Coast	E	48	ivory_coast_flag.png	2026
135	Curacao	E	82	curacao_flag.png	2026
118	Mexico	A	16	mexico_flag.png	2026
119	South Korea	A	23	south_korea_flag.png	2026
120	South Africa	A	66	south_africa_flag.png	2026
121	Czechia	A	40	czechia_flag.png	2026
122	Canada	B	39	canada_flag.png	2026
123	Switzerland	B	19	switzerland_flag.png	2026
124	Qatar	B	37	qatar_flag.png	2026
125	Bosnia and Herzegovina	B	65	bosnia_flag.png	2026
126	Brazil	C	6	brazil_flag.png	2026
127	Morocco	C	8	morocco_flag.png	2026
128	Haiti	C	83	haiti_flag.png	2026
129	Scotland	C	43	scotland_flag.png	2026
130	United States	D	16	usa_flag.png	2026
131	Paraguay	D	40	paraguay_flag.png	2026
132	Australia	D	20	australia_flag.png	2026
134	Germany	E	10	germany_flag.png	2026
137	Ecuador	E	44	ecuador_flag.png	2026
138	Netherlands	F	7	netherlands_flag.png	2026
139	Japan	F	18	japan_flag.png	2026
140	Sweden	F	17	sweden_flag.png	2026
141	Tunisia	F	30	tunisia_flag.png	2026
142	Belgium	G	3	belgium_flag.png	2026
143	Iran	G	22	iran_flag.png	2026
144	Egypt	G	35	egypt_flag.png	2026
145	New Zealand	G	97	new_zealand_flag.png	2026
146	Spain	H	3	spain_flag.png	2026
147	Saudi Arabia	H	56	saudi_arabia_flag.png	2026
148	Uruguay	H	11	uruguay_flag.png	2026
149	Cape Verde	H	75	cape_verde_flag.png	2026
150	France	I	2	france_flag.png	2026
151	Senegal	I	18	senegal_flag.png	2026
152	Norway	I	44	norway_flag.png	2026
153	Iraq	I	63	iraq_flag.png	2026
154	Argentina	J	1	argentina_flag.png	2026
155	Austria	J	25	austria_flag.png	2026
156	Algeria	J	30	algeria_flag.png	2026
157	Jordan	J	63	jordan_flag.png	2026
158	Portugal	K	6	portugal_flag.png	2026
159	Colombia	K	13	colombia_flag.png	2026
160	Uzbekistan	K	50	uzbekistan_flag.png	2026
161	DR Congo	K	46	dr_congo_flag.png	2026
162	England	L	4	england_flag.png	2026
163	Croatia	L	10	croatia_flag.png	2026
164	Ghana	L	74	ghana_flag.png	2026
165	Panama	L	33	panama_flag.png	2026
\.


--
-- Data for Name: temp_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.temp_table (team_id, "W", "D", "L", "GF", "GA", "Pts") FROM stdin;
29	2	0	1	6	4	6
30	1	0	2	5	7	3
31	1	1	1	2	2	4
32	1	1	1	4	4	4
\.


--
-- Name: channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.channels_id_seq', 5, true);


--
-- Name: criteria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.criteria_id_seq', 2, true);


--
-- Name: fixtures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fixtures_id_seq', 93, true);


--
-- Name: results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.results_id_seq', 121, true);


--
-- Name: rounds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rounds_id_seq', 23, true);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sessions_id_seq', 5, true);


--
-- Name: standings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.standings_id_seq', 164, true);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teams_id_seq', 165, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: criteria criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criteria
    ADD CONSTRAINT criteria_pkey PRIMARY KEY (id);


--
-- Name: fixtures fixtures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures
    ADD CONSTRAINT fixtures_pkey PRIMARY KEY (id);


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: rounds rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rounds
    ADD CONSTRAINT rounds_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: standings standings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standings
    ADD CONSTRAINT standings_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: index_fixtures_on_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fixtures_on_channel_id ON public.fixtures USING btree (channel_id);


--
-- Name: index_fixtures_on_criterium_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fixtures_on_criterium_id ON public.fixtures USING btree (criterium_id);


--
-- Name: index_fixtures_on_round_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fixtures_on_round_id ON public.fixtures USING btree (round_id);


--
-- Name: index_fixtures_on_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fixtures_on_session_id ON public.fixtures USING btree (session_id);


--
-- Name: index_fixtures_on_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fixtures_on_year ON public.fixtures USING btree (year);


--
-- Name: index_results_on_fixture_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_results_on_fixture_id ON public.results USING btree (fixture_id);


--
-- Name: index_standings_on_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_standings_on_team_id ON public.standings USING btree (team_id);


--
-- Name: index_standings_on_team_id_and_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_standings_on_team_id_and_year ON public.standings USING btree (team_id, year);


--
-- Name: index_teams_on_name_and_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_teams_on_name_and_year ON public.teams USING btree (name, year);


--
-- Name: index_teams_on_year_and_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_teams_on_year_and_group ON public.teams USING btree (year, "group");


--
-- Name: index_teams_on_year_and_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_teams_on_year_and_name ON public.teams USING btree (year, name);


--
-- Name: fixtures fk_rails_0c45715fb6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures
    ADD CONSTRAINT fk_rails_0c45715fb6 FOREIGN KEY (criterium_id) REFERENCES public.criteria(id);


--
-- Name: results fk_rails_24208fad15; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_24208fad15 FOREIGN KEY (fixture_id) REFERENCES public.fixtures(id);


--
-- Name: fixtures fk_rails_45a97a2b64; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures
    ADD CONSTRAINT fk_rails_45a97a2b64 FOREIGN KEY (session_id) REFERENCES public.sessions(id);


--
-- Name: fixtures fk_rails_9af4cca3ac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures
    ADD CONSTRAINT fk_rails_9af4cca3ac FOREIGN KEY (round_id) REFERENCES public.rounds(id);


--
-- Name: fixtures fk_rails_e99c2e4db6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures
    ADD CONSTRAINT fk_rails_e99c2e4db6 FOREIGN KEY (channel_id) REFERENCES public.channels(id);


--
-- Name: standings fk_rails_e9d6ea91b3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standings
    ADD CONSTRAINT fk_rails_e9d6ea91b3 FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

