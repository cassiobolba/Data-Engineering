import pytest

#fixtures are codes or mocks you run before your test
@pytest.fixture
def numbers():
    return [10,15,20]

@pytest.mark.one
def test_one(numbers):
    assert numbers[0] == 10

@pytest.mark.two
def test_two(numbers):
    assert numbers[1] == 10
