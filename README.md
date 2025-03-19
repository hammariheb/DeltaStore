# E-Commerce Data Pipeline & Analytics Project

## Overview
This project is an end-to-end data pipeline designed to extract, transform, and analyze e-commerce data from multiple sources. The pipeline integrates data from a **new e-commerce store** (via API) and an **old store's database**, processes it using **dbt**, and loads the final marts into **Azure SQL** for better performance. Automated **CI/CD** workflows ensure quality and reliability in the transformation process, and final insights are visualized through **Tableau dashboards**.

### Project Workflow (Overview Piepline)

![Full Project Overview](<pictures/full project pipeline.png>)

## Directory Structure & Purpose
Each folder in the directory serves a specific purpose in the data pipeline. Detailed documentation is available within each folder.

### 1. **extract_data**
   - Extracts raw data from the new store via API.
   - Loads extracted data into the **DeltaStore** database.
   
### 2. **deltastore_dbt_transformation**
   - Transforms raw data from both the old and new stores.
   - Creates **final marts** using dbt.
   - Includes **staging, intermediate, and marts**.

### 3. **database_migration_to_azure_sql**
   - Migrates the database from **SQL Server** to **Azure SQL** for better scalability and performance.
   
   ![MIGRATION TO AZURE](pictures/migration_capture.png)

### 4. **Slim_CI__pipeline**
   - Implements slim **CI** with **GitHub Actions**:
     - Runs tests on **every pull request** in `deltastore_dbt_transforamtion`  directory.
     - Executes **state-modified+ runs** to optimize dbt transformations.

### 5. **CD dbt_airflow_automation**
   - Uses **Docker** to build a **custom dbt-Airflow image**.
   - Deploys **Airflow DAGs** to automate the dbt build process in the **PROD environment**, scheduled for **2 AM daily**.
    ![AIRFLOW DAG](<deltastore_airflow/screenshots/airflow_dag_jobs.png>)

### 6. **UML_modelisation_overview**
   - Provides a UML model of the final marts before reporting.

   ![UML modelisation](<pictures/UML model.png>)

### 7. **deltastore_tableau_dashboard**
   - Uses **final marts** to create **three Tableau dashboards**:
     - **Customer Analysis**
     - **Product & Pricing Optimization**
     - **Order Fulfillment & Logistics**
   
   ![CUSTUMER ANALYSIS](<deltastore_tableau_dashboards/screenshots/customer_analysis.png>)

   ![PRODUCT & PRICING OPTIMISATION](<deltastore_tableau_dashboards/screenshots/product_and_pricing_optimisation.png>)
   
   ![ORDER FULFILLMENT & LOGISTICS](<deltastore_tableau_dashboards/screenshots/order_fulfillment_and_logistics.png>)

---

## Detailed Documentation
Each folder contains a dedicated README file explaining its purpose, structure, and implementation details. Refer to those for more in-depth information on specific components.

---

This project implements an end-to-end **modern data stack** with **automated workflows** for a scalable, efficient, and insightful data analytics pipeline.

