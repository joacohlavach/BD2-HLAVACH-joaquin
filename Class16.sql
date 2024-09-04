#HLAVACH JOAQUIN - Saque el create y los inserts

-- 1 Insert a new employee to , but with an null email. Explain what happens.
insert into employees (firstName, lastName, email) values ('Joaquin', 'Hlavach', null);
/*
No se puede ingresar un valor nulo en el campo de email, ya que la columna email está definida como not null, 
y se generará un error y no se permitirá que sea nulo.
*/

-- 2 Run the first the query
UPDATE employees SET employeeNumber = employeeNumber - 20;
/*
La consulta disminuye en 20 el valor de employeeNumber para todos los registros de la tabla employees, 
afectando a todos los empleados sin excepción, ya que no hay ningún where. Es decir que cuando le restas, se generan duplicados.
*/

UPDATE employees SET employeeNumber = employeeNumber + 20;
/*
La consulta aumenta en 20 el valor de `employeeNumber` para todos los registros de la tabla `employees`, 
afectando a todos los empleados sin excepciones. Podrían haber conflictos en caso de que haya algun duplicado.
*/

-- 3 Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
alter table employees
add age int check (age >= 16 and age <= 70);

-- 4 Describe the referential integrity between tables film, actor and film_actor in sakila db.
/*
# En la base de datos sakila, la integridad referencial entre las tablas film, actor y film_actor se establece a través de claves externas:
- film_actor relaciona películas (film_id) con actores (actor_id).
- film_id en film_actor referencia a film_id en film.
- actor_id en film_actor referencia a actor_id en actor.
*/

-- 5 Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. 
-- Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed 
-- the row (assume multiple users, other than root, can connect to MySQL and change this table).

alter table employees add lastUpdate datetime;
alter table employees add lastUpdateUser varchar(100);

delimiter //
create trigger before_employee_insert before insert on employees for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end; //

create trigger before_employee_update before update on employees for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end;
delimiter ;

-- 6 Find all the triggers in sakila db related to loading film_text table. What do they do?
--  Explain each of them using its source code for the explanation. 

show triggers from sakila;
# 'ins_film', 'INSERT', 'film', 'BEGIN\n    INSERT INTO film_text (film_id, title, description)\n        VALUES (new.film_id, new.title, new.description);\n  END', 'AFTER', '2024-04-09 12:43:18.13', 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION', 'joaco@%', 'utf8mb4', 'utf8mb4_general_ci', 'latin1_swedish_ci'
# 'upd_film', 'UPDATE', 'film', 'BEGIN\n    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)\n    THEN\n        UPDATE film_text\n            SET title=new.title,\n                description=new.description,\n                film_id=new.film_id\n        WHERE film_id=old.film_id;\n    END IF;\n  END', 'AFTER', '2024-04-09 12:43:18.16', 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION', 'joaco@%', 'utf8mb4', 'utf8mb4_general_ci', 'latin1_swedish_ci'
# 'del_film', 'DELETE', 'film', 'BEGIN\n    DELETE FROM film_text WHERE film_id = old.film_id;\n  END', 'AFTER', '2024-04-09 12:43:18.17', 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION', 'joaco@%', 'utf8mb4', 'utf8mb4_general_ci', 'latin1_swedish_ci'

/*
- ins_film_text:
Este trigger se activa después de insertar un nuevo registro en film. 
Su función es crear automáticamente un registro en film_text con el título y la descripción de la nueva película, 
manteniendo la información sincronizada entre ambas tablas.

- upd_film_text:
Este trigger se activa después de actualizar un registro en film. 
Actualiza el título y la descripción en film_text, asegurando que los cambios realizados en film
se reflejen también en film_text.

- del_film_text:
Este trigger se activa después de eliminar un registro en film.
Borra el registro correspondiente en film_text, evitando que queden datos sin una película asociada, 
manteniendo la base de datos coherente.

*/