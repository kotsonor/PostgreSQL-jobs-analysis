from fastapi.testclient import TestClient
from unittest.mock import MagicMock
import sys
import os

# Add the src directory to sys.path to import api
sys.path.append(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "src"))

from api import app
import api

client = TestClient(app)


def test_read_root():
    """Test the root endpoint to ensure API is running."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to the Salary Analysis API"}


def test_get_job_titles_mocked():
    """Test /job_titles with a mocked database."""
    # Mock the db object in the api module
    original_db = api.db
    api.db = MagicMock()
    api.db.get_job_titles.return_value = ["Data Analyst", "Data Scientist"]

    try:
        response = client.get("/job_titles")
        assert response.status_code == 200
        assert response.json() == {"job_titles": ["Data Analyst", "Data Scientist"]}
    finally:
        # Restore the original db object
        api.db = original_db
