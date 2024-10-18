import sqlalchemy as sa
from sqlalchemy import create_engine
from sqlalchemy.engine import URL
import pyodbc
import pandas as pd 
import warnings
warnings.filterwarnings('ignore')

######## Engine Configurations #############
#Postgresql
# default
#engine = create_engine("postgresql://scott:tiger@localhost/mydatabase")

# psycopg2
# engine = create_engine("postgresql+psycopg2://scott:tiger@localhost/mydatabase")

# pg8000
# engine = create_engine("postgresql+pg8000://scott:tiger@localhost/mydatabase")
#
#MySQL
# default
# engine = create_engine("mysql://scott:tiger@localhost/foo")

# mysqlclient (a maintained fork of MySQL-Python)
# engine = create_engine("mysql+mysqldb://scott:tiger@localhost/foo")

# PyMySQL
# engine = create_engine("mysql+pymysql://scott:tiger@localhost/foo")
#
#MSSQL
# pyodbc
# engine = create_engine("mssql+pyodbc://scott:tiger@mydsn")

# pymssql
# engine = create_engine("mssql+pymssql://scott:tiger@hostname:port/dbname")
######## Engine Configurations #############

url_object = URL.create(
    "postgresql",
    username="python",
    password="Trustno1@all",  # plain (unescaped) text
    host="localhost",
    database="dvdrental",
)

engine = create_engine(url_object)
# connection = engine.raw_connection


# sql_df = pd.read_sql("select * from location",
#     con=engine)

# print(sql_df)

title = '''Freaky Pocus'''
print(title)

# sql = f"select * from public.get_film_rentals('{title}')"
sql = f"select * from public.get_film_rentals()"
with engine.begin() as conn:
    df1 = pd.read_sql(sa.text(sql), conn)
print(df1)



# try: 
#     with engine.connect() as connection_str:
#         print('Successfully connected to the PostgreSQL database')
# except Exception as ex:
#     print('Failed to connect: {ex}')

credentials = {
    'username': 'scott',
    'password': 'tiger',
    'host': 'myhost',
    'database': 'databasename',
    'port': '1560'}
    
connect_url = URL.create(
    'mssql',
    username=credentials['username'],
    password=credentials['password'],
    host=credentials['host'],
    port=credentials['port'],
    database=credentials['database'],
    query=dict(driver='ODBC Driver 17 for SQL Server'))

server = 'mylaptop'
database = 'Weather_v2'
connection_str = f'DRIVER=ODBC Driver 17 for SQL Server;SERVER={server};DATABASE={database};Trusted_Connection=yes;TrustServerCertificate=yes;'

connection = pyodbc.connect(connection_str)
query = "SELECT * FROM location"
df = pd.read_sql(query, connection)
print(df)


#Trustno1%40all
#import sqlalchemy as sa
#from sqlalchemy import create_engine
#import pandas as pd
#constr = "postgresql://python:Trustno1%40all@localhost/dvdrental"
#engine = create_engine(constr)