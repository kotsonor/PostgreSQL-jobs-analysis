from fastapi import FastAPI, HTTPException
from db_manager import DatabaseManager

app = FastAPI(title="Salary Analysis API")

# Initialize DatabaseManager
# In a real app, you might want to use dependency injection or a singleton pattern properly
try:
    db = DatabaseManager()
except Exception as e:
    print(f"Failed to initialize DatabaseManager: {e}")
    db = None


@app.get("/")
def read_root():
    return {"message": "Welcome to the Salary Analysis API"}


@app.get("/job_titles")
def get_job_titles():
    if not db:
        raise HTTPException(status_code=500, detail="Database connection failed")
    try:
        titles = db.get_job_titles()
        return {"job_titles": titles}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/top_jobs")
def get_top_jobs(job_title: str = "All"):
    if not db:
        raise HTTPException(status_code=500, detail="Database connection failed")
    try:
        df = db.get_top_jobs(job_title)
        # Convert DataFrame to list of dicts
        return df.to_dict(orient="records")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/top_skills")
def get_top_skills(job_title: str = "All"):
    if not db:
        raise HTTPException(status_code=500, detail="Database connection failed")
    try:
        df = db.get_top_skills(job_title)
        return df.to_dict(orient="records")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/skill_salaries")
def get_skill_salaries(job_title: str = "All"):
    if not db:
        raise HTTPException(status_code=500, detail="Database connection failed")
    try:
        df = db.get_skill_salaries(job_title)
        return df.to_dict(orient="records")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
