# 👥 Employee Database Management System

A comprehensive MySQL database project demonstrating advanced SQL operations, stored procedures, functions, and window functions using a realistic employee management system. This project showcases enterprise-level database operations and complex query optimization techniques.

## 📊 Project Overview

This project implements a complete employee database management system with advanced SQL features including data manipulation, complex joins, stored procedures, user-defined functions, and window functions. The system manages employee records, departments, managers, salaries, and titles with real-world business logic.

## 🎯 Key Features

### Database Operations
- **Data Manipulation**: INSERT, UPDATE, DELETE operations with complex conditions
- **Advanced Joins**: LEFT JOIN, CROSS JOIN, multiple table joins
- **Subqueries**: Correlated and non-correlated subqueries with EXISTS and IN clauses
- **UNION Operations**: Combining result sets with proper NULL handling
- **Window Functions**: ROW_NUMBER(), PARTITION BY for advanced analytics

### Stored Procedures & Functions
- **Custom Procedures**: Employee information retrieval and salary calculations
- **User-Defined Functions**: Reusable business logic for salary computations
- **Parameter Handling**: IN, OUT, and INOUT parameters with proper variable management
- **Error Handling**: Robust procedure design with proper delimiter usage

### Advanced Analytics
- **Ranking Systems**: Employee ranking with partitioning
- **Aggregation Functions**: Complex GROUP BY operations with multiple conditions
- **Date Range Queries**: Hire date filtering and temporal analysis
- **Gender-Based Analytics**: Demographic analysis with statistical insights

## 🗄️ Database Schema

### Core Tables
- **employees**: Employee personal information (emp_no, first_name, last_name, hire_date, gender)
- **departments**: Department structure (dept_no, dept_name)
- **dept_manager**: Department management hierarchy (emp_no, dept_no, from_date, to_date)
- **dept_emp**: Employee department assignments
- **salaries**: Employee compensation history
- **titles**: Job title progression tracking

### Custom Tables
- **department_dups**: Duplicate management for data quality testing
- **Department_manager_dups**: Manager hierarchy backup with test data
- **emp_manager**: Custom employee-manager relationship mapping

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0+ or MariaDB 10.3+
- Database user with CREATE, ALTER, INSERT, UPDATE, DELETE privileges
- Understanding of stored procedures and functions

### Database Setup

1. **Initialize the employees database**
   ```sql
   USE employees;
   ```

2. **Configure SQL mode for compatibility**
   ```sql
   SET @@global.sql_mode := REPLACE(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
   ```

3. **Run the provided scripts to create custom tables and procedures**

## 📋 Advanced SQL Techniques Demonstrated

### Complex Data Manipulation

**Dynamic Table Creation with Constraints**
```sql
CREATE TABLE department_dups (
    dept_no VARCHAR(20),
    dept_name CHAR(40) NULL
);

ALTER TABLE department_dups MODIFY dept_no VARCHAR(4) NULL;
```

**Conditional Data Updates**
```sql
UPDATE department_dups 
SET dept_no = "d01" 
WHERE dept_name = "Public relations";
```

### Advanced Join Operations

**Multi-Table JOIN with Complex Conditions**
```sql
SELECT e.first_name, e.last_name, e.hire_date, dm.from_date, d.dept_name
FROM employees e 
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON d.dept_no = dm.dept_no;
```

**Cross Join with Filtering**
```sql
SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments d 
WHERE d.dept_no = "d009"
ORDER BY dm.emp_no;
```

### Stored Procedures

**Employee Information Retrieval**
```sql
DELIMITER $$
CREATE PROCEDURE emp_info(
    IN p_first_name VARCHAR(255), 
    IN p_last_name VARCHAR(255), 
    OUT p_emp_no INTEGER
)
BEGIN
    SELECT e.emp_no INTO p_emp_no 
    FROM employees e
    WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
END$$
DELIMITER ;
```

**Average Salary Calculation**
```sql
DELIMITER $$
CREATE PROCEDURE return_avg_salary1(
    OUT p_avg_salary DECIMAL(10,2),
    IN p_emp_no INTEGER
)
BEGIN 
    SELECT AVG(salary) INTO p_avg_salary 
    FROM salaries s 
    WHERE p_emp_no = s.emp_no;
END$$
DELIMITER ;
```

### User-Defined Functions

**Employee Salary Lookup Function**
```sql
DELIMITER $$
CREATE FUNCTION f_emp_salary(
    p_first_name VARCHAR(30), 
    p_last_name VARCHAR(30)
) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE v_emp_salary INTEGER;
    SELECT s.salary INTO v_emp_salary 
    FROM employees e 
    JOIN salaries s ON e.emp_no = s.emp_no 
    WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
    RETURN v_emp_salary;
END$$
DELIMITER ;
```

### Window Functions & Analytics

**Employee Ranking with Partitioning**
```sql
SELECT emp_no, first_name, last_name, 
       ROW_NUMBER() OVER(
           PARTITION BY first_name 
           ORDER BY last_name DESC
       ) AS row_num
FROM employees;
```

**Department Manager Ranking**
```sql
SELECT emp_no, dept_no,
       ROW_NUMBER() OVER(ORDER BY emp_no) AS row_num
FROM dept_manager;
```

### Advanced Subqueries

**EXISTS Clause with Correlated Subquery**
```sql
SELECT * FROM employees e 
WHERE EXISTS (
    SELECT * FROM titles t 
    WHERE t.emp_no = e.emp_no AND title = "Assistant Engineer"
);
```

**IN Clause with Date Range Filtering**
```sql
SELECT * FROM dept_manager 
WHERE emp_no IN (
    SELECT emp_no FROM employees 
    WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01'
);
```

### Complex UNION Operations

**Combining Employee and Manager Data**
```sql
SELECT e.emp_no, e.first_name, e.last_name, NULL AS dept_no, NULL AS from_date
FROM employees e 
WHERE last_name = 'denis' 
UNION ALL 
SELECT NULL AS emp_no, NULL AS first_name, NULL AS last_name, dm.dept_no, dm.from_date
FROM dept_manager dm
ORDER BY -emp_no DESC;
```

## 📈 Business Logic Implementation

### Employee Management Operations
- **Hierarchical Queries**: Manager-employee relationship mapping
- **Salary Analysis**: Average salary calculations with temporal filtering
- **Department Analytics**: Cross-departmental employee distribution
- **Gender Demographics**: Workforce composition analysis

### Data Quality Management
- **Duplicate Handling**: Custom duplicate tables for data validation
- **NULL Value Management**: Strategic NULL handling in UNION operations
- **Data Type Optimization**: VARCHAR sizing and constraint management

### Performance Optimization
- **Index Usage**: Proper indexing on join columns (emp_no, dept_no)
- **Query Optimization**: Efficient WHERE clause positioning
- **Procedure Caching**: DETERMINISTIC functions for better performance

## 🔧 Advanced Features

### Procedure Execution
```sql
-- Call employee information procedure
SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;
```

### Function Usage
```sql
-- Get employee salary using custom function
SELECT f_emp_salary('John', 'Smith') AS employee_salary;
```

### Complex Analytics Queries
```sql
-- Employee hierarchy with manager assignment
SELECT A.* FROM (
    SELECT e.emp_no AS employee_ID, 
           MIN(de.dept_no) AS department_code, 
           (SELECT emp_no FROM dept_manager WHERE emp_no = 110022) AS manager_ID
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no 
    WHERE emp_no <= 10020
    GROUP BY emp_no
    ORDER BY emp_no
) AS A;
```

## 📊 Query Categories

### Data Retrieval Queries
- Employee information with title history
- Department manager assignments
- Salary progression tracking
- Gender-based workforce analysis

### Data Modification Operations
- Dynamic table alterations
- Conditional updates and deletions  
- Bulk data insertions with validation
- Duplicate record management

### Administrative Functions
- Stored procedure creation and execution
- User-defined function implementation
- System variable configuration
- Database optimization settings

## 🎯 Learning Outcomes

### SQL Mastery
- **Advanced JOIN techniques** for complex relationships
- **Stored procedures** for business logic encapsulation
- **User-defined functions** for reusable calculations
- **Window functions** for advanced analytics
- **Complex subqueries** for sophisticated filtering

### Database Design
- **Normalization principles** in practice
- **Constraint management** for data integrity
- **Index optimization** for query performance
- **Data type selection** for storage efficiency

### Business Intelligence
- **Employee analytics** and reporting
- **Hierarchical data management** 
- **Temporal data analysis** with date ranges
- **Demographic reporting** and insights

## 🏆 Real-World Applications

This project demonstrates skills essential for:
- **Enterprise HR Systems** - Employee lifecycle management
- **Business Intelligence** - Workforce analytics and reporting  
- **Database Administration** - Performance optimization and maintenance
- **ETL Processes** - Data transformation and quality management
- **Reporting Systems** - Complex query development for dashboards

## 💡 Best Practices Implemented

### Code Quality
- **Proper delimiter usage** in stored procedures
- **Consistent naming conventions** for variables and parameters
- **Error handling** in complex procedures
- **Documentation** through meaningful variable names

### Performance Optimization
- **Efficient indexing** on frequently joined columns
- **Query plan optimization** with proper WHERE clause ordering
- **DETERMINISTIC functions** for caching benefits
- **Appropriate data types** for storage optimization

### Security Considerations
- **Parameter validation** in stored procedures
- **SQL injection prevention** through parameterized queries
- **Access control** through procedure-based data access
- **Data integrity** through proper constraint management

## 🤝 Contributing

This project welcomes contributions in the form of:
- Additional stored procedures for common HR operations
- Performance optimization suggestions
- Advanced analytics queries
- Documentation improvements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built using the classic MySQL employees sample database structure
- Demonstrates enterprise-level database management practices
- Serves as a comprehensive reference for advanced SQL techniques

---

**⭐ Star this repository if it helped you master advanced SQL!**