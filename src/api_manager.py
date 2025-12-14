import os
import requests
import pandas as pd
from dotenv import load_dotenv


class APIManager:
    def __init__(self):
        load_dotenv()
        # Default to localhost if not set (for local testing without docker)
        # In docker-compose, we will set this to http://api:8000
        self.api_url = os.getenv("API_URL", "http://localhost:8000")
        print(f"APIManager initialized with URL: {self.api_url}")

    def get_job_titles(self):
        """Retrieves unique titles from the API."""
        try:
            response = requests.get(f"{self.api_url}/job_titles")
            response.raise_for_status()
            return response.json()["job_titles"]
        except requests.exceptions.RequestException as e:
            print(f"Error fetching job titles: {e}")
            return ["All"]  # Fallback

    def get_top_jobs(self, job_title="All"):
        """Retrieves top jobs from API."""
        try:
            params = {"job_title": job_title}
            response = requests.get(f"{self.api_url}/top_jobs", params=params)
            response.raise_for_status()
            data = response.json()
            return pd.DataFrame(data)
        except requests.exceptions.RequestException as e:
            print(f"Error fetching top jobs: {e}")
            return pd.DataFrame()

    def get_top_skills(self, job_title="All"):
        """Retrieves top skills from API."""
        try:
            params = {"job_title": job_title}
            response = requests.get(f"{self.api_url}/top_skills", params=params)
            response.raise_for_status()
            data = response.json()
            return pd.DataFrame(data)
        except requests.exceptions.RequestException as e:
            print(f"Error fetching top skills: {e}")
            return pd.DataFrame()

    def get_skill_salaries(self, job_title="All"):
        """Retrieves skill salaries from API."""
        try:
            params = {"job_title": job_title}
            response = requests.get(f"{self.api_url}/skill_salaries", params=params)
            response.raise_for_status()
            data = response.json()
            return pd.DataFrame(data)
        except requests.exceptions.RequestException as e:
            print(f"Error fetching skill salaries: {e}")
            return pd.DataFrame()
