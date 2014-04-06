-- CREATE DATABASE db_name;
-- CREATE USER 'db_user'@'%' IDENTIFIED BY 'db_password';
-- GRANT ALL ON DATABASE.* to 'db_user'@'%'

-- setup password for root user
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'172.17.%.%' IDENTIFIED BY '' WITH GRANT OPTION;
FLUSH PRIVILEGES;
