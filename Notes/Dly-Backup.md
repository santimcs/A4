
# Backup Process for Music from Old to New

For ruby, should clear unused files before save
rails tmp:cache:clear
rails log:clear

cd\Users\User\OneDrive\A4\data

ruby db_backup_old_to_new.rb music_development May-31

# Restore process

MySQL

cd\Users\PC1\OneDrive\Documents\Backup\mysql

C:\xampp\MySQL\bin\mysql.exe -u root -p music_development < music_development_May-31.sql

# Backup Process for Music from New to Old

cd\Users\PC1\OneDrive\A4\data

ruby db_backup_new_to_old.rb music_development JUN-01

# Restore process for Music from New to Old

MySQL

cd\Users\User\OneDrive\Documents\Backup\mysql

C:\xampp\MySQL\bin\mysql.exe -u root -p music_development < music_development_Jun-01.sql