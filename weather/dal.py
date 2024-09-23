import sqlalchemy as sa 
from sqlalchemy import create_engine
from sqlalchemy import URL
import os
import warnings
warnings.filterwarnings('ignore')

#MSSQL
#connstr = f"mssql://python:Trustno1%40all@mylaptop/Weather_v2?driver=ODBC Driver 17 for SQL Server"

#PostgreSQL
#connstr = "postgresql://python:Trustno1%40all@localhost/dvdrental"

class DataAccess:

    def __init__(self):
        #self.dbType = dbType
        self.user = os.environ['WEATHER_LOGIN']
        self.pwd = os.environ['WEATHER_PWD']
        self.db = 'Weather_v2'

    def printHelp(self):
        print('Help')
        return 'Help'
    
    def getConnection(self, dbType):

        self.dbType = dbType
        if self.dbType == 'mssql':
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
        elif self.dbType == 'mysql':
            self.host = '127.0.0.1'
            self.port = '3306'

            connect_url = URL.create(
                'mysql',
                username=self.user,
                password=self.pwd,
                host=self.host,
                port=self.port, 
                database=self.db
            )

        engine = create_engine(connect_url) 
        return engine
    
    def callStoredProcedure(self, engine, sql):
        if self.dbType == 'postgres':
            # print(sql)
            conn = engine.raw_connection()
            cursor = conn.cursor()
            cursor.execute(sql)
            cursor.close()
            conn.commit()
            conn.close()
        elif self.dbType == 'mssql':
            # print(sql)
            conn = engine.raw_connection()
            cursor = conn.cursor()
            cursor.execute(sql)
            cursor.close()
            conn.commit()
            conn.close()
        elif self.dbType == 'mysql':
            # print(sql)
            conn = engine.raw_connection()
            cursor = conn.cursor()
            cursor.execute(sql)
            cursor.close()
            conn.commit()
            conn.close()







    