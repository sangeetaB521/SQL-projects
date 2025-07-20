# 👗 Balanced Tree Clothing - SQL Analytics Dashboard

A comprehensive SQL analytics project for a fashion retail company, demonstrating advanced data analysis techniques including sales performance tracking, customer behavior analysis, and product penetration metrics. This project showcases enterprise-level retail analytics with complex business intelligence queries.

## 📊 Project Overview

This project implements a complete retail analytics system for Balanced Tree Clothing, featuring multi-dimensional analysis across high-level sales metrics, transactional patterns, and detailed product performance. The system provides actionable insights for inventory management, pricing strategies, and customer segmentation.

## 🎯 Business Analysis Categories

### 📈 High-Level Sales Analysis
- **Total Quantity Tracking**: Product-wise sales volume analysis
- **Revenue Generation**: Pre-discount revenue calculations across all products
- **Discount Impact**: Total discount distribution analysis by product

### 💳 Transactional Analysis  
- **Transaction Uniqueness**: Distinct transaction counting and validation
- **Purchase Behavior**: Average products per transaction analysis
- **Revenue Distribution**: Percentile analysis (25th, 50th, 75th) for transaction values
- **Discount Patterns**: Average discount value per transaction
- **Membership Impact**: Member vs non-member transaction analysis
- **Revenue Segmentation**: Member vs non-member average revenue comparison

### 🛍️ Product Analysis
- **Top Performers**: Revenue-based product ranking (Top 3)
- **Segment Performance**: Quantity, revenue, and discount analysis by segment
- **Category Analytics**: Comprehensive category-wise performance metrics
- **Revenue Distribution**: Percentage split analysis across segments and categories
- **Market Penetration**: Product penetration rate calculations
- **Basket Analysis**: Common product combination identification

## 🗄️ Database Schema

### Core Tables
- **product_sales**: Transaction-level sales data (txn_id, prod_id, qty, price, discount, member)
- **product_details**: Product information (product_id, product_name, category_id, segment_id, category_name, segment_name)
- **product_hierarchy**: Product categorization structure
- **product_prices**: Pricing information and history

### Key Relationships
- **Sales ↔ Details**: prod_id connects transactions to product information
- **Hierarchical Structure**: Categories → Segments → Products
- **Member Classification**: Boolean member flag for customer segmentation

## 🚀 Advanced SQL Techniques Demonstrated

### Complex Aggregation Queries

**Product-wise Sales Volume Analysis**
```sql
SELECT pd.product_name, SUM(ps.qty) 
FROM product_details pd
JOIN product_sales ps ON (pd.product_id = ps.prod_id)  
GROUP BY product_name;
```

**Revenue Before Discounts**
```sql
SELECT pd.product_name, SUM(ps.price) 
FROM product_details pd
JOIN product_sales ps ON (pd.product_id = ps.prod_id)  
GROUP BY product_name;
```

### Statistical Analysis with Percentiles

**Revenue Percentile Calculation**
```sql
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
```

### Customer Segmentation Analysis

**Member vs Non-Member Transaction Split**
```sql
SELECT 
    CASE 
        WHEN member = 't' THEN 'Member'
        ELSE 'Non-Member'
    END AS category,
    COUNT(*) AS txn_id,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM product_sales)), 2) AS percentage_split
FROM product_sales
GROUP BY category;
```

**Average Revenue by Membership Status**
```sql
SELECT 
    CASE
        WHEN member = 't' THEN 'Member'
        ELSE 'Non-Member'
    END AS category,
    AVG(price)
FROM product_sales
GROUP BY category;
```

### Advanced Product Analytics

**Top 3 Products by Revenue**
```sql
SELECT SUM(price), prod_id
FROM product_sales
GROUP BY prod_id
ORDER BY SUM(price) DESC
LIMIT 3;
```

**Segment Performance Analysis**
```sql
SELECT SUM(ps.qty), SUM(ps.price), SUM(ps.discount), pd.segment_name 
FROM product_sales ps 
JOIN product_details pd ON (ps.prod_id = pd.product_id) 
GROUP BY segment_name;
```

### Market Penetration Calculations

**Product Penetration Rate**
```sql
SELECT 
    prod_id,
    COUNT(DISTINCT txn_id) AS transactions_with_product,
    COUNT(DISTINCT txn_id) * 1.0 / (SELECT COUNT(DISTINCT txn_id) FROM product_sales) AS penetration
FROM product_sales
GROUP BY prod_id;
```

### Complex Basket Analysis

**Most Common 3-Product Combinations**
```sql
SELECT 
    p1.prod_id AS product_1,
    p2.prod_id AS product_2,
    p3.prod_id AS product_3,
    COUNT(*) AS frequency
FROM product_sales p1
JOIN product_sales p2 ON p1.prod_id = p2.prod_id AND p1.prod_id < p2.prod_id
JOIN product_sales p3 ON p3.prod_id = p2.prod_id AND p2.prod_id < p3.prod_id
WHERE p1.qty > 0 AND p2.qty > 0 AND p3.qty > 0
GROUP BY p1.prod_id, p2.prod_id, p3.prod_id
ORDER BY frequency DESC
LIMIT 1;
```

### Revenue Distribution Analysis

**Percentage Split by Segment**
```sql
SELECT pd.segment_id, 
       SUM(ps.price), 
       SUM(ps.price) * 100 / (SELECT SUM(price) FROM product_sales)
FROM product_sales ps 
JOIN product_details pd ON (ps.prod_id = pd.product_id)
GROUP BY segment_id;
```

## 📊 Key Business Metrics

### Sales Performance Indicators
- **Total Revenue**: Pre-discount revenue across all products
- **Discount Impact**: Total discount amounts and average per transaction
- **Volume Metrics**: Quantity sold by product, segment, and category
- **Transaction Volume**: Unique transaction count and analysis

### Customer Behavior Analytics
- **Membership Impact**: Revenue and transaction differences between members and non-members
- **Average Order Value**: Transaction-level revenue analysis
- **Purchase Patterns**: Products per transaction and combination analysis
- **Customer Segmentation**: Behavioral differences between customer groups

### Product Intelligence
- **Top Performers**: Revenue-ranked product identification
- **Segment Leadership**: Best-selling products within each segment
- **Category Performance**: Revenue and quantity distribution across categories
- **Market Penetration**: Product reach across the customer base
- **Cross-Selling Opportunities**: Product combination frequency analysis

## 🔧 Advanced Analytics Features

### Statistical Functions
- **PERCENT_RANK()**: Percentile calculations for revenue distribution
- **CASE STATEMENTS**: Dynamic categorization and conditional logic
- **Subqueries**: Nested calculations for percentage computations
- **CTEs**: Complex temporary result sets for multi-step analysis

### Business Intelligence Calculations
- **Penetration Rates**: Market reach calculations for each product
- **Revenue Splits**: Percentage distribution across various dimensions
- **Comparative Analysis**: Member vs non-member performance metrics
- **Trend Analysis**: Transaction and revenue pattern identification

### Data Aggregation Techniques
- **Multi-Level Grouping**: Segment, category, and product-level analysis
- **Cross-Dimensional Analysis**: Revenue splits across multiple hierarchies
- **Conditional Aggregation**: Member-specific calculations
- **Ranking Functions**: Top performer identification with LIMIT clauses

## 📈 Business Intelligence Applications

### Retail Strategy Insights
- **Inventory Planning**: Product performance data for stock optimization
- **Pricing Strategy**: Revenue and discount impact analysis
- **Category Management**: Segment and category performance evaluation
- **Customer Retention**: Member vs non-member behavior comparison

### Marketing Analytics
- **Cross-Selling Opportunities**: Product combination analysis for bundling strategies
- **Customer Segmentation**: Behavioral patterns for targeted campaigns
- **Penetration Analysis**: Market reach assessment for product promotion
- **Revenue Optimization**: Discount effectiveness and pricing impact

### Operational Excellence
- **Transaction Analysis**: Processing volume and pattern identification
- **Performance Benchmarking**: Comparative analysis across products and categories
- **Market Share Analysis**: Revenue distribution and competitive positioning
- **Trend Identification**: Sales pattern recognition for forecasting

## 🎯 Learning Outcomes

### Advanced SQL Mastery
- **Complex JOIN operations** across multiple tables
- **Window functions** for statistical analysis (PERCENT_RANK)
- **Conditional logic** with advanced CASE statements
- **Subquery optimization** for percentage calculations
- **Common Table Expressions** for multi-step analysis

### Business Analytics Skills
- **Retail metrics calculation** (penetration rates, revenue splits)
- **Customer segmentation** analysis techniques
- **Statistical analysis** with percentiles and distributions
- **Market basket analysis** for cross-selling insights
- **Performance benchmarking** across multiple dimensions

### Data-Driven Decision Making
- **KPI development** for retail performance tracking
- **Comparative analysis** methodologies
- **Trend identification** through data patterns
- **Revenue optimization** through discount analysis
- **Customer behavior** interpretation and insights

## 💡 Advanced Features

### Market Penetration Analysis
```sql
-- Calculate how many transactions include each product
SELECT prod_id,
       COUNT(DISTINCT txn_id) AS transactions_with_product,
       COUNT(DISTINCT txn_id) * 1.0 / (SELECT COUNT(DISTINCT txn_id) FROM product_sales) AS penetration
FROM product_sales
GROUP BY prod_id;
```

### Revenue Distribution Calculations
```sql
-- Percentage split of revenue by category
SELECT pd.category_id, 
       SUM(ps.price), 
       SUM(ps.price) * 100 / (SELECT SUM(price) FROM product_sales)
FROM product_sales ps 
JOIN product_details pd ON (ps.prod_id = pd.product_id)
GROUP BY category_id;
```

### Customer Behavior Insights
```sql
-- Average revenue comparison between members and non-members
SELECT 
    CASE WHEN member = 't' THEN 'Member' ELSE 'Non-Member' END AS category,
    AVG(price) as avg_revenue
FROM product_sales
GROUP BY category;
```

## 🤝 Contributing

This project welcomes enhancements in:
- Additional retail metrics and KPIs
- Advanced statistical analysis functions
- Customer lifetime value calculations
- Seasonal trend analysis
- Inventory optimization queries

**⭐ Star this repository if it helped you master retail analytics with SQL!**
