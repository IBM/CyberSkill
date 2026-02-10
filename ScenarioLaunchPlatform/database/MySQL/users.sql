DROP USER IF EXISTS 'polly'@'localhost';
DROP USER IF EXISTS 'john'@'localhost';
DROP USER IF EXISTS 'jason'@'localhost';
DROP USER IF EXISTS 'liher'@'localhost';

CREATE USER IF NOT EXISTS 'polly'@'localhost' IDENTIFIED BY 'Password1!';
CREATE USER IF NOT EXISTS 'liher'@'localhost' IDENTIFIED BY 'Password1!';
CREATE USER IF NOT EXISTS 'jason'@'localhost' IDENTIFIED BY 'Password1!';
CREATE USER IF NOT EXISTS 'john'@'localhost' IDENTIFIED BY 'Password1!';

-- CREATE USER 'polly'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!';
-- CREATE USER 'john'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!';
-- CREATE USER 'jason'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!';
-- CREATE USER 'liher'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!';

GRANT ALL PRIVILEGES ON *.* TO 'polly'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'liher'@'localhost' WITH GRANT OPTION;

GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,EXECUTE ON salesDB.* TO 'john'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,EXECUTE ON crm.* TO 'john'@'localhost';

GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,EXECUTE ON salesDB.* TO 'jason'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,EXECUTE ON crm.* TO 'jason'@'localhost';

FLUSH PRIVILEGES;