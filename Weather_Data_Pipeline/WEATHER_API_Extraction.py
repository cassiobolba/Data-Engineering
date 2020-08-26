
import pandas as pd
import requests
import numpy as np

city = "London"

api_key = "Type you key here"

url = "http://api.openweathermap.org/data/2.5/weather?q="+ city +"&appid="+ api_key

json_data = requests.get(url).json()

# checking the json
#print(json_data)


# Create an empty dataframe to store values from JSON to 
df_all_current_weather = pd.DataFrame()

# Create empty lists to store the JSON Data
current_weather_id = []
current_time = []
own_city_id = []
city = []
latitude = []
longitude = []
country = []
timezone = []
sunrise = []
sunset = []
temperature = []
temperature_feel = []
temperature_min = []
temperature_max = []
pressure = []
humidity = []
main = []
main_description = []
clouds = []
wind_speed = []
wind_degree = []
visibility = []


# Add JSON Data to the lists
prediction_num = 1
current_weather_id.append(prediction_num)
current_time.append(pd.Timestamp.now())

# testing each column if it came in the json, if not create a nan column. This is to avoid errors when json comes incomplete
# and also to have all columns filled with values, to make final cvs's append easier
try:
    own_city_id.append(json_data['id'])
except:
    own_city_id = [np.nan]
    
try:    
    city.append(json_data['name'])
except:
    city = [np.nan]
    
try:
    latitude.append(json_data['coord']['lat'])
except:
    latitude = [np.nan]
    
try:
    longitude.append(json_data['coord']['lon'])
except:
    longitude = [np.nan]
    
try:
    country.append(json_data['sys']['country'])
except:
    country = [np.nan]
    
    
if json_data['timezone'] >0 :
    timezone.append(("+" + str((json_data['timezone'])/3600)))
else:
    timezone.append(((json_data['timezone'])/3600))

try:
    sunrise.append(json_data['sys']['sunrise'])
except:
    sunrise = [np.nan]
    
try:
    sunset.append(json_data['sys']['sunset'])
except:
    sunset = [np.nan]
    
try:
    temperature.append(json_data['main']['temp'])
except:
    temperature = [np.nan]
    
try:
    temperature_feel.append(json_data['main']['feels_like'])
except:
    temperature_feel = [np.nan]
    
try:
    temperature_min.append(json_data['main']['temp_min'])
except:
    temperature_min = [np.nan]
    
try:
    temperature_max.append(json_data['main']['temp_max'])
except:
    temperature_max = [np.nan]
    
try:
    pressure.append(json_data['main']['pressure'])
except:
    pressure = [np.nan]
    
try:
    humidity.append(json_data['main']['humidity'])
except:
    humidity = [np.nan]
    
try:
    main.append(json_data['weather'][0]['main'])
except:
    main = [np.nan]
    
try:
    main_description.append(json_data['weather'][0]['description'])
except:
    main_description = [np.nan]
    
try:
    clouds.append(json_data['clouds']['all'])
except:
    clouds = [np.nan]
    
try:
    wind_speed.append(json_data['wind']['speed'])
except:
    wind_speed = [np.nan]
    
try:
    wind_degree.append(json_data['wind']['deg'])   
except:
    wind_degree =  [np.nan]

try:
    visibility.append(json_data['visibility'])
except:
    visibility =  [np.nan]


# Write Lists to DataFrame
df_all_current_weather['current_weather_id'] = current_weather_id
df_all_current_weather['current_time'] = current_time
df_all_current_weather['own_city_id'] = own_city_id
df_all_current_weather['city'] = city
df_all_current_weather['latitude'] = latitude
df_all_current_weather['longitude'] = longitude
df_all_current_weather['country'] = country
df_all_current_weather['timezone'] = timezone
df_all_current_weather['sunrise'] = sunrise
df_all_current_weather['sunset'] = sunset
df_all_current_weather['temperature'] = temperature
df_all_current_weather['temperature_feel'] = temperature_feel
df_all_current_weather['temperature_min'] = temperature_min
df_all_current_weather['temperature_max'] = temperature_max
df_all_current_weather['pressure'] = pressure
df_all_current_weather['humidity'] = humidity
df_all_current_weather['main'] = main
df_all_current_weather['main_description'] = main_description
df_all_current_weather['clouds'] = clouds
df_all_current_weather['wind_speed'] = wind_speed
df_all_current_weather['wind_degree'] = wind_degree
#df_all_current_weather['visibility'] = visibility


# check the dataframe
#df_all_current_weather.head()

# Create a timestamp to add a dinamy file name using the current data
today = pd.to_datetime('now')

curr_date = str(pd.to_datetime('today').date())

curr_time = str(pd.to_datetime('today').time())
curr_time = curr_time[0:8].replace(':','-')

curr_date_time = str.lstrip(str.rstrip(curr_date+'_'+curr_time))

file_name = 'weather_data_'+str(city[0])+'_'+curr_date_time+'.csv'
file_name


# write to csv
path = r'C:\Users\cassi\Google Drive\Weather_Pipeline\data\ '
file_name = 'weather_data'+curr_date_time+'.csv'
teste = str(path+file_name)
teste
df_all_current_weather.to_csv(path + file_name ,encoding='utf-8' )
