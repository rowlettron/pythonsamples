import argparse
import psycopg2 
import pandas as pd 
from sqlalchemy import create_engine 

import Weather as w

parser=argparse.ArgumentParser(description="sample argument parser")
parser.add_argument('zipcode')
args=parser.parse_args()

zipcode = args.zipcode
# print(zipcode)

apiUrl = 'weatherapi-com.p.rapidapi.com'

headers = {
        'X-RapidAPI-Key': "958fc6f0cdmsh20a1f73f46e70d6p1757c6jsn5755135ea290",
        'X-RapidAPI-Host': "weatherapi-com.p.rapidapi.com"
        }


weatherData = w.Weather(zipcode)

retWeatherData = weatherData.getAPIResponse(apiUrl, headers, zipcode)

print(retWeatherData)

dfCurrentLocation = weatherData.getLocation(retWeatherData)
dfCurrentWeatherConditions = weatherData.getCurrentConditions(retWeatherData)
dfDailyForecast = weatherData.getDailyForecast(retWeatherData)
dfHourlyForecast = weatherData.getHourlyForecast(retWeatherData)

print(dfCurrentLocation.head)
print(dfCurrentWeatherConditions.head)
print(dfDailyForecast.head)
print(dfHourlyForecast.head)

# establish connections 
#conn_string = 'postgres://postgres:pass@127.0.0.1/Weather_v2'
#conn_string = "host='localhost' dbname='Weather_v2' user='python' password='Trustno1@all'"
#  
#db = create_engine(conn_string) 
#conn = db.connect() 
#
#print(conn)

