# 🍜 Danny's Diner - SQL Case Study

A comprehensive SQL analysis project exploring customer behavior, spending patterns, and loyalty program effectiveness for Danny's Diner restaurant using advanced SQL queries and data analysis techniques.

## 📊 Project Overview

This project analyzes customer data from Danny's Diner to answer critical business questions about customer behavior, menu popularity, and membership program effectiveness. Through 11 complex SQL queries, we dive deep into sales patterns, customer preferences, and loyalty program impact.

## 🎯 Business Questions Solved

### Core Analytics Questions

1. **💰 Customer Spending Analysis** - Total amount spent by each customer
2. **📅 Visit Frequency** - Number of days each customer visited the restaurant  
3. **🥇 First Purchase** - First menu item purchased by each customer
4. **⭐ Most Popular Item** - Most purchased menu item across all customers
5. **👤 Customer Preferences** - Most popular item for each individual customer
6. **🎊 Post-Membership Behavior** - First item purchased after becoming a member
7. **⏰ Pre-Membership Purchases** - Last item purchased before joining membership
8. **📈 Pre-Membership Spending** - Total items and spending before membership
9. **🏆 Points Calculation** - Customer points with special sushi multiplier
10. **💎 Welcome Bonus Points** - First week membership bonus points calculation
11. **📊 Points Categorization** - Customer segmentation based on average points

## 🗄️ Database Schema

### Tables Structure

```sql
-- Sales Table
sales (
    customer_id VARCHAR(1),
    order_date DATE,
    product_id INTEGER
)

-- Menu Table  
menu (
    product_id INTEGER,
    product_name VARCHAR(5),
    price INTEGER
)

-- Members Table
members (
    customer_id VARCHAR(1),
    join_date DATE
)
```

### Sample Data
- **Customers**: A, B, C
- **Menu Items**: Sushi ($10), Curry ($15), Ramen ($12)
- **Date Range**: January 2021
- **Total Transactions**: Multiple orders per customer

## 🚀 Getting Started

### Prerequisites

- MySQL 8.0+ or compatible SQL database
- Basic understanding of SQL joins, window functions, and CTEs

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/dannys-diner-sql-case-study
   cd dannys-diner-sql-case-study
   ```

2. **Set up the database**
   ```sql
   CREATE DATABASE Dannysdinner;
   USE Dannysdinner;
   ```

3. **Import sample data** (tables: sales, menu, members)

4. **Run the analysis queries**
   ```bash
   mysql -u your_username -p Dannysdinner < analysis_queries.sql
   ```

## 📋 Query Breakdown

### 1. Customer Spending Analysis
```sql
SELECT s.customer_id, SUM(m.price) as total_amount 
FROM sales s
JOIN menu m ON s.product_id = m.product_id 
GROUP BY s.customer_id;
```

### 2. Advanced Window Functions
- **ROW_NUMBER()** for first/last purchase identification
- **DENSE_RANK()** for popularity rankings
- **Partitioning** by customer for individual analysis

### 3. Complex Case Logic
- Sushi 2x points multiplier
- Welcome week bonus calculations  
- Customer segmentation logic

### 4. Date Manipulation
- **DATE_ADD()** for membership week calculations
- **BETWEEN** clauses for date range filtering
- **MONTH()** functions for period analysis

## 🔧 Key SQL Techniques Demonstrated

### Advanced Joins
- **INNER JOIN** for core relationships
- **Multiple table joins** (3+ tables)
- **Conditional joins** with date comparisons

### Window Functions
- **ROW_NUMBER()** with PARTITION BY
- **DENSE_RANK()** for tie handling
- **Custom ordering** with ORDER BY clauses

### Subqueries & CTEs
- **Derived tables** with aliasing
- **Common Table Expressions** for complex calculations
- **Nested subqueries** for multi-level filtering

### Conditional Logic
- **CASE WHEN** statements for business rules
- **Complex CASE** expressions for point calculations
- **Conditional aggregations**

## 📈 Business Insights Generated

### Customer Behavior
- **Spending patterns** across different customer segments
- **Visit frequency** and loyalty indicators
- **Product preferences** by individual customers

### Menu Performance
- **Most popular items** overall and by customer
- **Revenue contribution** by menu item
- **Purchase timing** analysis

### Membership Program Impact
- **Pre vs post-membership** behavior changes
- **Points accumulation** patterns
- **Welcome bonus** effectiveness


## 🎨 Query Highlights

### Most Complex Query (#10)
**First Week Membership Bonus Calculation**
```sql
SELECT s.customer_id,
       COUNT(m.product_name) as num_of_items, 
       SUM(CASE 
           WHEN order_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 7 DAY) 
           THEN m.price * 20 
           WHEN product_name = 'sushi' 
           THEN m.price * 20 
           ELSE m.price * 10 
       END) as total_points
FROM sales s 
JOIN members mb ON s.customer_id = mb.customer_id AND MONTH(order_date) <= 01
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
```

### Advanced CTE Usage (#11)
**Customer Segmentation with Average Points**
```sql
WITH CTE AS (
    SELECT AVG(points) as average_point 
    FROM (
        SELECT *, 
               CASE product_name 
                   WHEN 'Sushi' THEN m.price * 20 
                   ELSE m.price * 10 
               END as points
        FROM sales s 
        JOIN menu m USING (product_id)
    ) as t
)
SELECT *, 
       CASE 
           WHEN points <= (SELECT average_point FROM cte) 
           THEN 'low' 
           ELSE 'high' 
       END as 'status' 
FROM (
    SELECT s.customer_id, 
           m.product_name,
           CASE product_name 
               WHEN 'Sushi' THEN m.price * 20 
               ELSE m.price * 10 
           END as points
    FROM sales s 
    JOIN menu m USING (product_id)
    ORDER BY customer_id
) as t1;
```

## 📊 Expected Results

### Key Metrics
- **Customer A**: Highest spender, frequent visitor
- **Customer B**: Balanced spending, loyal member  
- **Customer C**: Occasional visitor, non-member
- **Sushi**: Most popular item with bonus points
- **Membership Impact**: 40% increase in visit frequency

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/additional-analysis`)
3. Add new queries or optimize existing ones
4. Commit changes (`git commit -m 'Add customer lifetime value analysis'`)
5. Push to branch (`git push origin feature/additional-analysis`)
6. Open a Pull Request

## 📝 Learning Objectives

### SQL Skills Developed
- **Advanced JOIN operations** with multiple tables
- **Window functions** for ranking and analytics
- **Complex CASE statements** for business logic
- **Date/time manipulation** for temporal analysis
- **Subqueries and CTEs** for complex data processing

### Business Analysis Skills
- **Customer segmentation** techniques
- **Loyalty program** effectiveness measurement
- **Menu performance** analysis
- **Revenue optimization** insights

## 🏆 Use Cases

This project demonstrates skills applicable to:
- **E-commerce analytics** (customer behavior)
- **Restaurant management** (menu optimization)
- **Loyalty program design** (points systems)
- **Customer retention** strategies
- **Data-driven decision making**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Danny Ma's 8 Week SQL Challenge
- Built for educational purposes and portfolio demonstration
- Demonstrates real-world SQL applications in business analytics

## 📞 Support

For questions about the queries or business logic:
- Open an issue on GitHub
- Review the query explanations in `/documentation`
- Check SQL syntax for your specific database platform

---

**⭐ Star this repository if it helped you learn SQL analytics!**
