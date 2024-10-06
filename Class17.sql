#HLAVACH JOAQUIN - Class17

use sakila;

# 1

SELECT * FROM address;
SET profiling = 1;

SELECT * FROM address a
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code IN ('7716', '99865', '99780', '58327');

SELECT * FROM address a
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('7716', '99865', '99780', '58327'); 

-- Vemos el tiempo de ejecución:
SHOW PROFILES;
/* 
'1', '0.00372200', 'SELECT * FROM address a\nINNER JOIN city c ON a.city_id = c.city_id\nINNER JOIN country co ON c.country_id = co.country_id\nWHERE postal_code IN (\'7716\', \'99865\', \'99780\', \'58327\')\nLIMIT 0, 1000'
'2', '0.00865050', 'SELECT * FROM address a\nINNER JOIN city c ON a.city_id = c.city_id\nINNER JOIN country co ON c.country_id = co.country_id\nWHERE postal_code NOT IN (\'7716\', \'99865\', \'99780\', \'58327\')\nLIMIT 0, 1000'
*/

CREATE INDEX idx_postal_code ON address(postal_code);

SELECT * FROM address a
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code IN ('7716', '99865', '99780', '58327');

SELECT * FROM address a
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('7716', '99865', '99780', '58327'); 

SHOW PROFILES;
/*
'3', '0.00162500', 'SELECT * FROM address a\nINNER JOIN city c ON a.city_id = c.city_id\nINNER JOIN country co ON c.country_id = co.country_id\nWHERE postal_code IN (\'7716\', \'99865\', \'99780\', \'58327\')\nLIMIT 0, 1000'
'4', '0.01395700', 'SELECT * FROM address a\nINNER JOIN city c ON a.city_id = c.city_id\nINNER JOIN country co ON c.country_id = co.country_id\nWHERE postal_code NOT IN (\'7716\', \'99865\', \'99780\', \'58327\')\nLIMIT 0, 1000'
*/

/* 
Con el índice, el motor de la base de datos debe localizar esos valores en el índice
para obtener las direcciones de las filas de la tabla que contienen los registros con el valor indicado
en la cláusula WHERE. La cláusula WHERE consulta el índice, recupera las direcciones de las filas, y luego
con esas direcciones se buscan los registros en la tabla para ser devueltos. 
Las consultas que utilizan NOT IN pueden experimentar un aumento en el tiempo de ejecución, 
ya que requieren verificar múltiples condiciones, lo que puede ser menos eficiente.
*/

#2
SELECT * FROM actor
WHERE first_name = 'DAN';

SELECT * FROM actor
WHERE last_name = 'CHASE';

/* No hay casi diferencia en el tiempo de ejecucion pero existe un índice para el apellido */

#3
ALTER TABLE film ADD FULLTEXT (description);

SELECT * FROM film
WHERE description LIKE '%action%';


SELECT * FROM film
WHERE MATCH(description) AGAINST('action');

/* 
En términos de rendimiento, en esta base de datos es prácticamente indetectable. 
Un índice FULLTEXT está optimizado para gestionar de manera eficiente consultas que se basan en lenguaje natural, 
las cuales implican la búsqueda de palabras o frases en las columnas de texto de una tabla. 
*/

