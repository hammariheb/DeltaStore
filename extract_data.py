import requests
import pyodbc
import os
import logging
from dotenv import load_dotenv

# Load environment variables
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

# API endpoints to fetch data from
API_ENDPOINTS = {
    "products": "https://fakestoreapi.com/products",
    "users": "https://fakestoreapi.com/users",
    "carts": "https://fakestoreapi.com/carts"
}

def fetch_data(endpoint):
    """Fetch data from FakeStore API"""
    try:
        response = requests.get(endpoint)
        response.raise_for_status()  # Raise an error for bad status codes
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"❌ Error fetching data from {endpoint}: {e}")
        return None

def store_data(data, table_name, conn):
    """Store extracted data into SQL Server (raw schema)"""
    if not data:
        logging.warning(f"⚠️ No data to insert into {table_name}. Skipping...")
        return

    cursor = conn.cursor()

    # Dynamically create a table (check if it exists first)
    create_table_query = {
        "products": """
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
        """,
        "users": """
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
            CREATE TABLE raw.users (
                id INT PRIMARY KEY,
                email NVARCHAR(255),
                username NVARCHAR(255),
                password NVARCHAR(255),
                firstname NVARCHAR(255),
                lastname NVARCHAR(255),
                city NVARCHAR(255),
                street NVARCHAR(255),
                number INT,
                zipcode NVARCHAR(50),
                lat FLOAT,
                long FLOAT,
                phone NVARCHAR(50)
            );
        """,
        "carts": """
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='carts' AND xtype='U')
            CREATE TABLE raw.carts (
                id INT PRIMARY KEY,
                userId INT,
                date DATE
            );
        """
    }

    # Execute CREATE TABLE query
    cursor.execute(create_table_query[table_name])

    # Insert data
    for item in data:
        if table_name == "products":
            cursor.execute("""
                INSERT INTO raw.products (id, title, price, description, category, image, rating_rate, rating_count)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, item["id"], item["title"], item["price"], item["description"],
               item["category"], item["image"], item["rating"]["rate"], item["rating"]["count"])
        
        elif table_name == "users":
            cursor.execute("""
                INSERT INTO raw.users (id, email, username, password, firstname, lastname, city, street, number, zipcode, lat, long, phone)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, item["id"], item["email"], item["username"], item["password"],
               item["name"]["firstname"], item["name"]["lastname"], item["address"]["city"],
               item["address"]["street"], item["address"]["number"], item["address"]["zipcode"],
               item["address"]["geolocation"]["lat"], item["address"]["geolocation"]["long"],
               item["phone"])

        elif table_name == "carts":
            cursor.execute("""
                INSERT INTO raw.carts (id, userId, date)
                VALUES (?, ?, ?)
            """, item["id"], item["userId"], item["date"])

    # Commit changes
    conn.commit()
    logging.info(f"✅ Successfully inserted {len(data)} records into raw.{table_name}")

def main():
    """Main function to extract and store data"""
    try:
        conn = pyodbc.connect(conn_string)
        logging.info("✅ Connected to SQL Server successfully.")

        for table, endpoint in API_ENDPOINTS.items():
            logging.info(f"Fetching data from {table}...")
            data = fetch_data(endpoint)
            store_data(data, table, conn)

        conn.close()
        logging.info("🚀 Data extraction and storage completed successfully!")

    except Exception as e:
        logging.error(f"❌ Error connecting to SQL Server: {e}")

if __name__ == "__main__":
    main()
