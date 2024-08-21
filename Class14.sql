-- Joaquin Hlavach

-- 1. Obtener todos los clientes que viven en argentina, mostrando su nombre completo, dirección y ciudad.
select concat(c.first_name, ' ', c.last_name) as full_name, a.address, ci.city
from customer c
inner join address a on c.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country co on ci.country_id = co.country_id
where co.country = 'argentina';

-- 2. Mostrar el título de la película, el idioma y la clasificación con texto completo según el sistema de clasificación de estados unidos.
select f.title,
       l.name as language,
       case
           when f.rating = 'g' then 'g (general audiences) – all ages admitted.'
           when f.rating = 'pg' then 'pg (parental guidance suggested) – some material may not be suitable for children.'
           when f.rating = 'pg-13' then 'pg-13 (parents strongly cautioned) – some material may be inappropriate for children under 13.'
           when f.rating = 'r' then 'r (restricted) – under 17 requires accompanying parent or adult guardian.'
           when f.rating = 'nc-17' then 'nc-17 (adults only) – no one 17 and under admitted.'
       end as rating
from film f
inner join language l on f.language_id = l.language_id;

-- 3. Mostrar todas las películas (título y año de estreno) en las que un actor participó.
select f.title, f.release_year
from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where upper(a.first_name) = upper(trim('penelope'))
  and upper(a.last_name) = upper(trim('guiness'));

-- 4. Encontrar todos los alquileres realizados en los meses de mayo y junio. mostrar el título de la película, el nombre del cliente y si fue devuelta o no.
select f.title, concat(c.first_name, ' ', c.last_name) as customer_name,
       case
           when rental.return_date > now() then 'no'
           when rental.return_date <= now() then 'yes'
       end as returned
from rental
inner join customer c on rental.customer_id = c.customer_id
inner join inventory i on rental.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where month(rental.rental_date) in (5, 6);


/* Funciones cast() y convert():
	Permiten modificar el tipo de dato de una expresión. Existen algunas diferencias importantes entre ambos:
    Cast() se utiliza para transformar explícitamente un valor a un tipo de dato específico. Por ejemplo: */
select cast(length as nchar(3)) as duracion
from film;
/* En este caso, la duración de una película se convierte a nchar (carácter nacional).

   El convert() cumple la misma función que cast() pero ofrece funcionalidades adicionales
   para manejar conversiones de tipos de datos. Ejemplo: */
select convert(last_update, date) as fecha_actualizacion
from film;
/* En este caso el convert() cambia un valor en formato timestamp a tipo date.

   Principales diferencias:
   - Conversión de conjuntos de caracteres: si se requiere convertir tanto el tipo de dato como el conjunto de caracteres,
		es mejor usar convert(), ya que permite especificar el conjunto de caracteres mediante la palabra reservada using.
   - Compatibilidad: cast() es parte del estándar sql, lo que lo hace ampliamente compatible con diversos sistemas de bases de datos,
		mientras que convert() es específico de mysql. Por razones de portabilidad, se recomienda usar cast(). */

/* Funciones nvl(), isnull(), ifnull() y coalesce():
	Se utilizan en distintos motores de bases de datos para gestionar valores nulos o desconocidos en las consultas.

   - nvl():
	Es exclusiva de oracle. Se emplea para reemplazar un valor nulo por otro valor determinado. Ejemplo:
		select nvl(columna, 'valor por defecto') from tabla;

   - isnull():
	Es propia de microsoft sql server. Al igual que nvl(), se usa para evaluar si una expresión es nula
	y, en caso afirmativo, devolver un valor alternativo. Ejemplo:
		select isnull(columna, 'valor por defecto') from tabla;

   - ifnull():
	Es específica de mysql y funciona de manera similar a las funciones anteriores, sustituyendo un valor nulo por uno alternativo.
		Ejemplo: */
select ifnull(original_language_id, 'valor por defecto')
from film;
/* En este caso, se reemplazan los valores nulos en la columna original_language_id por 'valor por defecto'.

   - Coalesce():
	Es más versátil y compatible con una mayor cantidad de sistemas de bases de datos. Se usa para devolver el primer valor no nulo
	de una lista de expresiones. Ejemplo: */
select film_id, coalesce(original_language_id, 'sin datos') as original_language
from film;
/* En este ejemplo, la función coalesce evalúa la columna original_language_id y, si es nula, la reemplaza con 'sin datos'.
   Es importante destacar que el valor alternativo puede ser otra columna en lugar de un valor estático. */
