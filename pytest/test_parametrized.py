import pytest

# pass multiple paramenter to a test
@pytest.mark.parametrize("x,y,z",[(10,20,200),(10,10,200)])
def test_one(x,y,z):
    assert x * y == z