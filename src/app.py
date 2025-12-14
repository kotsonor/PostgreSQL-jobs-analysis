import streamlit as st
from api_manager import APIManager
from viz_manager import VisualizationManager

st.set_page_config(page_title="Salary Analysis", layout="wide")

# Detect theme
st.markdown(
    """
<script>
function detectTheme() {
    const body = document.body;
    const isDark = body.classList.contains('dark') || 
                   window.getComputedStyle(body).backgroundColor === 'rgb(17, 17, 17)';
    const theme = isDark ? 'dark' : 'light';
    window.parent.postMessage({type: 'streamlit:setSessionState', key: 'theme', value: theme}, '*');
}
detectTheme();
</script>
""",
    unsafe_allow_html=True,
)

# Default theme
if "theme" not in st.session_state:
    st.session_state.theme = "dark"


# Database manager initialization
# We use st.cache_resource to avoid connecting to the database on every click
@st.cache_resource
def get_manager():
    return APIManager()


try:
    db = get_manager()
except Exception as e:
    st.error(f"API configuration error: {e}")
    st.stop()

# --- UI START ---
st.title("Top 10 Highest Paying Jobs")

# Retrieve job titles list
try:
    job_titles = db.get_job_titles()
except Exception as e:
    st.error(f"Failed to retrieve job titles list: {e}")
    st.stop()

# Sidebar
selected_job_title = st.sidebar.selectbox("Select job type:", job_titles)

# Create tabs
tab1, tab2, tab3 = st.tabs(["Top Jobs", "Top Skills", "Skill Salaries"])

with tab1:
    # Retrieve and display data
    try:
        df = db.get_top_jobs(selected_job_title)

        # Dynamic header
        if selected_job_title == "All":
            st.subheader("Top 10 highest paying jobs (All categories)")
        else:
            st.subheader(f"Top 10 highest paying jobs for: {selected_job_title}")

        st.dataframe(df, width="stretch")

    except Exception as e:
        st.error(f"An error occurred while retrieving data: {e}")

with tab2:
    try:
        skills_df = db.get_top_skills(selected_job_title)

        if selected_job_title == "All":
            st.subheader("Top 10 skills (All categories)")
        else:
            st.subheader(f"Top 10 skills for: {selected_job_title}")

        fig = VisualizationManager.plot_top_skills(
            skills_df, theme=st.session_state.theme
        )
        st.pyplot(fig, transparent=True)

    except Exception as e:
        st.error(f"An error occurred while retrieving skills data: {e}")

with tab3:
    try:
        salaries_df = db.get_skill_salaries(selected_job_title)

        if selected_job_title == "All":
            st.subheader("Top 10 skills by average salary (All categories)")
        else:
            st.subheader(f"Top 10 skills by average salary for: {selected_job_title}")

        st.dataframe(salaries_df, width="stretch")

    except Exception as e:
        st.error(f"An error occurred while retrieving skill salaries data: {e}")
