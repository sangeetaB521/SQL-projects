# 🍕 Pizza Runner Analytics

A comprehensive SQL analytics project for a pizza delivery service, demonstrating advanced data analysis techniques including customer order patterns, delivery optimization, and ingredient management. This project showcases enterprise-level food delivery analytics with complex business intelligence queries for the pizza industry.

## 📊 Project Overview

This project implements a complete delivery analytics system for Pizza Runner, featuring multi-dimensional analysis across customer ordering behavior, runner performance optimization, and ingredient usage patterns. The system provides actionable insights for delivery efficiency, customer satisfaction, and operational excellence.

## 🎯 Business Analysis Categories

### 📈 Pizza Metrics
- **Order Volume Analysis**: Total pizza orders and unique customer tracking
- **Delivery Success Rates**: Runner performance and successful delivery metrics
- **Pizza Type Distribution**: Popular pizza varieties and customer preferences
- **Order Modification Patterns**: Customer customization behavior analysis

### 🚚 Runner and Customer Experience
- **Delivery Performance**: Runner efficiency and arrival time optimization
- **Customer Satisfaction**: Delivery speed and service quality metrics
- **Operational Insights**: Distance, duration, and delivery success patterns
- **Resource Allocation**: Runner workload distribution and optimization

### 🧄 Ingredient Optimization
- **Topping Popularity**: Most requested extras and exclusions
- **Inventory Management**: Ingredient usage patterns and demand forecasting
- **Customization Trends**: Customer preference analysis for menu optimization
- **Cost Optimization**: Ingredient efficiency and waste reduction insights

## 🗄️ Database Schema

### Core Tables
- **customer_orders**: Order details with customizations (order_id, customer_id, pizza_id, exclusions, extras, order_time)
- **runner_orders**: Delivery information (order_id, runner_id, pickup_time, distance, duration, cancellation)
- **pizza_names**: Pizza type reference (pizza_id, pizza_name)
- **pizza_recipes**: Standard pizza ingredients (pizza_id, toppings)
- **pizza_toppings**: Available toppings (topping_id, topping_name)

### Key Relationships
- **Orders ↔ Runners**: order_id connects customer orders to delivery assignments
- **Pizza Customization**: exclusions and extras track customer modifications
- **Ingredient Mapping**: topping_id links recipes to available ingredients

## 🚀 Advanced SQL Techniques Demonstrated

### Pizza Metrics Analysis

**Total Order Volume**
```sql
-- Complete order count across all customers
SELECT COUNT(order_id) AS orders_count 
FROM customer_orders;
```

**Unique Customer Analysis**
```sql
-- Distinct customer base measurement
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
FROM customer_orders;
```

**Pizza Type Performance**
```sql
-- Pizza popularity with successful deliveries only
SELECT pizza_name, COUNT(c.pizza_id) AS pizza_count 
FROM customer_orders c 
JOIN runner_orders r USING(order_id)
JOIN pizza_names p ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL
GROUP BY pizza_name;
```

### Advanced Delivery Analytics

**Runner Performance Metrics**
```sql
-- Successful delivery count per runner
SELECT runner_id, COUNT(order_id) AS successful_deliveries 
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
```

**Maximum Order Capacity**
```sql
-- Largest single order delivery
SELECT MAX(pizza_count) AS max_pizzas_per_order
FROM (
    SELECT COUNT(pizza_id) AS pizza_count 
    FROM customer_orders c 
    JOIN runner_orders r USING(order_id)
    WHERE cancellation IS NULL
    GROUP BY order_id
) subquery;
```

### Customer Behavior Analysis

**Order Customization Patterns**
```sql
-- Changed vs unchanged pizza orders
SELECT customer_id, 
    SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END) AS changed_pizzas,
    SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) AS unchanged_pizzas
FROM customer_orders c 
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY customer_id;
```

**Premium Customization Analysis**
```sql
-- Orders with both exclusions and extras
SELECT COUNT(*) AS premium_customized_pizzas
FROM customer_orders c 
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL
  AND exclusions IS NOT NULL 
  AND extras IS NOT NULL;
```

### Temporal Order Analysis

**Hourly Order Distribution**
```sql
-- Pizza ordering patterns by hour
SELECT HOUR(order_time) AS order_hour, 
       COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;
```

### Runner Performance Intelligence

**Runner Registration Tracking**
```sql
-- Weekly runner onboarding patterns
SELECT YEARWEEK(registration_date) AS registration_week,
       COUNT(runner_id) AS new_runners
FROM runners
GROUP BY registration_week
ORDER BY registration_week;
```

**Delivery Time Optimization**
```sql
-- Pizza quantity vs preparation time correlation
SELECT pizza_count, 
       AVG(prep_time) AS avg_preparation_time
FROM (
    SELECT c.order_id, 
           COUNT(c.pizza_id) AS pizza_count, 
           CAST(duration AS UNSIGNED) AS prep_time
    FROM customer_orders c
    JOIN runner_orders r USING(order_id)
    WHERE r.cancellation IS NULL
    GROUP BY c.order_id, r.duration
) subquery
GROUP BY pizza_count
ORDER BY pizza_count;
```

**Customer Distance Analysis**
```sql
-- Average delivery distance per customer
SELECT customer_id, 
       ROUND(AVG(distance), 2) AS avg_delivery_distance 
FROM customer_orders c 
JOIN runner_orders r USING(order_id)
GROUP BY customer_id;
```

### Delivery Efficiency Metrics

**Speed Performance Analysis**
```sql
-- Runner speed calculation for trend analysis
SELECT order_id, runner_id, 
       ROUND((distance/duration), 2) AS avg_speed_km_per_min
FROM runner_orders
WHERE cancellation IS NULL;
```

**Delivery Success Rates**
```sql
-- Runner reliability percentage
SELECT runner_id, 
       ROUND(100 * SUM(CASE WHEN cancellation IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_percentage
FROM runner_orders
GROUP BY runner_id;
```

### Ingredient Intelligence

**Popular Extras Analysis**
```sql
-- Most requested additional toppings
SELECT pt.topping_name, COUNT(*) AS extra_requests  
FROM customer_orders c  
JOIN pizza_toppings pt  
ON FIND_IN_SET(pt.topping_id, c.extras)  
GROUP BY pt.topping_name  
ORDER BY extra_requests DESC  
LIMIT 1;
```

**Exclusion Pattern Analysis**
```sql
-- Most commonly removed ingredients
SELECT pt.topping_name, COUNT(*) AS exclusion_count  
FROM customer_orders co  
JOIN pizza_toppings pt  
ON FIND_IN_SET(pt.topping_id, co.exclusions) > 0  
WHERE co.exclusions IS NOT NULL AND co.exclusions <> ''  
GROUP BY pt.topping_name  
ORDER BY exclusion_count DESC  
LIMIT 1;
```

## 📊 Key Business Metrics

### Operational Performance Indicators
- **Order Volume**: Total pizza orders and customer reach
- **Delivery Success Rate**: Runner efficiency and reliability metrics
- **Customer Satisfaction**: Order accuracy and delivery speed
- **Pizza Popularity**: Menu item performance and preferences

### Customer Behavior Analytics
- **Customization Patterns**: Ingredient modification preferences
- **Ordering Frequency**: Customer loyalty and repeat business
- **Peak Hour Analysis**: Demand forecasting and staffing optimization
- **Customer Distance**: Delivery zone analysis and expansion planning

### Delivery Intelligence
- **Runner Performance**: Speed, reliability, and capacity metrics
- **Route Optimization**: Distance and duration efficiency
- **Cancellation Analysis**: Service failure patterns and prevention
- **Resource Allocation**: Runner workload distribution

## 🔧 Advanced Analytics Features

### Data Cleaning and Standardization
- **NULL Value Handling**: Consistent empty value treatment across tables
- **Data Type Conversion**: Distance and duration standardization
- **Text Normalization**: Consistent duration format processing
- **Quality Assurance**: Data integrity validation and correction

### Performance Optimization
- **JOIN Operations**: Efficient table relationship management
- **Aggregation Functions**: Complex metric calculations
- **Conditional Logic**: Business rule implementation
- **Subquery Optimization**: Nested analysis for complex insights

### Business Intelligence Calculations
- **Success Rates**: Delivery performance percentages
- **Average Metrics**: Speed, distance, and time calculations
- **Trend Analysis**: Temporal pattern recognition
- **Correlation Analysis**: Relationship identification between variables

## 📈 Business Intelligence Applications

### Operational Strategy Optimization
- **Menu Engineering**: Popular pizza promotion and unpopular item optimization
- **Delivery Zone Planning**: Distance-based service area expansion
- **Runner Scheduling**: Peak hour resource allocation
- **Inventory Management**: Ingredient demand forecasting

### Customer Experience Analytics
- **Personalization**: Individual customer preference tracking
- **Service Quality**: Delivery time and accuracy optimization
- **Customization Options**: Menu flexibility based on usage patterns
- **Satisfaction Metrics**: Order modification success rates

### Revenue Management
- **Demand Forecasting**: Hourly and daily order prediction
- **Capacity Planning**: Runner and kitchen resource optimization
- **Cost Analysis**: Delivery efficiency and profitability metrics
- **Growth Opportunities**: Market expansion and service enhancement

## 🎯 Learning Outcomes

### Food Delivery Analytics Mastery
- **Order pattern** analysis and demand forecasting
- **Delivery optimization** through performance metrics
- **Customer behavior** analysis and personalization strategies
- **Operational efficiency** measurement and improvement
- **Ingredient management** and cost optimization

### Advanced SQL for Restaurant Operations
- **Data cleaning** and standardization techniques
- **Complex JOINs** across multiple related tables
- **Aggregate functions** for business metric calculations
- **Conditional analysis** for performance evaluation
- **Temporal queries** for trend analysis and forecasting

### Data-Driven Restaurant Management
- **KPI development** for delivery service optimization
- **Performance tracking** for operational excellence
- **Customer analytics** for service personalization
- **Resource planning** for capacity and efficiency
- **Quality control** through data monitoring

## 🏆 Real-World Applications

This project demonstrates expertise essential for:
- **Food Delivery Services** - Order fulfillment and delivery optimization
- **Restaurant Analytics** - Menu performance and customer preference analysis
- **Operations Management** - Resource allocation and efficiency metrics
- **Customer Experience** - Service quality and satisfaction measurement
- **Supply Chain** - Ingredient demand forecasting and inventory management
- **Business Intelligence** - Performance dashboards and strategic insights

## 💡 Advanced Features

### Peak Hour Analysis
```sql
-- Busiest delivery periods identification
SELECT 
    HOUR(order_time) AS peak_hour,
    COUNT(*) AS order_volume,
    AVG(CAST(duration AS UNSIGNED)) AS avg_delivery_time
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY peak_hour
ORDER BY order_volume DESC;
```

### Customer Loyalty Metrics
```sql
-- Repeat customer analysis
SELECT 
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(pizza_id) AS total_pizzas,
    ROUND(COUNT(pizza_id) / COUNT(DISTINCT order_id), 2) AS avg_pizzas_per_order
FROM customer_orders
GROUP BY customer_id
ORDER BY total_orders DESC;
```

### Delivery Zone Performance
```sql
-- Distance-based delivery analysis
SELECT 
    CASE 
        WHEN distance <= 5 THEN 'Short Range (≤5km)'
        WHEN distance <= 10 THEN 'Medium Range (6-10km)'
        ELSE 'Long Range (>10km)'
    END AS delivery_zone,
    COUNT(*) AS delivery_count,
    AVG(CAST(duration AS UNSIGNED)) AS avg_delivery_time,
    ROUND(AVG(distance/CAST(duration AS UNSIGNED)), 2) AS avg_speed
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY delivery_zone;
```

## 🤝 Contributing

This project welcomes enhancements in:
- Advanced delivery route optimization algorithms
- Customer preference prediction models
- Real-time order tracking analytics
- A/B testing framework for menu optimization
- Predictive demand forecasting models

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Demonstrates real-world food delivery analytics applications
- Built using comprehensive pizza delivery service data model
- Showcases advanced SQL techniques for restaurant businesses
- Serves as a reference for food service industry analytics

---

**⭐ Star this repository if it helped you master food delivery analytics with SQL!**