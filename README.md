# **Retail Sales Performance Analysis**

## **Project Overview**

This project analyzes retail sales data to evaluate sales performance, product profitability, customer spending behavior, and sales trends. The analysis aims to identify top-performing products, high-revenue cities, customer segments, and potential business losses using SQL.

## **Project Details**

- **Tools:** PostgreSQL, DBeaver, SQL, Google Looker Studio
- **Database:** `retail_sales`
- **Schema:** `public`
- **Table:** `orders`
- **Dataset:** Retail Sales Performance Dataset
- **Total Records:** 9,994
- **Analysis Period:** 2017–2020

## **Objectives**

- Evaluate overall sales performance across cities and product categories.
- Identify best-selling and most profitable products.
- Analyze customer spending behavior and segment contributions.
- Examine monthly and annual sales trends.
- Validate data quality by checking missing values, potential duplicates, and unusual numeric values.

## **Analysis Process**

### **1. Data Overview**

Retrieved sample records to understand the dataset structure and examined its overall characteristics.

**Key Activities:**

- Counted total records and identified the transaction date range.
- Calculated the number of unique orders, customers, products, and cities.
- Reviewed dataset structure and column information.

### **2. Data Validation**

Performed data quality checks to assess dataset completeness, consistency, and reliability.

**Key Findings:**

- No missing values or unusual numeric values were found in the selected key columns.
- Eight order-product combinations were flagged for further inspection.
- One exact duplicate record was identified.

### **3. Sales Performance Analysis**

Evaluated sales performance across cities and product categories.

**Business Questions:**

- Which cities generate the highest revenue?
- Which product categories contribute the most to sales and profit?

**Key Findings:**

- New York City generated the highest revenue, followed by Los Angeles and Seattle.
- Technology contributed the highest revenue, followed by Furniture.

### **4. Product Performance & Profitability**

Analyzed product sales volume and profitability to identify top-performing and loss-making products.

**Business Questions:**

- Which products have the highest sales volume?
- Which products generate the highest profit?
- Which products contribute to business losses?

**Key Findings:**

- Logitech P710e Mobile Speakerphone ranked first in total units sold.
- Canon imageCLASS 2200 Advanced Copier generated the highest total sales and profit.
- Cubify CubeX 3D Printer Double Head Print recorded the largest cumulative loss.

### **5. Customer Analysis**

Examined customer spending behavior and revenue contributions across customer segments.

**Business Questions:**

- What are the average, minimum, and maximum customer spending values?
- Who are the highest-spending customers?
- Which customer segments contribute the most revenue and profit?

**Key Findings:**

- Average customer spending was 2,896.85.
- Sean Miller recorded the highest total spending.
- Consumer contributed the highest revenue, followed by Corporate.

### **6. Sales Trends Analysis**

Analyzed monthly and annual sales performance to identify revenue and profit trends.

**Business Questions:**

- How do monthly revenue, profit, quantity sold, and orders change over time?
- Which year recorded the highest sales performance?

**Key Findings:**

- Monthly revenue and profit fluctuated throughout the analysis period.
- 2020 recorded the highest annual revenue, profit, and total orders.

### **7. Retail Sales Dashboard**

Developed an interactive dashboard using Google Looker Studio to visualize retail sales performance, product profitability, customer contributions, and sales trends.

**Key Analysis:**

- Sales Performance by City
- Sales by Category and Region
- Top 5 Products by Sales
- Profit Performance by Subcategory
- Customer Spending Analysis
- Customer Segment Performance
- Monthly and Annual Sales Trends
**Interactive Dashboard:**

[**View Live Dashboard – Google Looker Studio**](https://datastudio.google.com/reporting/b70f4a3f-0fab-4cce-9379-8d78dc4dbebb)

## **Key Business Recommendations**

- Focus on high-performing cities and product categories to support revenue growth.
- Prioritize profitable products while reviewing pricing and discount strategies for loss-making products.
- Develop targeted strategies to strengthen relationships with high-value customers.
- Monitor customer segment contributions to identify opportunities for sales growth.
- Use monthly and annual sales trends to support inventory planning and business decisions.

## **SQL Skills Demonstrated**

- Data Exploration
- Data Validation
- Aggregate Functions (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`)
- Conditional Aggregation (`FILTER`)
- Data Grouping and Sorting (`GROUP BY`, `ORDER BY`)
- Common Table Expressions (CTE)
- Date Functions (`DATE_TRUNC`, `EXTRACT`)
- Duplicate Detection
- Data Aggregation
- Customer Segmentation
- Sales Performance Analysis
- Product Profitability Analysis

## **Project Files**

- `retail_sales_dataset.xlsx` – Dataset used for retail sales analysis.
- `retail_sales_analysis.sql` – SQL queries used for data exploration, validation, and business analysis.
- `retail_sales_dashboard.jpg` – Dashboard preview.
- `README.md` – Project documentation.

## **Conclusion**

This project demonstrates the use of SQL to explore retail sales data, validate data quality, analyze business performance, and generate actionable insights. The findings provide a foundation for improving product profitability, customer strategies, and overall sales performance.
