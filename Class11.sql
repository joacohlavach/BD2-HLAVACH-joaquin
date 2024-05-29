#Clase 11 - Hlavach
use sakila;

#1
select f.title
from film as f
where not exists(select i.film_id from inventory as i where i.film_id = f.film_id);

#2
select f.title, i2.inventory_id
from film as f
inner join inventory i2 on f.film_id = i2.film_id
where exists(select i.film_id
			from inventory as i
			where i.film_id = f.film_id
			and not exists(select r.inventory_id 
							from rental as r 
                            where r.inventory_id = i.inventory_id));
                            
#3
select c.first_name, c.last_name, s.store_id, f.title
from customer as c
inner join store s on c.store_id = s.store_id
inner join inventory i on s.store_id = i.store_id
inner join film f on i.film_id = f.film_id
where exists(select r.customer_id from rental as r 
			where c.customer_id = r.customer_id 
			and r.return_date is not null);

#4
select s.store_id as "ID", sum(p.amount) as "Ventas Totales:"
from store as s
	inner join inventory i on s.store_id = i.store_id
	inner join rental r on i.inventory_id = r.inventory_id
	inner join payment p on r.rental_id = p.rental_id
group by s.store_id;

#5
select fa.actor_id, a.first_name, a.last_name, count(*) as film
from film_actor as fa
inner join actor a on fa.actor_id = a.actor_id
group by fa.actor_id
order by 4 desc;