use sakila;

#1 - Encuentra las películas de menor duración, muestra el título y calificación.
SELECT f.title AS 'Título', f.rating AS 'Rating', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` <= ALL (SELECT `length` FROM film);

#2 - Escriba una consulta que devuelva el título de la película cuya duración es la más baja. 
#Si hay más de una película con la duración más baja, la consulta devuelve un conjunto de resultados vacío.
SELECT f.title AS 'Título', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` < ALL (SELECT `length` FROM film);

#3 - #Generar un informe con listado de clientes mostrando los pagos más bajos realizados por cada uno de ellos. 
#Mostrar información del cliente, la dirección y el importe más bajo.
#Proporcione ambas soluciones usando ALL and/or ANY and MIN.

#all
SELECT c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    p.amount AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount <= ALL (
        SELECT p2.amount
        FROM payment p2
        WHERE p2.customer_id = c.customer_id);

#min
SELECT c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    MIN(p.amount) AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id,
    c.first_name,
    c.last_name,
    a.address;

#4 - Genera un informe que muestre la información del cliente con el pago más alto y el pago más bajo en una misma fila.
select c.*, (select max(p.amount) from payment p where c.customer_id=p.customer_id) as highest, (select min(amount) from payment p where c.customer_id=p.customer_id) as lowest from customer c;