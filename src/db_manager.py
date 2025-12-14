import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
from pathlib import Path


class DatabaseManager:
    def __init__(self):
        load_dotenv()
        self.sql_key = os.getenv("sql_key")
        self.db_host = os.getenv("DB_HOST", "localhost")
        self.db_user = os.getenv("DB_USER", "postgres")
        self.db_name = os.getenv("DB_NAME", "sql_course")
        self.db_port = os.getenv("DB_PORT", "5432")

        if not self.sql_key:
            raise ValueError("Missing 'sql_key' in environment variables.")

        connection_string = f"postgresql://{self.db_user}:{self.sql_key}@{self.db_host}:{self.db_port}/{self.db_name}"
        self.engine = create_engine(connection_string)

    def _load_query(self, filename, folder="queries"):
        """Private method to load SQL file content."""
        path = Path(__file__).parent.parent / folder / filename
        return path.read_text()

    def get_job_titles(self):
        """Retrieves unique titles for the filter."""
        query = "SELECT DISTINCT job_title_short FROM job_postings_fact ORDER BY job_title_short;"
        df = pd.read_sql(query, self.engine)
        titles = df["job_title_short"].tolist()
        return ["All"] + titles

    def get_top_jobs(self, job_title="All"):
        """Retrieves data based on SQL file and filter."""
        # 1. Load raw SQL from file
        base_query = self._load_query("top10_jobs.sql", folder="queries")

        # 2. Prepare parameters and dynamic SQL condition
        params = {}
        sql_condition = ""

        if job_title != "All":
            # Add SQL condition in place of {condition}
            sql_condition = "AND job_title_short = %(job_title)s"
            params["job_title"] = job_title

        # 3. Insert condition into query (string formatting)
        final_query = base_query.format(condition=sql_condition)

        # 4. Execute query safely with parameters
        return pd.read_sql(final_query, self.engine, params=params)

    def get_top_skills(self, job_title="All"):
        """Retrieves top skills based on SQL file and filter."""
        base_query = self._load_query("2_top_skills.sql", folder="queries")

        params = {}
        sql_condition = ""

        if job_title != "All":
            sql_condition = "AND job_title_short = %(job_title)s"
            params["job_title"] = job_title

        final_query = base_query.format(condition=sql_condition)
        return pd.read_sql(final_query, self.engine, params=params)

    def get_skill_salaries(self, job_title="All"):
        """Retrieves skill salaries based on SQL file and filter."""
        base_query = self._load_query("3_skill_salaries.sql", folder="queries")

        params = {}
        sql_condition = ""

        if job_title != "All":
            sql_condition = "AND j.job_title_short = %(job_title)s"
            params["job_title"] = job_title

        final_query = base_query.format(condition=sql_condition)
        return pd.read_sql(final_query, self.engine, params=params)
