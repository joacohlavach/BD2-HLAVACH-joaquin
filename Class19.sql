#HLAVACH JOAQUIN - Class19

#1 - Create a user data_analyst
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY '1234';

#2 - Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost' WITH GRANT OPTION;

#3 - Login with this user and try to create a table. Show the result of that operation.

-- LOGIN WITH data_analyst USER
CREATE TABLE data_name (
    id INT AUTO_INCREMENT PRIMARY KEY
    );
-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'data_name'

#4 - Try to update a title of a film. Write the update script.title 
UPDATE film
SET title = 'MOMOO'
WHERE film_id = 1;

#5 - With root or any admin user revoke the UPDATE permission. Write the command

-- LOGIN WITH root USER
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';

#6 - Login again with data_analyst and try again the update done in step 4. Show the result.

-- LOGOUT AND LOGIN WITH data_analyst USER
UPDATE film
SET title = 'MOMASO'
WHERE film_id = 1;
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
