import argparse
import pandas as pd 
import os
from sqlalchemy import create_engine 
import sqlalchemy as sa 
from sys import platform

import Weather as w
import warnings
import dal as d 

warnings.filterwarnings('ignore')

parser=argparse.ArgumentParser(description="sample argument parser")
parser.add_argument('zipcode')
parser.add_argument('dbType')
args=parser.parse_args()

zipcode = args.zipcode
dbType = args.dbType

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
    filePath = '/Users/ron/Containers/PostgreSQL/datashare/file.txt'
else:
    os_platform = "Windows"
    clearConsole()
    filePath = 'C:/Containers/PostgreSQL/datashare/file.txt'


# print(zipcode)
# secureObject = s.security()

apiUrl = os.environ['WEATHER_HOST']
key = os.environ['WEATHER_KEY']

headers = {
        'X-RapidAPI-Key': key,
        'X-RapidAPI-Host': apiUrl
        }

weatherData = w.Weather(zipcode)

retWeatherData = weatherData.getAPIResponse(apiUrl, headers, zipcode)

decodedRetWeatherData = retWeatherData.decode('utf-8')
with open(filePath, 'w') as f:
        f.write(decodedRetWeatherData)

conn = d.DataAccess()
engine = conn.getConnection(dbType)

if dbType == 'mssql':
    sp = "exec insert_payload_to_table'" + decodedRetWeatherData + "';"
else:
    sp = "call insert_payload_to_table('" + decodedRetWeatherData + "');"
    
conn.callStoredProcedure(engine, sp)
