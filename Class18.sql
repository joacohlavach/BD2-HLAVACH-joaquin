#HLAVACH JOAQUIN - Class18

#1 
DELIMITER //

CREATE FUNCTION get_film_copies(film_identifier VARCHAR(255), store_id INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE film_id INT;
    DECLARE copies INT;

    -- Verificamos que sea un número (film ID)
    IF film_identifier REGEXP '^[0-9]+$' THEN
        SET film_id = CAST(film_identifier AS UNSIGNED);
    ELSE
        -- Si no lo es, buscamos el nombre de la película
        SELECT f.film_id INTO film_id
        FROM film f
        WHERE f.title = film_identifier
        LIMIT 1;
    END IF;

    -- Obtenemos el número de copias de la película en la tienda especificada
    SELECT COUNT(*) INTO copies
    FROM inventory i
    WHERE i.film_id = film_id AND i.store_id = store_id;

    RETURN copies;
END //

DELIMITER ;

SELECT get_film_copies('ACE GOLDFINGER', 1);
SELECT get_film_copies('1', 1); 

#2
DELIMITER //

CREATE PROCEDURE get_customers_by_country(IN country_name VARCHAR(255), OUT customer_list VARCHAR(1000))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE customer_name VARCHAR(255);
    DECLARE first_name VARCHAR(255);
    DECLARE last_name VARCHAR(255);
    
    -- Empezamos el cursor
    DECLARE customer_cursor CURSOR FOR
        SELECT CONCAT(c.first_name, ' ', c.last_name) FROM customer c
        INNER JOIN address a ON c.address_id = a.address_id
        INNER JOIN city ci ON a.city_id = ci.city_id
        INNER JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = country_name;

    -- Declaramos el handler para establecer la variable done
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET customer_list = '';

    -- Abrimos el cursor
    OPEN customer_cursor;

    read_loop: LOOP
        FETCH customer_cursor INTO customer_name;
        IF done THEN 
        LEAVE read_loop;
        END IF;

        -- Agregamos el nombre del cliente a la lista
        SET customer_list = CONCAT(customer_list, customer_name, ';');
    END LOOP;

    -- Cerramos el cursor
    CLOSE customer_cursor;

END //

DELIMITER ;

CALL get_customers_by_country('Argentina', @customer_names);
SELECT @customer_names;

#3

/* 
La función `inventory_in_stock` retorna un valor `tinyint(1)` (Verdadero o Falso). Dentro de la función se declaran 
dos variables: una que almacena la cantidad total de alquileres asociados a la película, y otra que guarda el número
de alquileres activos, es decir, aquellos que aún no tienen una `return_date`. Si al menos uno de los ítems en el 
inventario tiene una `return_date` registrada, la función devuelve 1; en caso de que ninguno tenga una fecha de
devolución, devuelve 0.
*/
SET @result = inventory_in_stock(10);
SELECT @result;

SET @result = inventory_in_stock(11);
SELECT @result;

SET @result = inventory_in_stock(12);
SELECT @result;

/* 
El stored procedure film_in_stock devuelve la cantidad de películas que tengan
el mismo id, de la tienda especificada, que se le pasa como párametro.
*/

CALL film_in_stock(1, 1, @result);
SELECT @result;

CALL film_in_stock(2, 2, @result);
SELECT @result;

CALL film_in_stock(2, 3, @result);
SELECT @result;