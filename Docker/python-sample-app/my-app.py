import requests

def get_weather_info():
    
    city = "Porto Alegre"
    
    api_key = "868a26a88dcad371f4205a319f26be8c"

    url = "http://api.openweathermap.org/data/2.5/weather?q="+ str(city) +"&appid="+ api_key

    json_data = requests.get(url).json()
    
    return print(f"Current Temperature for {str(city)} is {json_data['main']['temp']/10}")


if __name__ == "__main__":

    get_weather_info()