import requests
import pytest


@pytest.fixture
def service_date():
    return "20220901"


@pytest.fixture
def boarding_time():
    return "2022-09-01T10:00:00+00:00"


@pytest.fixture
def ticketing_trip_id():
    return "direct:169396293:1:10"


@pytest.fixture
def from_ticketing_stop_time_id():
    return "88-1"


@pytest.fixture
def to_ticketing_stop_time_id():
    return "94-10"


@pytest.fixture
def generate_url_to_test(
                        service_date
                        ,boarding_time
                        ,ticketing_trip_id
                        ,from_ticketing_stop_time_id
                        ,to_ticketing_stop_time_id
                        ):
    # hit this enpoint
    url = 'gtfs-dev.flix.tech/ticketing/web-url?' \
        f'service_date=["{service_date}"]&' \
        f'boarding_time=["{boarding_time}"]&' \
        f'ticketing_trip_id=["{ticketing_trip_id}"]&' \
        f'from_ticketing_stop_time_id=["{from_ticketing_stop_time_id}"]&' \
        f'to_ticketing_stop_time_id=["{to_ticketing_stop_time_id}"]'
    return url


@pytest.fixture
def generate_expected_url( service_date
                    #,boarding_time
                    ,ticketing_trip_id
                    ,from_ticketing_stop_time_id
                    ,to_ticketing_stop_time_id
                    ):

    departureCity = from_ticketing_stop_time_id.split("-")[0]
    departureStation = from_ticketing_stop_time_id.split("-")[1]
    arrivalCity = to_ticketing_stop_time_id.split("-")[0]
    arrivalStation = to_ticketing_stop_time_id.split("-")[1]
    rideDate = '.'.join([service_date[6:],service_date[4:6],service_date[:4]])
    uid = ticketing_trip_id.replace(":","%3A")

    expected_url = 'https://shop.global.flixbus.com/search?' \
        f'departureCity={departureCity}&' \
        f'departureStation={departureStation}&' \
        f'arrivalCity={arrivalCity}&' \
        f'arrivalStation={arrivalStation}&' \
        f'rideDate={rideDate}&' \
        'adult=1&' \
        'children=0&' \
        'bike_slot=0&' \
        'currency=EUR&' \
        f'uid={uid}&' \
        'reserve=1'

    return expected_url


@pytest.mark.gtfs
def test_func(generate_expected_url,generate_url_to_test):

    # tigger lambda with generate_url_to_test an fetch response
    # response = requests.get(generate_url_to_test).json
    response = {
        "statusCode": 302,
        "headers": {
            "Location": f"https://shop.global.flixbus.com/search?departureCity=88&departureStation=1&arrivalCity=94&arrivalStation=10&rideDate=01.09.2022&adult=1&children=0&bike_slot=0&currency=EUR&uid=direct%3A169396293%3A1%3A10&reserve=1"
        }
    }

    assert response["statusCode"] == 302
    assert response["headers"]["Location"] == generate_expected_url
