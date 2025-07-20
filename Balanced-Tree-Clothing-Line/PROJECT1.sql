create database balanced_tree_clothing;
#HIGH LEVEL SALES ANALYSIS
#1.What was the total quantity sold for all products?
select * from product_details;
select * from product_sales;
select pd.product_name,sum(ps.qty) from product_details pd
join product_sales ps on (pd.product_id=ps.prod_id)  group by product_name;
#2. What is the total generated revenue for all products before discounts?
select * from product_prices;
select pd.product_name,sum(ps.price) from product_details pd
join product_sales ps on (pd.product_id=ps.prod_id)  group by product_name;
#3 What was the total discount amount for all products?
select pd.product_name,sum(ps.discount) from product_details pd
join product_sales ps on (pd.product_id=ps.prod_id)  group by product_name;
#TRANSACTIONAL ANALYSIS
#1. How many unique transactions were there?
select count(distinct(txn_id)) from product_sales;
#2. What is the average unique products purchased in each transaction?
select distinct(prod_id)from product_sales;
#3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
select * from product_hierarchy;
WITH ranked_data AS (
    SELECT 
        price,
        PERCENT_RANK() OVER (ORDER BY price) AS percentile_rank
    FROM product_sales
)
SELECT 
    MAX(CASE WHEN percentile_rank <= 0.25 THEN price END) AS "25th Percentile",
    MAX(CASE WHEN percentile_rank <= 0.50 THEN price END) AS "50th Percentile",
    MAX(CASE WHEN percentile_rank <= 0.75 THEN price END) AS "75th Percentile"
FROM ranked_data;
#4. What is the average discount value per transaction?
select avg(discount), txn_id from product_sales group by txn_id;
#5. What is the percentage split of all transactions for members vs non-members?
SELECT 
    CASE 
        WHEN member= 't' THEN 'Member'
        ELSE 'Non-Member'
    END AS category,
    COUNT(*) AS txn_id,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM product_sales)), 2) AS percentage_split
FROM product_sales
GROUP BY category;
#6. What is the average revenue for member transactions and non-member transactions?
SELECT 
    CASE
        WHEN member = 't' THEN 'Member'
        ELSE 'Non- member'
    END AS category,
    AVG(price)
FROM
    product_sales
GROUP BY category;
#PRODUCT ANALYSIS
#1. What are the top 3 products by total revenue before discount?
SELECT 
    SUM(price), prod_id
FROM
    product_sales
GROUP BY prod_id
ORDER BY SUM(price) DESC
LIMIT 3;
#2.What is the total quantity, revenue and discount for each segment?
select sum(ps.qty), sum(ps.price), sum(ps.discount),pd.segment_name from 
product_sales ps join product_details pd on (ps.prod_id=pd.product_id) 
group by segment_name;
#What is the top selling product for each segment?
select * from product_sales;
select * from product_hierarchy;
select * from product_details;
select max(ps.price),pd.segment_id,pd.segment_name from product_sales ps 
join product_details pd on (ps.prod_id=pd.product_id)
group by segment_id,segment_name;
#4.What is the total quantity, revenue and discount for each category?
select sum(ps.qty), sum(ps.price), sum(ps.discount),pd.category_name from 
product_sales ps join product_details pd on (ps.prod_id=pd.product_id) 
group by category_name;
#5.What is the top selling product for each category?
select max(ps.price),pd.category_id,pd.category_name from product_sales ps 
join product_details pd on (ps.prod_id=pd.product_id)
group by category_id,category_name;
#6.What is the percentage split of revenue by product for each segment?
select * from product_hierarchy;
select pd.segment_id, sum(ps.price), sum(ps.price)*100/(select sum(price) from product_sales) from product_sales ps 
join product_details pd on (ps.prod_id=pd.product_id)
group by segment_id;
#7.What is the percentage split of revenue by segment for each category?
select pd.segment_id,pd.category_id, sum(ps.price), sum(ps.price)*100/(select sum(price) from product_sales) from product_sales ps 
join product_details pd on (ps.prod_id=pd.product_id)
group by category_id,segment_id;
#8.What is the percentage split of total revenue by category?
select pd.category_id, sum(ps.price), sum(ps.price)*100/(select sum(price) from product_sales) from product_sales ps 
join product_details pd on (ps.prod_id=pd.product_id)
group by category_id;
#9.What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
SELECT 
    prod_id,
    COUNT(DISTINCT txn_id) AS transactions_with_product,
    COUNT(DISTINCT txn_id) * 1.0 / (SELECT COUNT(DISTINCT txn_id) FROM product_sales) AS penetration
FROM 
    product_sales
GROUP BY 
    prod_id;
#10.What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
SELECT 
    p1.prod_id AS product_1,
    p2.prod_id AS product_2,
    p3.prod_id AS product_3,
    COUNT(*) AS frequency
FROM 
    product_sales p1
JOIN 
   product_sales p2 ON p1.prod_id = p2.prod_id AND p1.prod_id < p2.prod_id
JOIN 
    product_sales p3 ON p3.prod_id = p2.prod_id AND p2.prod_id < p3.prod_id
WHERE 
    p1.qty > 0 AND p2.qty > 0 AND p3.qty > 0
GROUP BY 
    p1.prod_id, p2.prod_id, p3.prod_id
ORDER BY 
    frequency DESC
LIMIT 1;

SELECT 
    txn_id,
    COUNT(DISTINCT prod_id) AS unique_products
FROM 
    product_sales
GROUP BY 
    txn_id
HAVING 
    unique_products >= 3;
