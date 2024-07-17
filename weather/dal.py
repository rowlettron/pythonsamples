import sqlalchemy as sa 
from sqlalchemy import create_engine
# import keyring as kr 
import pyodbc
import pymssql

#MSSQL
#connstr = f"mssql://python:Trustno1%40all@mylaptop/Weather_v2?driver=ODBC Driver 17 for SQL Server"

#PostgreSQL
#connstr = "postgresql://python:Trustno1%40all@localhost/dvdrental"

class dal:

    def __init__(self, dbType, pwd):
        self.dbType = dbType
        self.user = 'python'
        self.pwd = pwd
        self.db = 'Weather_v2'

    def getConnection(self):
        if self.dbType == 'MSSQL':
           self.host = 'mylaptop'
           self.port = '1433'

           connect_url = URL.create(
               'mssql',
               username = self.user,
               password = self.pwd,
               host = self.host,
               port = self.port,
               database = self.db,
               query = dict(driver='ODBC Driver 17 for SQL Server')
           )
        elif self.dbType == 'postgres':
             self.host = 'localhost'
             self.port = '5432'

             connect_url = URL.create(
                 'postgresql',
                 username = self.user,
                 password = self.pwd,
                 host = self.host,
                 database = self.db
             )
        engine = create_engine(connect_url) 
        return engine
    

    