# PostgreSQL Jobs Analysis Project

A full-stack data analysis project demonstrating a modern architecture using **PostgreSQL**, **Docker**, **FastAPI**, and **Streamlit**.

This project analyzes job market data (salaries, skills, job titles) using a SQL database, exposes the data via a REST API, and visualizes it in an interactive dashboard.

## 🏗 Architecture

- **Database:** PostgreSQL (running in Docker)
- **Backend API:** FastAPI (Python)
- **Frontend:** Streamlit (Python)
- **Containerization:** Docker & Docker Compose
- **CI/CD:** GitHub Actions (Automated testing)

## 🚀 Getting Started

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.
- Git.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kotsonor/PostgreSQL-jobs-analysis.git
   cd PostgreSQL-jobs-analysis
   ```

2. **Prepare Data:**
   The CSV data files are too large for GitHub. Please download the dataset and place the following files in the `csv_files/` directory:
   - `company_dim.csv`
   - `job_postings_fact.csv`
   - `skills_dim.csv`
   - `skills_job_dim.csv`

3. **Configure Environment:**
   Create a `.env` file in the root directory with your database password:
   ```env
   sql_key="your_secure_password"
   ```

4. **Run with Docker:**
   ```bash
   docker-compose up --build
   ```
   This command will:
   - Start the PostgreSQL database.
   - Initialize the database schema and load data from CSV files.
   - Start the FastAPI backend.
   - Start the Streamlit frontend.

## 🖥 Usage

Once the containers are running:

- **Dashboard (Streamlit):** Open [http://localhost:8501](http://localhost:8501) in your browser.
- **API Documentation (Swagger UI):** Open [http://localhost:8000/docs](http://localhost:8000/docs).
- **Database:** Accessible on port `5433` (mapped from internal 5432).

## 🧪 Testing

To run the automated tests inside the Docker container:

```bash
docker-compose run --rm api pytest
```

## 📂 Project Structure

```
├── src/                # Source code
│   ├── api.py          # FastAPI application
│   ├── app.py          # Streamlit dashboard
│   ├── db_manager.py   # Database connection logic
│   └── ...
├── sql_load/           # SQL scripts for DB initialization
├── queries/            # SQL queries used by the app
├── csv_files/          # Data folder (place CSVs here)
├── tests/              # Unit tests
├── docker-compose.yml  # Docker services configuration
└── Dockerfile          # Python environment definition
```
