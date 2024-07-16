import sqlalchemy as sa 
from sqlalchemy import create_engine
import keyring as kr 

class dal(dbType):

    def __init__(self, dbType):
        self.dbType = dbType
        self.user = 'python'
        self.pwd = get_password('weather',self.user)
        self.db = 'Weather_v2'

        if self.dbType = 'MSSQL':
            self.host = 'mylaptop'
            self.port = '1433'
        elif self.dbType = 'postgres':
            self.host = 'localhost'
            self.port = '5432'

    def getPGConnection(self):
        connection_str = f'postgresql://{self.user}:{self.pwd}@{self.host}:{self.port}/{self.db}'
        engine = create_engine(connection_str)
        return engine
    

    