-- CREATE DATABASE db_name;
-- CREATE USER 'db_user'@'%' IDENTIFIED BY 'db_password';
-- GRANT ALL ON DATABASE.* to 'db_user'@'%'

-- setup password for root user
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root123' WITH GRANT OPTION;
FLUSH PRIVILEGES;
