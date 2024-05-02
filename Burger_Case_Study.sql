-- 1. How many burgers were ordered?
Select count(*) as 'No of Orders'from runner_orders;

-- 2.How many unique customer orders were made?
Select count(distinct order_id)  as 'Unique_Order'
from customer_orders;

-- 3. How many successful orders were delivered by each runner?
Select runner_id,count(distinct order_id) as 'successful_order'
from runner_orders 
where cancellation is null
group by runner_id
order by successful_order desc;

-- 4.How many of each type of burger was delivered?
SELECT p.burger_name, COUNT(c.burger_id) AS delivered_burger_count
FROM customer_orders AS c
JOIN runner_orders AS r
 ON c.order_id = r.order_id
JOIN burger_names AS p
 ON c.burger_id = p.burger_id
WHERE r.distance != 0
GROUP BY p.burger_name;

-- 5.How many Vegetarian and Meatlovers were ordered by each customer?
Select c.customer_id,p.burger_name, count(p.burger_name)as order_count
from customer_orders as c 
JOIN burger_names as p
ON c.burger_id = p.burger_id
group by c.customer_id,p.burger_name
order by c.customer_id;

-- 6.What was the maximum number of burgers delivered in a single order?
with burger_count_cte as 
(Select c.order_id,count(c.burger_id) as buger_per_order
from customer_orders as c 
join runner_orders as r
ON c.order_id= r.order_id
where r.distance != 0
group by c.order_id)

select max(buger_per_order) as burger_count 
from burger_count_cte ;

-- 7.For each customer, how many delivered burgers had at least 1 change and how many had no changes?
SELECT c.customer_id,
 SUM(CASE 
  WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
  ELSE 0
  END) AS at_least_1_change,
 SUM(CASE 
  WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1 
  ELSE 0
  END) AS no_change
FROM customer_orders AS c
JOIN runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 8. What was the total volume of burgers ordered for each hour of the day?
SELECT EXTRACT(HOUR from order_time) AS hour_of_day, 
 COUNT(order_id) AS burger_count
FROM customer_orders
GROUP BY EXTRACT(HOUR from order_time);

-- 9.How many runners signed up for each 1 week period?
Select extract(week from registration_date) as reg_pweek,
count(runner_id) as runner_signup
from burger_runner
group by extract(week from registration_date);

-- 10.What was the average distance travelled for each customer?
Select c.customer_id,avg(r.distance) as avg_distance from
customer_orders as c join
runner_orders as r ON
c.order_id=r.order_id
where r.distance!=0
group by c.customer_id;


