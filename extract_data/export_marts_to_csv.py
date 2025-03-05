import os
import logging
import pyodbc
import pandas as pd
from dotenv import load_dotenv

# Load environment variables from 'config/.env'
load_dotenv('config/.env')

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# SQL Server connection details
conn_string = (
    f"DRIVER={os.getenv('SQL_DRIVER')};"
    f"SERVER={os.getenv('SQL_SERVER')};"
    f"DATABASE={os.getenv('SQL_DATABASE')};"
    f"UID={os.getenv('SQL_USERNAME')};"
    f"PWD={os.getenv('SQL_PASSWORD')}"
)

# Defining the prod schema 
SCHEMA = "analytics"  

# Defining export directory 
output_dir = "exported_marts"
os.makedirs(output_dir, exist_ok=True)

# List of final marts to export
final_marts = ["dim_customers", "fct_order_customers", "fct_order_items","fct_payments","fct_products","fct_reviews","fct_shipments"]

try:
    # Connect to SQL Server
    logging.info("Connecting to SQL Server...")
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    logging.info("✅ Connection successful!")

    # Export each mart as a CSV
    for mart in final_marts:
        table_name = f"{SCHEMA}.{mart}" if SCHEMA else mart
        query = f"SELECT * FROM {table_name}"
        
        logging.info(f"Extracting data from {table_name}...")
        df = pd.read_sql(query, conn)

        # Saving to CSV
        csv_path = os.path.join(output_dir, f"{mart}.csv")
        df.to_csv(csv_path, index=False)

        logging.info(f"✅ Exported {mart} to {csv_path}")

    # Closing connection
    conn.close()
    logging.info("✅ All marts exported successfully!")

except Exception as e:
    logging.error(f"❌ An error occurred: {e}")







