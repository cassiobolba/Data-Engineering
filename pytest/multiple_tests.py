import pytest


@pytest.mark.one
def test_method1():
    x = 5
    y = 10
    assert x == y


@pytest.mark.two
def test_method2():
    x = 5
    y = 10
    assert x+5 == y

# to run each test go to console -> py.test multiple_tests.py -m one -v
