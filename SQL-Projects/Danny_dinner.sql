create database Dannysdinner;
select * from sales;
#1. What is the total amount each customer spent at the restaurant?
select s.customer_id , sum(m.price) as total_amount 
from sales s
join menu m on s.product_id=m.product_id group by s.customer_id;
#2. How many days has each customer visited the restaurant?
select distinct order_date, customer_id, count(customer_id) from sales group by customer_id, order_date;
#3. What was the first item from the menu purchased by each customer?
select * from (select s.customer_id,s.order_date,m.product_name,row_number()over(partition by s.customer_id order by s.order_date asc) as dr from sales s join menu m using (product_id)) as t where dr=1;
#4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select * from (select product_name,count(product_name) as most_repeated,
 dense_rank() over(order by count(product_name) desc) as drnk from sales s
 inner join menu m using(product_id) group by product_name) as t where drnk=1;
 # 5. Which item was the most popular for each customer?
 select * from (select customer_id,product_name,count(*) as most_repeated,
 dense_rank() over(partition by customer_id order by count(product_name) desc) as drnk from sales s
 inner join menu m using(product_id) group by customer_id,product_name
 order by customer_id) as t where drnk=1;
# 6. Which item was purchased first by the customer after they became a member?
select * from (SELECT s.customer_id, m.product_name, s.order_date AS first_purchase_date, b.join_date, row_number() over (partition by customer_id order by order_date asc) as drnk
FROM sales s 
JOIN members b ON s.customer_id = b.customer_id AND order_date>join_date	
JOIN menu m ON s.product_id = m.product_id 
GROUP BY s.customer_id, m.product_name,s.order_date,b.join_date
ORDER BY s.customer_id)as t where drnk=1;
 
 # 7. Which item was purchased just before the customer became a member?
select * from (SELECT s.customer_id, m.product_name, s.order_date AS last_purchase_date, b.join_date, row_number() over (partition by customer_id order by order_date desc) as rn
FROM sales s 
JOIN members b ON s.customer_id = b.customer_id AND order_date<join_date
JOIN menu m ON s.product_id = m.product_id 
GROUP BY s.customer_id, m.product_name,s.order_date,b.join_date
ORDER BY s.customer_id) as t where rn=1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,  COUNT(*) AS total_items, SUM(m.price) AS total_amount
FROM sales s JOIN members b ON s.customer_id = b.customer_id AND s.order_date < b.join_date
JOIN menu m ON s.product_id = m.product_id GROUP BY s.customer_id;

#9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select s.customer_id, sum(case product_name when 'sushi' then m.price*20 else m.price*10 end) as points_table
from sales s join menu m using (product_id)
group by s.customer_id;

#10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?*/
select s.customer_id,count(m.product_name) as num_of_items, sum(case when order_date between join_date and date_add(join_date,interval 7 day) then m.price*20 when product_name='sushi' then m.price*20 else m.price*10 end) as total_points
from sales s 
join members mb on s.customer_id=mb.customer_id AND month(order_date) <=01
join menu m on s.product_id=m.product_id
group by s.customer_id;

#11. categories the data acc to the avg number of points
With CTE as (
select avg(points) as average_point 
from (
select *, case product_name when 'Sushi' then m.price*20 else m.price*10 end as points
from sales s join menu m using (product_id)) as t)
select *, case when points<=(select average_point from cte)then 'low' else 'high' end as 'status' from
(select s.customer_id, m.product_name,case product_name when 'Sushi' then m.price*20 else m.price*10 end as points
from sales s join menu m using (product_id)
order by customer_id) as t1;


with CTE1 as (select * from sales)
select * from CTE1;

