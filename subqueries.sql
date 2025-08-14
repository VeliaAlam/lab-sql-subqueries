-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
    f.title,
    COUNT(i.inventory_id) AS number_of_copies
FROM 
    sakila.film f
JOIN 
    sakila.inventory i ON f.film_id = i.film_id
WHERE 
    f.title = 'Hunchback Impossible'
GROUP BY 
    f.title;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
    title,
    length
FROM 
    sakila.film
WHERE 
    length > (SELECT AVG(length) FROM sakila.film)
ORDER BY 
    length DESC;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM 
    sakila.actor a
WHERE 
    a.actor_id IN (
        SELECT fa.actor_id
        FROM sakila.film_actor fa
        JOIN sakila.film f ON fa.film_id = f.film_id
        WHERE f.title = 'Alone Trip'
    )
ORDER BY 
    a.last_name, a.first_name;
    
-- 4. Sales have been lagging among young families, and you want to target family 
-- movies for a promotion. Identify all movies categorized as family films.
SELECT 
    f.title,
    c.name AS category
FROM 
    sakila.film f
JOIN 
    sakila.film_category fc ON f.film_id = fc.film_id
JOIN 
    sakila.category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family'
ORDER BY 
    f.title;
    
-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT 
    c.first_name,
    c.last_name,
    c.email
FROM 
    sakila.customer c
JOIN 
    sakila.address a ON c.address_id = a.address_id
JOIN 
    sakila.city ci ON a.city_id = ci.city_id
JOIN 
    sakila.country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada'
ORDER BY 
    c.last_name, c.first_name;

-- 6. Determine which films were starred by the most prolific actor in the Sakila database.
-- Paso 1 y 2 combinados
SELECT 
    f.title,
    a.first_name,
    a.last_name
FROM 
    sakila.film f
JOIN 
    sakila.film_actor fa ON f.film_id = fa.film_id
JOIN 
    sakila.actor a ON fa.actor_id = a.actor_id
WHERE 
    a.actor_id = (
        SELECT fa2.actor_id
        FROM sakila.film_actor fa2
        GROUP BY fa2.actor_id
        ORDER BY COUNT(fa2.film_id) DESC
        LIMIT 1
    )
ORDER BY 
    f.title;

-- 7. Find the films rented by the most profitable customer in the Sakila database.
SELECT 
    f.title,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_paid
FROM 
    sakila.customer c
JOIN 
    sakila.rental r ON c.customer_id = r.customer_id
JOIN 
    sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN 
    sakila.film f ON i.film_id = f.film_id
JOIN 
    sakila.payment p ON r.rental_id = p.rental_id
WHERE 
    c.customer_id = (
        SELECT customer_id
        FROM sakila.payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1
    )
GROUP BY 
    f.title, c.first_name, c.last_name
ORDER BY 
    f.title;
-- 8. Retrieve the client_id and the total_amount_spent of those clients 
-- who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.
SELECT 
    customer_id,
    total_amount_spent
FROM (
    SELECT 
        customer_id,
        SUM(amount) AS total_amount_spent
    FROM 
        sakila.payment
    GROUP BY 
        customer_id
) AS customer_totals
WHERE 
    total_amount_spent > (
        SELECT AVG(total_per_customer)
        FROM (
            SELECT SUM(amount) AS total_per_customer
            FROM sakila.payment
            GROUP BY customer_id
        ) AS averages
    )
ORDER BY 
    total_amount_spent DESC;


    
    
