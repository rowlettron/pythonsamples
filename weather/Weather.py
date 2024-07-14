import http.client
from pytz import country_names
import requests
import json
import datetime 
import pandas as pd
from json import loads, dumps
import pathlib

class Weather:

    def __init__(self, zipCode):
        self.zipCode = zipCode 
        self.location = ''

        print(self.zipCode)


    def getAPIResponse(self, apiUrl, headers, zipCode):
        self.apiUrl = apiUrl
        self.headers = headers
        self.zipCode = zipCode

        print('Getting Response')

        requestUrl = '/forecast.json?q=' + str(self.zipCode) + '&days=3'

        conn = http.client.HTTPSConnection(self.apiUrl)
        conn.request('GET', requestUrl, headers=headers)

        response = conn.getresponse()

        data = response.read()
        weatherobject = json.loads(data.decode('utf-8'))
    
        return data 

    def getLocation(self, data):
        self.data = data 

        print('Getting Location')
        df = pd.json_normalize(json.loads(self.data))

        dflocation = df[['location.name','location.region','location.country','location.lat','location.lon','location.tz_id','location.localtime_epoch','location.localtime']].copy()
        dflocation.rename(columns = {
            'location.name':'name',
            'location.region':'region',
            'location.country': 'country',
            'location.lat':'latitude',
            'location.lon':'longitude',
            'location.tz_id':'timezone',
            'location.localtime_epoch':'localtime_epoch',
            'location.localtime':'localtime'
            }, inplace = True)

        global location 
        location = dflocation['name'].values[0]

        return dflocation    

    def getCurrentConditions(self, data):
        self.data = data

        print('Getting Current Conditions')
        df = pd.json_normalize(json.loads(self.data))

        # dfCurrentConditions = pd.DataFrame()

        dfCurrentConditions = df[['location.name',
                                  'current.last_updated_epoch',
                                  'current.last_updated',
                                  'current.temp_c',
                                  'current.temp_f',
                                  'current.is_day',
                                  'current.condition.text',
                                  'current.wind_mph',
                                  'current.wind_kph',
                                  'current.wind_degree',
                                  'current.wind_dir',
                                  'current.pressure_mb',
                                  'current.pressure_in',
                                  'current.precip_mm',
                                  'current.precip_in',
                                  'current.humidity',
                                  'current.cloud',
                                  'current.feelslike_c',
                                  'current.feelslike_f',
                                  'current.windchill_c',
                                  'current.windchill_f',
                                  'current.heatindex_c',
                                  'current.heatindex_f',
                                  'current.dewpoint_c',
                                  'current.dewpoint_f',
                                  'current.vis_km',
                                  'current.vis_miles',
                                  'current.uv',
                                  'current.gust_mph',
                                  'current.gust_kph']].copy()

        dfCurrentConditions.rename(columns = {
            'location.name':'location',
            'current.last_updated_epoch':'last_updated_epoch',
            'current.last_updated':'last_updated',
            'current.temp_c':'temp_c',
            'current.temp_f':'temp_f',
            'current.is_day':'isday',
            'current.condition.text':'current_conditions',
            'current.wind_mph':'wind_mph',
            'current.wind_kph':'wind_kph',
            'current.wind_degree':'wind_degree',
            'current.wind_dir':'wind_direction',
            'current.pressure_mb':'pressure_mb',
            'current.pressure_in':'pressure_in',
            'current.precip_mm':'precip_mm',
            'current.precip_in':'precip_in',
            'current.humidity':'humidity',
            'current.cloud':'cloud',
            'current.feelslike_c':'feelslike_c',
            'current.feelslike_f':'feelslike_f',
            'current.windchill_c':'windchill_c',
            'current.windchill_f':'windchill_f',
            'current.heatindex_c':'heatindex_c',
            'current.heatindex_f':'heatindex_f',
            'current.dewpoint_c':'dewpoint_c',
            'current.dewpoint_f':'dewpoint_f',
            'current.vis_km':'vis_km',
            'current.vis_miles':'vis_miles',
            'current.uv':'uv',
            'current.gust_mph':'gust_mph',
            'current.gust_kph':'gust_kph'
            }, inplace = True)

        return dfCurrentConditions

    def getDailyForecast(self, data):
        self.data = data
        
        print('Getting Days Forecast')

        weatherobject = json.loads(data.decode("utf-8"))

        dfForecastDay = pd.DataFrame( columns = [
            'location_name',
            'date', 
            'date_epoch',
            'maxtemp_c',
            'maxtemp_f',
            'mintemp_c',
            'mintemp_f',
            'avgtemp_c',
            'avgtemp_f',
            'maxwind_mph',
            'maxwind_kph',
            'totalprecip_mm',
            'totalprecip_in',
            'totalsnow_cm',
            'avgvis_km',
            'avgvis_miles',
            'avghumidity',
            'daily_will_it_rain',
            'daily_chance_of_rain',
            'daily_will_it_snow',
            'daily_chance_of_snow',
            'conditions'
        ])
        
        for item in weatherobject['forecast']['forecastday']:
            
            forecast_day = item['day'] 
            
            location_name = location
            date = item['date']            
            date_epoch = item['date_epoch']
            
            maxtemp_c = forecast_day['maxtemp_c']
            maxtemp_f = forecast_day['maxtemp_f']
            mintemp_c = forecast_day['mintemp_c']
            mintemp_f = forecast_day['mintemp_f']
            avgtemp_c = forecast_day['avgtemp_c']
            avgtemp_f = forecast_day['avgtemp_f']
            maxwind_mph = forecast_day['maxwind_mph']
            maxwind_kph = forecast_day['maxwind_kph']
            totalprecip_mm = forecast_day['totalprecip_mm']
            totalprecip_in = forecast_day['totalprecip_in']
            totalsnow_cm = forecast_day['totalsnow_cm']
            avgvis_km = forecast_day['avgvis_km']
            avgvis_miles = forecast_day['avgvis_miles']
            avghumidity = forecast_day['avghumidity']
            daily_will_it_rain = forecast_day['daily_will_it_rain']
            daily_chance_of_rain = forecast_day['daily_chance_of_rain']
            daily_will_it_snow = forecast_day['daily_will_it_snow']
            daily_chance_of_snow = forecast_day['daily_chance_of_snow']
            conditions = forecast_day['condition']['text']
            
            dfForecastDay = dfForecastDay._append({
            'location_name':location_name,  
            'date':date,
            'date_epoch':date_epoch,
            'maxtemp_c':maxtemp_c,
            'maxtemp_f':maxtemp_f,
            'mintemp_c':mintemp_c,
            'mintemp_f':mintemp_f,
            'avgtemp_c':avgtemp_c,
            'avgtemp_f':avgtemp_f,
            'maxwind_mph':maxwind_mph,
            'maxwind_kph':maxwind_kph,
            'totalprecip_mm':totalprecip_mm,
            'totalprecip_in':totalprecip_in,
            'totalsnow_cm':totalsnow_cm,
            'avgvis_km':avgvis_km,
            'avgmis_miles':avgvis_miles,
            'avghumidity':avghumidity,
            'daily_will_it_rain':daily_will_it_rain,
            'daily_chance_of_rain':daily_chance_of_rain,
            'daily_will_it_snow':daily_will_it_snow,
            'daily_chance_of_snow':daily_chance_of_snow,
            'conditions':conditions}, ignore_index=True
            )

        return dfForecastDay

    def getHourlyForecast(self, data):
        self.data = data 

        print('Getting Hourly Forecast')
        
        location_name = location

        weatherobject = json.loads(data.decode("utf-8"))

        dfHourlyConditions = pd.DataFrame(columns = [
            'location',
            'forecast_date',
            'time','time_epoch',
            'temp_c',
            'temp_f',
            'is_day',
            'condition',
            'wind_mph',
            'wind_kph',
            'wind_degree',
            'wind_dir',
            'pressure_mb',
            'pressure_in',
            'precip_mm',
            'precip_in',
            'humidity',
            'cloud',
            'feelslike_c',
            'feelslike_f',
            'windchill_c',
            'windchill_f',
            'heatindex_c',
            'heatindex_f',
            'dewpoint_c',
            'dewpoint_f',
            'will_it_rain',
            'chance_of_rain',
            'will_it_snow',
            'chance_of_snow',
            'vis_km',
            'vis_miles',
            'gust_mph',
            'gust_kph',
            'uv'])

        for item in weatherobject['forecast']['forecastday']:
            forecast_day = item['date']

            forecastday = item 

            for hour in forecastday['hour']:
                # forecast_date = forecast_day
                currenthour = hour
                time = currenthour['time']
                time_epoch = currenthour['time_epoch']
                temp_c = currenthour['temp_c']
                temp_f = currenthour['temp_f']
                is_day = currenthour['is_day']
                condition = currenthour['condition']['text']
                wind_mph = currenthour['wind_mph']
                wind_kph = currenthour['wind_kph']
                wind_degree = currenthour['wind_degree']
                wind_dir = currenthour['wind_dir']
                pressure_mb = currenthour['pressure_mb']
                pressure_in = currenthour['pressure_in']
                precip_mm = currenthour['precip_mm']
                precip_in = currenthour['precip_in']
                humidity = currenthour['humidity']
                cloud = currenthour['cloud']
                feelslike_c = currenthour['feelslike_c']
                feelslike_f = currenthour['feelslike_f']
                windchill_c = currenthour['windchill_c']
                windchill_f = currenthour['windchill_f']
                heatindex_c = currenthour['heatindex_c']
                heatindex_f = currenthour['heatindex_f']
                dewpoint_c = currenthour['dewpoint_c']
                dewpoint_f = currenthour['dewpoint_f']
                will_it_rain = currenthour['will_it_rain']
                chance_of_rain = currenthour['chance_of_rain']
                will_it_snow = currenthour['will_it_snow']
                chance_of_snow = currenthour['chance_of_snow']
                vis_km = currenthour['vis_km']
                vis_miles = currenthour['vis_miles']
                gust_mph = currenthour['gust_mph']
                gust_kph = currenthour['gust_kph']
                uv = currenthour['uv']


                dfHourlyConditions = dfHourlyConditions._append({
                    'location': location_name, 
                    'forecast_date': forecast_day, 
                    'time':time,
                    'time_epoch':time_epoch,
                    'temp_c': temp_c,
                    'temp_f': temp_f,
                    'is_day': is_day,
                    'condition': condition,
                    'wind_mph': wind_mph,
                    'wind_kph': wind_kph,
                    'wind_degree': wind_degree,
                    'wind_dir': wind_dir,
                    'pressure_mb': pressure_mb,
                    'pressure_in': pressure_in,
                    'precip_mm': precip_mm,
                    'precip_in': precip_in,
                    'humidity': humidity,
                    'cloud': cloud,
                    'feelslike_c': feelslike_c,
                    'feelslike_f': feelslike_f,
                    'windchill_c': windchill_c,
                    'windchill_f': windchill_f,
                    'heatindex_c': heatindex_c,
                    'heatindex_f': heatindex_f,
                    'dewpoint_c': dewpoint_c,
                    'dewpoint_f': dewpoint_f,
                    'will_it_rain': will_it_rain,
                    'chance_of_rain': chance_of_rain,
                    'will_it_snow': will_it_snow,
                    'chance_of_snow': chance_of_snow,
                    'vis_km': vis_km,
                    'vis_miles': vis_miles,
                    'gust_mph': gust_mph,
                    'gust_kph': gust_kph,
                    'uv': uv
                }, ignore_index=True)


        return dfHourlyConditions

        def putWeatherJson(self, wj, engine):
            self.wj = wj
            self.engine = engine

        def putLocation(self, engine):
            self.engine = engine

        def putCurrentConditions(self, engine):
            self.engine = engine
            

        def putDailyForecast(self, engine):
            self.engine = engine    

        def putHourlyForecast(self, engine):
            self.engine = engine