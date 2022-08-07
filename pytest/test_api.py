from urllib import response
import pytest
import requests
import json

def test_valid_login():
    url = "https://reqres.in/api/login"
    data = {'email':'eve.holt@reqres.in','password':'cityslicka'}
    response = requests.get(url,data=data)
    token = json.loads(response.text)
    print(token)
    assert response.status_code == 200
    assert token["page"] == 1
