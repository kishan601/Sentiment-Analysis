import pytest
from src.main import app

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client

def test_predict_happy_path(client):
    """Test the happy path for the /predict endpoint."""
    response = client.post("/predict", json={"text": "I love this product"})
    assert response.status_code == 200
    assert "label" in response.json
    assert "score" in response.json
    assert "model_name" in response.json

def test_predict_edge_case(client):
    """Test the edge case of an empty string for the /predict endpoint."""
    response = client.post("/predict", json={"text": ""})
    assert response.status_code == 422
    assert "error" in response.json

def test_predict_error_handling(client):
    """Test the error handling for a missing 'text' field in the request body."""
    response = client.post("/predict", json={})
    assert response.status_code == 422
    assert "error" in response.json
