from dotenv import load_dotenv
import psycopg2
import os

load_dotenv()

conn = psycopg2.connect(dbname="postgres", user="postgres", password=os.environ["POSTGRES_PASSWORD"])
cur = conn.cursor()

# run script 01_create_messung.sql

cur.execute(open("01_create_messung.sql", "r").read())

conn.commit()

cur.execute(open("02_create_staging.sql", "r").read())

conn.commit()

cur.execute(open("11_load_staging.sql", "r").read())

conn.commit()

cur.execute(open("03_create_core.sql", "r").read())

conn.commit()

cur.execute(open("04_create_mart.sql", "r").read())

conn.commit()
