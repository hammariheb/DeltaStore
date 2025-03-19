# Deltastore Tableau Dashboard

## Project Overview
This project is a Tableau dashboard analysis based on the data transformations performed in the `deltastore_dbt_transformation` project. After creating the marts (`dim_customers`, `fct_products`, `fct_shipments`, `fct_order_customers`, `fct_order_items`, `fct_payments`, and `fct_reviews`), they were exported and used to build three dashboards:

- **Customer Analysis**
- **Product & Pricing Optimization**
- **Order Fulfillment & Logistics**

The Tableau dashboard file is available at `deltastore_tableau_dashboards/dashboard_tableau.twb`, and the screenshots of the dashboards are located in `deltastore_tableau_dashboards/screenshots/`.

---
## 1. Customer Analysis Dashboard
This dashboard provides insights into customer behavior and segmentation.

### Visualizations:
1. **Average Order Value (AOV):** A KPI card displaying the average order value.
2. **Repartition of Customers Around the World:**
   - Cities are generated from the `city` column.
   - Customer count is used for color and labels.
   - Density plot is applied for better visualization.
3. **Customer Lifetime Value (CLV):**
   - A line chart displaying the total revenue per month.
   - A trend line is added to observe revenue evolution.
4. **Customer Segmentation Bar Chart:**
   - Customers are segmented using a calculated field that classifies them based on their first purchase date into three categories, considering a 6-month period:
     ```sql
     IF DATEDIFF('month',[First order date month per customer], TODAY()) <= 6 THEN "New customers"
     ELSEIF DATEDIFF('month',[Last order date per customer], TODAY())> 6 THEN "At-risk customers"
     ELSE "Casual customers"
     END
     ```
   - A dual-axis chart is created with total revenue.
5. **Customer Retention %:**
   - A cohort analysis is performed using calculated fields:
     - **Months Since First Purchase** (calculated field)
     - **Cohort Size** (number of customers in the first month)
     - **Retention Rate %**:
       ```sql
       COUNTD([Unified Customer Id (Fct Order Customers.Csv)]) / SUM([Nb customers per first month])
       ```
   - The visual can be read **horizontally** (customer retention over time) or **vertically** (cohort comparison per month).
   
### Filters:
- Dynamic customer segmentation filter (list selection)

---
## 2. Product & Pricing Optimization Dashboard
This dashboard helps optimize product pricing strategies and revenue growth.

### Visualizations:
1. **Transaction Status:**
   - A pie chart showing the percentage of each transaction status.
   - The sum of `amount` is used for calculations.
2. **Month-over-Month (MoM) % Growth in Total Revenue & Average Order Value:**
   - A calculated field for MoM growth rate:
     ```sql
     IF LOOKUP(SUM([Total Price]), -1) != 0 THEN
         (SUM([Total Price]) - LOOKUP(SUM([Total Price]), -1)) / LOOKUP(SUM([Total Price]), -1)
     ELSE
         NULL
     END
     ```
   - Dual-axis chart using **total revenue** and **average order value**.
   - Dynamic colors are used for easier interpretation.
3. **Rating vs Revenue by Categories and Products:**
   - The average rating per product is plotted in each category.
   - Dynamic color coding is applied.
   - A reference line is set at **rating = 3** to indicate low-rated products.
4. **Top Performing Products & Categories by Revenue and Units Sold:**
   - A stacked bar chart displays total revenue per product in each category.
   - Ordered in **descending order** within each category.
   - Quantity of units sold is included.

---
## 3. Order Fulfillment & Logistics Dashboard
This dashboard analyzes order fulfillment efficiency and carrier performance.

### Visualizations:
1. **Key Performance Indicators (KPIs):**
   - Best Performing Carrier
   - Average Delivery Time
   - On-Time Delivery Percentage
2. **Delivery Delay Heatmap:**
   - Average days between shipment and delivery per city.
   - Color-coded heatmap for better visualization.
3. **Carrier Performance Analysis:**
   - Packed bubbles chart representing each carrier's success rate percentage.
   - A calculated field for success rate:
     ```sql
     COUNT(IF [Shipment Status] = "Delivered" THEN 1 END) / COUNT([Shipment Status])
     ```

### Filters:
- Carrier filter
- Shipment status filter

---
## Project Files Structure
```
📁 deltastore_tableau_dashboards
│-- 📁 screenshots/ (Contains screenshots of the dashboards)
│-- 📄 dashboard_tableau.twb (Tableau dashboard file)
│-- 📄 README.md (This documentation file)
```

## Conclusion
This project provides key insights into customer behavior, product performance, and logistics efficiency. The dashboards are interactive, with filters allowing for dynamic data exploration.

