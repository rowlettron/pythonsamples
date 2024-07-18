import dal as d
import sqlalchemy as sa 
import pandas as pd
import os

mssql = 'MSSQL'
postgres = 'postgres'
pwd = os.environ['WEATHER_PWD']

print(pwd)

conn = d.DataAccess()
engine = conn.getConnection(dbType = mssql)

# print(msengine)

sql = f"select * from location"
with engine.begin() as conn:
    df1 = pd.read_sql(sa.text(sql), conn)
print(df1)

print('***************************************************************************************************************************************************')

pconn = d.DataAccess()
engine = pconn.getConnection(dbType = postgres)

# print(msengine)

sql = f"select * from location"
with engine.begin() as conn:
    df1 = pd.read_sql(sa.text(sql), conn)
print(df1)