import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

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
    "postgresql+pg8000",
    username="python",
    password="Trustno1@all",  # plain (unescaped) text
    host="localhost",
    database="Weather_v2",
)

engine = create_engine(url_object)

