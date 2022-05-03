use sakila;
#1) Select the first name, last name, and email address of all the customers who have rented a movie.

select c.first_name, c.last_name, c.email, count(customer_id)
from customer c
join rental r 
using (customer_id)
group by first_name, last_name, email
having count(r.rental_id) >0;



#2) What is the average payment made by each customer (display the customer id, customer name (concatenated), 
#and the average payment made).

select avg(p.amount), p.customer_id;

SELECT c.customer_id, CONCAT(first_name, ' ', last_name) AS name, avg(amount)
	FROM customer c
	JOIN payment p
		using (customer_id)
        group by c.customer_id,name;


#3) Select the name and email address of all the customers who have rented the "Action" movies.
#Write the query using multiple join statements

SELECT
	CONCAT(c.first_name, " ",  c.last_name) AS name, c.email
FROM
	rental r
LEFT JOIN
	customer c 
    using (customer_id)
LEFT JOIN
	inventory i 
    using (inventory_id)
LEFT JOIN
	film_category fc 
    using (film_id)
LEFT JOIN
	category cat 
    using (category_id)
WHERE
	cat.name = "Action"
GROUP BY
	r.customer_id
ORDER BY
	name ASC;

#Write the query using sub queries with multiple WHERE clause and IN condition

SELECT
	CONCAT(first_name, " ",  last_name) AS name, email
FROM
	(SELECT
		first_name, last_name, email
	FROM
		customer
	WHERE
		customer_id IN 
        (SELECT customer_id
		FROM rental
	WHERE inventory_id IN 
		(SELECT inventory_id
		FROM inventory
	WHERE film_id IN 
		(SELECT film_id
		FROM film_category
	WHERE category_id IN 
		(SELECT category_id
		FROM category
	WHERE name = "Action"))))) AS subs
ORDER BY
	name ASC;

#Verify if the above two queries produce the same results or not
	#yes, they do

#4) Use the case statement to create a new column classifying existing columns as either or high value transactions 
#based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
#the label should be medium, and if it is more than 4, then it should be high.

SELECT 	customer_id, 
		CONCAT(first_name, ' ', last_name) AS cust_name, 
		ROUND(AVG(amount), 2) AS average,
        CASE WHEN amount < 2 THEN 'low'
			WHEN amount BETWEEN 2 AND 4 THEN 'medium'
            WHEN amount > 4 THEN 'high' END AS classification
FROM customer c
JOIN payment p
	USING (customer_id)
GROUP BY customer_id, cust_name,classification;