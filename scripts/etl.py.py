import pandas as pd
from sqlalchemy import create_engine
import os
"""
Superstore ETL Pipeline
=======================
Reads raw Superstore Excel data, normalizes it into 7 relational tables,
and loads them into a PostgreSQL database.

Tables created: products, customers, geography, orders, 
                order_items, returns, people

Author: Rowan Eissa
"""
# ── Configuration ──────────────────────────────────────────
BASE_DIR = Path().resolve().parent
FILE_PATH = BASE_DIR / "data" / "raw" / "Sample - Superstore.xlsx"
load_dotenv()
DB_URL = os.getenv("DB_URL")

# ── Load raw data ───────────────────────────────────────────
df = pd.read_excel(FILE_PATH, sheet_name='Orders', engine='openpyxl')
returns_df = pd.read_excel(FILE_PATH, sheet_name='Returns', engine='openpyxl')
people_df = pd.read_excel(FILE_PATH, sheet_name='People', engine='openpyxl')

# ── Normalize into tables ────────────────────────────────────
products_table = df[['Product ID', 'Product Name', 'Category', 'Sub-Category']].drop_duplicates().reset_index(drop=True)
customers_table = df[['Customer ID', 'Customer Name', 'Segment']].drop_duplicates().reset_index(drop=True)
geography_table = df[['Postal Code', 'City', 'State', 'Region', 'Country']].drop_duplicates().reset_index(drop=True)
orders_table = df[['Order ID', 'Order Date', 'Ship Date', 'Ship Mode', 'Customer ID', 'Postal Code']].drop_duplicates().reset_index(drop=True)
order_items_table = df[['Order ID', 'Product ID', 'Sales', 'Quantity', 'Discount', 'Profit']].drop_duplicates().reset_index(drop=True)

# ── Verify shapes ────────────────────────────────────────────
print("Products:   ", products_table.shape)
print("Customers:  ", customers_table.shape)
print("Geography:  ", geography_table.shape)
print("Orders:     ", orders_table.shape)
print("Order Items:", order_items_table.shape)
print("Returns:    ", returns_df.shape)
print("People:     ", people_df.shape)

# ── Load into PostgreSQL ─────────────────────────────────────
engine = create_engine(DB_URL)

products_table.to_sql('products', engine, if_exists='replace', index=False)
customers_table.to_sql('customers', engine, if_exists='replace', index=False)
geography_table.to_sql('geography', engine, if_exists='replace', index=False)
orders_table.to_sql('orders', engine, if_exists='replace', index=False)
order_items_table.to_sql('order_items', engine, if_exists='replace', index=False)
returns_df.to_sql('returns', engine, if_exists='replace', index=False)
people_df.to_sql('people', engine, if_exists='replace', index=False)

print("\nAll 7 tables loaded into PostgreSQL successfully!")