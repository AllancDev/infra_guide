CREATE DATABASE IF NOT EXISTS radius_db;
CREATE USER IF NOT EXISTS 'radius'@'%' IDENTIFIED BY 'radiuspassword';
GRANT ALL PRIVILEGES ON radius_db.* TO 'radius'@'%';

USE radius_db;