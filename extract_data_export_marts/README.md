# Data Extraction Process

## Overview
The **Extract Data** module in Deltastore is responsible for extracting data from an external API and storing it in a SQL Server database. This process ensures that raw data is collected, structured, and made available for further transformations and analytics.

## Dependencies
- **Python Libraries:**
  - `requests`: For making HTTP requests to the API.
  - `pyodbc`: For connecting and interacting with SQL Server.
  - `os`: To manage environment variables.
  - `logging`: For logging system events and errors.
  - `dotenv`: To load environment variables from a `.env` file.

## Environment Setup
Before running the script, ensure that you have a `.env` file located in `config/.env` containing the required database credentials:

```
SQL_DRIVER={your_sql_driver}
SQL_SERVER={your_sql_server}
SQL_DATABASE={your_database_name}
SQL_USERNAME={your_sql_username}
SQL_PASSWORD={your_sql_password}
```

## Key Components

### 1. **Establishing Database Connection**
The script initializes a connection to SQL Server using credentials stored in environment variables.

```python
conn_string = (
    f"DRIVER={os.getenv('SQL_DRIVER')};"
    f"SERVER={os.getenv('SQL_SERVER')};"
    f"DATABASE={os.getenv('SQL_DATABASE')};"
    f"UID={os.getenv('SQL_USERNAME')};"
    f"PWD={os.getenv('SQL_PASSWORD')}"
)
```

### 2. **API Data Sources**
Data is extracted from the [FakeStore API](https://fakestoreapi.com), which provides dummy e-commerce data for:
- `products`
- `users`
- `carts`

### 3. **Fetching Data from API**
The `fetch_data()` function requests data from the API and handles errors:

```python
def fetch_data(endpoint):
    try:
        response = requests.get(endpoint)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching data from {endpoint}: {e}")
        return None
```

### 4. **Storing Data in SQL Server**
The `store_data()` function inserts extracted data into predefined tables in the `raw` schema. Before inserting, it ensures that the table exists.

Example table creation for `products`:

```sql
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='products' AND xtype='U')
CREATE TABLE raw.products (
    id INT PRIMARY KEY,
    title NVARCHAR(255),
    price FLOAT,
    description NVARCHAR(MAX),
    category NVARCHAR(255),
    image NVARCHAR(MAX),
    rating_rate FLOAT,
    rating_count INT
);
```
```

### 5. **Executing the Pipeline**
The `main()` function orchestrates the data extraction and storage process:

- Establishes a database connection.
- Iterates through the API endpoints, fetching and storing data.
- Logs success or failure messages.
- Closes the database connection after execution.

```python
def main():
    try:
        conn = pyodbc.connect(conn_string)
        logging.info("Connected to SQL Server successfully.")

        for table, endpoint in API_ENDPOINTS.items():
            logging.info(f"Fetching data from {table}...")
            data = fetch_data(endpoint)
            store_data(data, table, conn)

        conn.close()
        logging.info("Data extraction and storage completed successfully!")
    except Exception as e:
        logging.error(f"Error connecting to SQL Server: {e}")
```

## Execution
Run the script using:
```bash
python extract_data.py
```

## Logging & Error Handling
- Logs are written to standard output using `logging`.
- Errors in fetching data or SQL insertion are logged with detailed messages.


# Export Marts Module Documentation

## Overview
The **Export Marts** module is responsible for extracting transformed marts from the SQL Server database and exporting them into CSV files. These exported files are used for reporting and visualization in Tableau Desktop.

## Features
- Establishes a connection to SQL Server.
- Extracts data from predefined marts in the `analytics` schema.
- Saves the extracted data as CSV files in the `exported_marts` directory.
- Logs each step of the process to track progress and errors.


## Directory Structure
```
Deltastore/
│── export_data_export_marts/
│   │── export_marts.py
│   │── config/
│   │   ├── .env
│   │── exported_marts_to_csv.py/
```

## Code Breakdown

### 1. Load Environment Variables
The script loads database credentials from the `.env` file to establish a secure connection to SQL Server.

### 2. Configure Logging
A logging system is set up to track execution status and errors.

### 3. Define Export Directory
The script ensures the `exported_marts` directory exists, where all exported CSVs will be stored.

### 4. Define Marts to Export
A predefined list of marts is specified, which includes:
- `dim_customers`
- `fct_order_customers`
- `fct_order_items`
- `fct_payments`
- `fct_products`
- `fct_reviews`
- `fct_shipments`

### 5. Connect to SQL Server
The script establishes a connection using `pyodbc` and retrieves data for each mart.

### 6. Export Data to CSV
For each mart:
- A SQL `SELECT *` query extracts data from the `analytics` schema.
- The retrieved data is converted into a Pandas DataFrame.
- The DataFrame is saved as a CSV file in the `exported_marts` directory.

### 7. Error Handling
If any errors occur during the extraction or export process, they are logged and the script exits gracefully.

## Usage
```sh
python export_marts.py
```