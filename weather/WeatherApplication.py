import argparse
import psycopg2 
import pandas as pd 
import os
from sqlalchemy import create_engine 

import Weather as w
import security as s
import dal as d

parser=argparse.ArgumentParser(description="sample argument parser")
parser.add_argument('zipcode')
parser.add_argument('dbType')
args=parser.parse_args()

zipcode = args.zipcode
dbType = args.dbType

# print(zipcode)
# secureObject = s.security()

apiUrl = os.environ['WEATHER_HOST']
key = os.environ['WEATHER_KEY']
#host = os.environ['WEATHER_HOST']
# pwd = secureObject.getPassword()
conn = d.dal(dbType)




# headers = {
#         'X-RapidAPI-Key': "958fc6f0cdmsh20a1f73f46e70d6p1757c6jsn5755135ea290",
#         'X-RapidAPI-Host': "weatherapi-com.p.rapidapi.com"
#         }
headers = {
        'X-RapidAPI-Key': key,
        'X-RapidAPI-Host': apiUrl
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


