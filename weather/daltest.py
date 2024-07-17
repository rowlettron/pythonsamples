import dal 
import sqlalchemy as sa 
import keyring

mssql = 'MSSQL'
postgres = 'postgres'
pwd = keyring.get_password('weather','python')

print(pwd)


msconnection = dal(mssql, pwd)
msengine = dal.getConnection()

sql = f"select * from public.get_film_rentals()"
with msengine.begin() as conn:
    df1 = pd.read_sql(sa.text(sql), conn)
print(df1)

