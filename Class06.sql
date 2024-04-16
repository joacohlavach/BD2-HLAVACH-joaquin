# Class 06

#1
select a1.first_name, a1.last_name
from actor a1 where exists (select *
								from actor a2 
                                where a1.last_name = a2.last_name
                                and a1.actor_id <> a2.actor_id) order by a1.first_name;

#2
select ac1.first_name, ac1.last_name from film_actor fi
inner join actor ac1 on ac1.actor_id = fi.actor_id
where not exists(select * from actor ac2 where ac1.actor_id = ac2.actor_id);

#3
select c.customer_id, c.first_name, c.last_name from customer c 
inner join rental r on r.customer_id = c.customer_id
group by c.customer_id having count(r.rental_id) = 1;


#4 
select c.customer_id, c.first_name, c.last_name from customer c 
inner join rental r on r.customer_id = c.customer_id
group by c.customer_id having count(r.rental_id) > 1;

#5
select a.first_name, a.last_name, group_concat(f.title) from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where f.title in ('BETRAYED REAR','CATCH AMISTAD') group by a.actor_id;

#6 
select a.first_name, a.last_name, f.title from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where f.title = 'BETRAYED REAR' and a.actor_id not in (
	select actor_id from film_actor fa
    inner join film f on f.film_id = fa.film_id
    where f.title = 'CATCH AMISTAD'
);

#7
select a.first_name, a.last_name, group_concat(f.title) from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where f.title = 'BETRAYED REAR' and a.actor_id in (
	select actor_id from film_actor fa
    inner join film f on f.film_id = fa.film_id
    where f.title = 'CATCH AMISTAD') group by a.actor_id;

#8
select a.first_name, a.last_name from actor a
where a.actor_id not in (
	select actor_id from film_actor fa
    inner join film f on fa.film_id = f.film_id
    where f.title = 'BETRAYED REAR'
) and actor_id not in (
	select actor_id from film_actor fa
    inner join film f on fa.film_id = f.film_id
	where f.title = 'CATCH AMISTAD'
);