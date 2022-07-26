import pytest

def my_func(x):
    return x + 5

def test_func():
    assert my_func(3) == 8

# to run the test go to consoloe -> pytest first_test.py
