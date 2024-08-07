#Add a new customer
#To store 1
#For address use an existing address. The one that has the biggest address_id in 'United States'
use sakila;

insert into customer (store_id, address_id, first_name, last_name, email)
values (
    1,
    (select max(address.address_id)
     from address
     inner join city c using(city_id)
     inner join country co using(country_id)
     where co.country = 'United States'),
    'joaquin',
    'hlavach',
    'joaquin.hlavach@gmail.com'
);

#Add a rental
#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
#Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
#Select any staff_id from Store 2.

insert into rental (rental_date, inventory_id, staff_id, customer_id)
values (current_date(),
    (select inventory_id from inventory
     inner join film using(film_id)
     where film.title = 'AFRICAN EGG'
     order by inventory_id desc 
     limit 1),
    (select max(staff_id) from staff where store_id = 2),
    (select customer_id from customer order by customer_id desc limit 1)
);

#Update film year based on the rating
#For example if rating is 'G' release date will be '2001'
#You can choose the mapping between rating and year.
#Write as many statements are needed.

set sql_safe_updates = 0;
update film
set release_year = case
	when rating = 'G' then '2008'
	when rating = 'PG' then '2009'
	when rating = 'NC_17' then '2010'
	when rating = 'PG-13' then '2011'
	when rating = 'R' then '2012'
	else release_year end;

#Return a film
#Write the necessary statements and queries for the following steps.
#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#Use the id to return the film.



select f.film_id from film as f
inner join inventory as i using(film_id)
inner join rental as r using(inventory_id)
where r.return_date is null
order by rental_date desc
limit 1;


#Try to delete a film
#Check what happens, describe what to do.
#Write all the necessary delete statements to entirely remove the film from the DB.
delete from film where film_id = 1;
#Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE)
delete from film_actor where film_id = 1;
delete from film_category where film_id = 1;
delete from rental where inventory_id in (select inventory_id from inventory where film_id = 1);
delete from inventory where film_id = 1;
delete from film where film_id = 1;


#Rent a film
#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
#Add a rental entry
#Add a payment entry
#Use sub-queries for everything, except for the inventory id that can be used directly in the queries.


#Hago un insert
insert into inventory (film_id, store_id, last_update)
values (2, 2, now());

insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
values (current_date(), 
	(select I.inventory_id from inventory as I
	where not exists(select * from rental as r
		where r.inventory_id = I.inventory_id
		and r.return_date < current_date())
		limit 1), 1, current_date(), 1);
insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
values (1, 1, (select LAST_INSERT_ID()), 13.5, current_date)
