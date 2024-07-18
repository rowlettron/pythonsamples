import dal as d
import sqlalchemy as sa 
import pandas as pd
import os
from sys import platform
def clearConsole():
    if os.name in ('nt','dos'):
        command = 'cls'
    else:
        command = 'clear'

    os.system(command)

# print(platform.system)

if platform == "darwin":
    os_platform = "Mac"
    clearConsole()
else:
    os_platform = "Windows"
    clearConsole()


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