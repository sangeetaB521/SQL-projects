# 🍿 Foodie-Fi Subscription Analytics

A comprehensive SQL analytics project for a streaming subscription service, demonstrating advanced data analysis techniques including customer journey mapping, subscription behavior analysis, and churn prediction. This project showcases enterprise-level subscription analytics with complex business intelligence queries for the food streaming industry.

## 📊 Project Overview

This project implements a complete subscription analytics system for Foodie-Fi, featuring multi-dimensional analysis across customer onboarding journeys, plan transitions, and revenue optimization. The system provides actionable insights for customer retention, pricing strategies, and subscription lifecycle management.

## 🎯 Business Analysis Categories

### 👥 Customer Journey Analysis
- **Onboarding Tracking**: Free trial to paid conversion analysis
- **Subscription Transitions**: Plan upgrade and downgrade patterns
- **Customer Lifecycle**: Complete journey from trial to churn mapping

### 📈 Subscription Analytics
- **Plan Distribution**: Customer count across different subscription tiers
- **Churn Analysis**: Customer retention and loss patterns
- **Revenue Intelligence**: Subscription revenue optimization insights

### 💳 Conversion Analytics
- **Trial Conversion**: Free trial to paid subscription rates
- **Upgrade Patterns**: Monthly to annual subscription transitions
- **Retention Metrics**: Customer lifetime value and subscription duration

## 🗄️ Database Schema

### Core Tables
- **plans**: Subscription plan details (plan_id, plan_name, price)
- **subscriptions**: Customer subscription history (customer_id, plan_id, start_date)

### Key Relationships
- **Subscriptions ↔ Plans**: plan_id connects customer subscriptions to plan details
- **Customer Journey**: Temporal tracking of plan transitions per customer
- **Subscription Hierarchy**: Trial → Basic → Pro Monthly → Pro Annual progression

## 🚀 Advanced SQL Techniques Demonstrated

### Customer Journey Mapping

**Multi-Customer Onboarding Analysis**
```sql
-- Track customer journey across multiple plan transitions
SELECT s.customer_id, plan_name, s.start_date 
FROM plans p 
JOIN subscriptions s USING(plan_id)
WHERE s.customer_id IN ('1', '2','11','13','15','16','18','19')
GROUP BY s.customer_id, plan_name, s.start_date;
```

**Customer Lifecycle Insights**
- Customer 1: Trial → Basic Monthly (Standard conversion)
- Customer 2: Trial → Pro Annual (Premium upgrade)
- Customer 11: Trial → Churn (Early dropout)
- Customer 13: Trial → Basic → Pro Monthly (Gradual upgrade)
- Customer 15: Trial → Pro Monthly → Churn (Premium churn)
- Customer 16: Trial → Basic → Pro Annual (Long-term conversion)
- Customer 18: Trial → Pro Monthly (Direct premium)
- Customer 19: Trial → Pro Monthly → Pro Annual (Premium evolution)

### Subscription Analytics

**Total Customer Base**
```sql
-- Unique customer count across all time
SELECT COUNT(DISTINCT(customer_id)) AS no_of_customers 
FROM subscriptions;
```

**Monthly Trial Distribution**
```sql
-- Trial signup patterns by month
SELECT DATE_FORMAT(start_date,'%m-%Y') AS trials, 
       COUNT(*) AS trial_count
FROM subscriptions
WHERE plan_id = 0
GROUP BY trials
ORDER BY trials;
```

### Advanced Churn Analysis

**Customer Churn Rate Calculation**
```sql
-- Churn percentage with precision
SELECT plan_name, 
       COUNT(DISTINCT(customer_id)) AS cust_count, 
       ROUND(COUNT(DISTINCT(customer_id)) * 100 / 
             (SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions), 2) AS percentage
FROM subscriptions s 
JOIN plans p USING(plan_id)
WHERE plan_id = 4
GROUP BY plan_name;
```

**Trial-to-Churn Analysis**
```sql
-- Customers churning immediately after trial
WITH trial_churn AS (
    SELECT customer_id
    FROM subscriptions
    WHERE plan_id = 0
)
SELECT 
    COUNT(s.customer_id) AS churned_customers,
    ROUND((COUNT(s.customer_id) * 100.0) / 
          (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 0) AS churn_percentage
FROM subscriptions s
JOIN trial_churn t ON s.customer_id = t.customer_id
WHERE s.plan_id = 4;
```

### Conversion Time Analysis

**Average Days to Annual Upgrade**
```sql
-- Time from trial to annual subscription
SELECT ROUND(AVG(DATEDIFF(a.start_date, t.start_date)), 0) AS avg_days_to_annual
FROM subscriptions t
JOIN subscriptions a ON t.customer_id = a.customer_id
WHERE t.plan_id = 0 AND a.plan_id = 3;
```

### Plan Transition Analytics

**Post-Trial Plan Distribution**
```sql
-- Customer distribution after free trial
SELECT COUNT(DISTINCT customer_id) AS cust_count, 
       ROUND((COUNT(DISTINCT customer_id) * 100.0) / 
             (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage
FROM subscriptions
WHERE plan_id NOT IN ('0', '4');
```

**Downgrade Pattern Analysis**
```sql
-- Pro Monthly to Basic Monthly downgrades
SELECT COUNT(DISTINCT s1.customer_id) AS cust_count 
FROM subscriptions s1 
JOIN subscriptions s2 ON s1.customer_id = s2.customer_id
WHERE s1.plan_id = 1 AND s2.plan_id = 2 
  AND s1.start_date BETWEEN '2020-01-01' AND '2020-12-31';
```

### Year-End Subscription Analysis

**Plan Breakdown at Year-End**
```sql
-- Customer distribution by plan at 2020-12-31
SELECT COUNT(DISTINCT customer_id) AS cust_count, 
       ROUND(COUNT(DISTINCT customer_id) * 100.0 / 
             (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 2) AS percentage,
       plan_name 
FROM plans p 
JOIN subscriptions s USING(plan_id)
WHERE start_date <= '2020-12-31' 
  AND customer_id NOT IN (
      SELECT customer_id FROM subscriptions WHERE start_date > '2020-12-31'
  )
GROUP BY plan_name;
```

## 📊 Key Business Metrics

### Subscription Performance Indicators
- **Customer Base Size**: Total unique subscribers across all plans
- **Trial Conversion Rate**: Free trial to paid subscription percentage
- **Churn Rate**: Customer loss rate and retention metrics
- **Plan Distribution**: Customer spread across subscription tiers

### Customer Behavior Analytics
- **Upgrade Patterns**: Monthly to annual subscription transitions
- **Downgrade Analysis**: Premium to basic plan movement
- **Customer Lifetime**: Average subscription duration by plan type
- **Seasonal Trends**: Monthly trial signup and conversion patterns

### Revenue Intelligence
- **Annual Plan Adoption**: Premium subscription uptake rates
- **Plan Transition Timing**: Average time for customer upgrades
- **Retention Analysis**: Customer stickiness by plan type
- **Churn Prediction**: Early indicators of customer departure

## 🔧 Advanced Analytics Features

### Temporal Analysis Functions
- **DATE_FORMAT()**: Monthly trend analysis and seasonal patterns
- **DATEDIFF()**: Subscription duration and transition timing
- **Temporal JOINs**: Customer journey tracking across time periods
- **Window Functions**: Cohort analysis and retention calculations

### Business Intelligence Calculations
- **Conversion Rates**: Trial to paid subscription percentages
- **Churn Metrics**: Customer loss analysis and predictions
- **Revenue Attribution**: Plan-based revenue contribution
- **Customer Segmentation**: Behavior-based subscriber grouping

### Data Processing Techniques
- **Common Table Expressions**: Complex multi-step subscription analysis
- **Self-JOINs**: Customer plan transition tracking
- **Conditional Aggregation**: Plan-specific metric calculations
- **Cohort Analysis**: Time-based customer behavior patterns

## 📈 Business Intelligence Applications

### Subscription Strategy Optimization
- **Pricing Strategy**: Plan performance and customer price sensitivity
- **Retention Programs**: Churn prediction and prevention strategies
- **Upgrade Incentives**: Monthly to annual conversion optimization
- **Trial Conversion**: Free trial to paid subscription improvement

### Customer Experience Analytics
- **Onboarding Optimization**: Trial experience and conversion rates
- **Plan Recommendations**: Personalized subscription tier suggestions
- **Retention Campaigns**: Targeted interventions for at-risk customers
- **Satisfaction Metrics**: Plan satisfaction and upgrade likelihood

### Revenue Management
- **Subscription Forecasting**: Future revenue prediction models
- **Customer Lifetime Value**: Long-term subscriber value calculation
- **Plan Performance**: Revenue contribution by subscription tier
- **Seasonal Planning**: Monthly trend-based capacity planning

## 🎯 Learning Outcomes

### Subscription Analytics Mastery
- **Customer journey** mapping and analysis techniques
- **Churn prediction** modeling and prevention strategies
- **Conversion optimization** through data-driven insights
- **Retention analysis** and customer lifetime value calculation
- **Plan transition** pattern recognition and optimization

### Advanced SQL for SaaS
- **Temporal analysis** with date functions and calculations
- **Self-JOIN operations** for customer journey tracking
- **Common Table Expressions** for complex subscription analysis
- **Window functions** for cohort and retention analysis
- **Statistical calculations** for conversion and churn rates

### Data-Driven Decision Making
- **KPI development** for subscription business models
- **Cohort analysis** for customer behavior understanding
- **Predictive modeling** for subscription growth forecasting
- **A/B testing** for plan optimization and pricing strategies
- **Customer segmentation** for personalized marketing

## 🏆 Real-World Applications

This project demonstrates expertise essential for:
- **SaaS Analytics** - Subscription business performance optimization
- **Streaming Services** - Content platform subscriber analysis
- **Freemium Models** - Trial conversion and upgrade strategies
- **Customer Success** - Retention and churn prevention programs
- **Revenue Operations** - Subscription revenue optimization
- **Product Analytics** - Feature usage and plan satisfaction analysis

## 💡 Advanced Features

### Customer Cohort Analysis
```sql
-- Monthly cohort retention tracking
SELECT 
    DATE_FORMAT(first_subscription, '%Y-%m') AS cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_size,
    COUNT(CASE WHEN months_active >= 3 THEN customer_id END) AS month_3_retention
FROM customer_cohorts
GROUP BY cohort_month;
```

### Subscription Revenue Calculation
```sql
-- Monthly recurring revenue by plan
SELECT 
    plan_name,
    COUNT(DISTINCT customer_id) AS active_subscribers,
    COUNT(DISTINCT customer_id) * price AS monthly_revenue
FROM subscriptions s
JOIN plans p USING(plan_id)
WHERE start_date <= CURRENT_DATE 
  AND plan_id != 4
GROUP BY plan_name, price;
```

### Customer Lifetime Value
```sql
-- Average customer lifetime value by plan
SELECT 
    plan_name,
    AVG(DATEDIFF(churn_date, start_date)) AS avg_lifetime_days,
    AVG(DATEDIFF(churn_date, start_date) * price / 30) AS avg_lifetime_value
FROM subscription_history
GROUP BY plan_name, price;
```

## 🤝 Contributing

This project welcomes enhancements in:
- Advanced churn prediction algorithms
- Customer segmentation machine learning models
- Real-time subscription analytics
- A/B testing framework for plan optimization
- Predictive lifetime value calculations

**⭐ Star this repository if it helped you master subscription analytics with SQL!**
