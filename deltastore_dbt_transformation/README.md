# deltastore_dbt_transformation

## Project Overview
The `deltastore_dbt_transformation` folder contains all the transformations and data models for the `deltastore` project. This project is designed to process and transform data from two different sources (`old_store` and `new_store`) and create standardized models for analysis. The transformations are implemented using `dbt`, ensuring data integrity, freshness, and consistency.

## Data Sources

### `old_store`
The `old_store` source contains data about customers, orders, shipments, payments, products, and more in the base store. The data is stored in the `old_store` schema, and dbt enforces specific validation and freshness constraints:

#### Tables:
- **customers**: Contains customer details. Ensures `customer_id` is unique and not null.
- **shipments**: Stores shipment details with status validation (Pending, Delivered, Shipped, Cancelled).
- **orders**: Holds order information and ensures `order_date` is valid.
- **products**: Maintains product information with uniqueness constraints.
- **order_items**: Links orders and products with referential integrity.
- **payment**: Manages transaction data, ensuring valid status values (Completed, Pending, Failed).
- **suppliers**: Stores supplier details.
- **reviews**: Captures customer reviews and validates `review_date`.

### `new_store`
The `new_store` source contains data for a new e-commerce store, structured under the `new_store` schema.

#### Tables:
- **products**: Stores product details, ensuring `id` is unique and not null.
- **users**: Contains user information, enforcing uniqueness on `id`.

## Data Quality Tests
The following data tests are implemented to maintain data consistency:
- Uniqueness and not null checks on primary keys.
- Relationship constraints between tables.
- Validity checks on date fields.
- Accepted value constraints on categorical columns.
- **Custom test:** `assert_order_amount_is_positive` to validate that order totals are always positive.

## Staging Models
Staging models standardize and clean raw data from both stores:

- **`stg_new_store_users`**: Standardizes user data from `new_store`.
- **`stg_old_store_products`**: Cleans product data from `old_store`.
- **`stg_old_store_suppliers`**: Processes supplier details.
- **`stg_old_store_orders`**: Standardizes order records.
- **`stg_old_store_payments`**: Normalizes payment transactions.
- **`stg_cities_filtered`**: Extracts and filters U.S. state and country names.
- **`stg_incremental_monthly_customers`**: Counts new customers per month in an incremental fashion.

## Intermediate Models
Intermediate models are used for data consolidation and further processing:

- **`int_customer_id_mapping`**: Merges customer data from both stores to create a unified view.
- **`int_customer_cities`**: Combines customer location data with external city and country references to standardize geographic information.
- **`int_product_id_mapping`**: Maps products from `old_store` and `new_store` into a single unified product dataset, ensuring consistency across both sources.
- **`int_reviews_customers_products`**: Joins customer reviews with product and customer details to analyze review patterns and customer satisfaction levels.

## Snapshots
Snapshots capture historical changes in critical tables, enabling tracking of data evolution over time:

- **`customers_snapshot`**: Tracks updates to customer records over time, using the `updated_at` timestamp to detect changes and maintain historical records.
- **`orders_snapshot`**: Maintains historical versions of order data, ensuring order status changes are recorded over time.
- **`shipment_snapshot`**: Tracks shipment status and delivery details by monitoring specific columns such as `shipment_status`, `delivery_date`, and `shipment_date`.

## Marts
Marts are the final, refined data models used for business analysis and reporting:

- **`dim_customers`**: Consolidates customer data across all sources into a single dimension table, ensuring a unique customer ID and standardizing attributes like address, country, and contact details.
- **`fct_order_customers`**: Creates a structured view of order details, merging data from different sources and ensuring consistency across `old_store` and `new_store` orders.
- **`fct_order_items`**: Creates a structured view of order items details, merging data from different sources and ensuring consistency across `old_store` and `new_store` order items.
- **`fct_products`**: Provides a single source of truth for product information, mapping product data from different stores into a unified format.
- **`fct_reviews`**: Standardizes review data, linking it to customer and product information to provide insights into customer satisfaction.
- **`dim_payments`**: Provides a single source of truth of payments and other precious infos about payments.
- **`fct_shipments`**: Creates a structured view of shipments details.

## scripts
- This folder is a place for Python scripts: I have created the first python file check_slo.py in order to check the execution time from the threads and to see if the models exceed a certain threshold of time.

## Project Structure
```
├── deltastore_dbt_transformation
│   ├── models
│   │   ├── staging.yml
│   │   ├── intermediate.yml
│   │   ├── marts.yml
│   │   ├── sources.yml
│   │
|   |── scripts  #python scripts
|   | 
│   ├── README.md
│   ├── dbt_project.yml
│   ├── macros
│   ├── tests
│   │   ├── generic
│   │   ├── singular
│   ├── snapshots
```

## Conclusion
 The `deltastore_dbt_transformation` folder organizes transformations, enforces constraints, and ensures data consistency across multiple sources. By structuring data into staging, intermediate, marts, and snapshots layers, this project showcases best practices in modern data engineering and analytics.

