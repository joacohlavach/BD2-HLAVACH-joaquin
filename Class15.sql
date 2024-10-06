#HLAVACH JOAQUIN - Class15

/*1 - Create a view named list_of_customers*/
use sakila;

CREATE OR REPLACE VIEW list_of_customers AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    a.address,
    a.postal_code,
    a.phone,
    ci.city,
    co.country,
    CASE 
        WHEN c.active = 1 THEN 'active' 
        ELSE 'inactive' 
    END AS status,
    s.store_id
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
INNER JOIN store s on a.address_id = s.address_id;

SELECT * FROM list_of_customers;

/*2 - Create a view named film_details, it should contain the following columns: film id, title, description, category, 
price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT */

CREATE OR REPLACE VIEW film_details AS
SELECT f.film_id,
       f.title,
       f.description,
       c.name,
       f.replacement_cost,
       f.length,
       f.rating,
       GROUP_CONCAT(a.first_name, ' ', a.last_name)
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, c.name, f.replacement_cost, f.length, f.rating;

SELECT * FROM film_details;

/*3 - Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.*/

CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT c.name, COUNT(r.rental_id) AS 'total_rental'
FROM category c
         INNER JOIN film_category fc ON c.category_id = fc.category_id
         INNER JOIN film f ON fc.film_id = f.film_id
         INNER JOIN inventory i ON f.film_id = i.film_id
         INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

SELECT * FROM sales_by_film_category;

/*4 - Create a view called actor_information where it should return, actor id, 
first name, last name and the amount of films he/she acted on.*/

CREATE OR REPLACE VIEW actor_information AS
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       COUNT(DISTINCT fa.film_id) AS films_count
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

SELECT * FROM actor_information;

/*5 - Analyze view actor_info, explain the entire query and specially how the sub query works. 
Be very specific, take some time and decompose each part and give an explanation for each.*/

/* Lo hice con un GROUP BY ya que me pareció más sencillo de hacerlo en vez de usar una subquery.
   Selecciono los valores pedidos por la consigna (actor_id, first_name y last_name),
   luego hago un LEFT JOIN para "unir" todos los actores, incluso aquellos que no han actuado en ninguna película
   (debería devolver 0 como films_count), y luego hago un COUNT(DISTINCT film_id) para que cuente todos los IDs
   distintos de películas en las que aparece el ID del actor.
   Por último, el GROUP BY agrupa los valores (actor_id, first_name y last_name) para que no aparezca una fila
   por cada película actuada por ese actor.*/
   
/*6 - Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.*/

/* Una MATERIALIZED VIEW es un objeto de base de datos que almacena físicamente el resultado de una consulta SQL,
   permitiendo una recuperación de datos más rápida, especialmente para consultas complejas. Se utilizan para mejorar
   el rendimiento al reducir el tiempo de respuesta y optimizar recursos,  ya que si se necesita acceder frecuentemente a esos datos, estos ya
   estan precargados desde el arranque de la base de datos. Alternativas incluyen vistas regulares, tablas temporales e índices.
   Las MATERIALIZED VIEWS existen en varios DBMS como "Oracle", "PostgreSQL", "Microsoft SQL Server" (como "Indexed Views")
   y "MySQL". */
