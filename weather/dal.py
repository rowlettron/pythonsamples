from sqlalchemy import create_engine

def getPGConnection(user, pwd, host, port, db):
    connection_str = f'postgresql://{user}:{pwd}@{host}:{port}/{db}'
    engine = create_engine(connection_str)
    return engine
    

class dal:

    def __init__(self, pwd):
        self.pwd = pwd 
        self.user = 'python'
        self.host = 'localhost'
        self.port = '5432'
        self.db = 'Weather_v2'
       
    def getPGConnection(self):
        connection_str = f'postgresql://{self.user}:{self.pwd}@{self.host}:{self.port}/{self.db}'
        engine = create_engine(connection_str)
        return engine
    

    