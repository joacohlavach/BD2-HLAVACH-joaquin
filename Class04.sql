#1
select f.title, f.special_features, f.rating from film f
	where f.rating = "PG-13";
    
#2
select distinct `length` from film;

#3
select f.title, f.rental_rate, f.replacement_cost
from film f 
where f.replacement_cost between 20.00 and 24.00;

#4
select f.title, f.description, f.rating from film f
where f.special_features like "%Behind the Scenes%";

#5
select a.first_name, a.last_name from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where f.title = 'ZOOLANDER FICTION';

#6
select ad.address, c.city, co.country from store s
inner join address ad on s.address_id = ad.address_id
inner join city c on ad.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where s.store_id = 1;

#7
select f1.title as film1_title, f1.rating, f2.title as film2_title, f2.rating from film f1
inner join film f2 on f1.rating = f2.rating
where f1.film_id <> f2.film_id;

#8
select distinct f.title, f.release_year, st.first_name as manager_of_store2 from film f
inner join inventory inv on f.film_id = inv.film_id
inner join store s on s.store_id = inv.store_id
inner join staff st on s.manager_staff_id = st.staff_id
where s.store_id = 2;