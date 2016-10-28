CREATE USER "%dbuser"@"localhost" IDENTIFIED BY "%password";
CREATE DATABASE %database_name;
GRANT ALL PRIVILEGES ON %database_name.* TO "%dbuser"@"localhost" WITH GRANT OPTION;
