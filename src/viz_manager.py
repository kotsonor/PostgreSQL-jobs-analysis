import matplotlib.pyplot as plt
import seaborn as sns


class VisualizationManager:
    @staticmethod
    def plot_top_skills(skills_df, theme="dark"):
        """Generates a bar chart for top skills."""
        fig, ax = plt.subplots(figsize=(10, 6))

        # Transparent background setup
        fig.patch.set_alpha(0)
        ax.set_facecolor("none")

        sns.barplot(
            data=skills_df,
            x="skill_count",
            y="skills",
            hue="skills",
            palette="viridis",
            ax=ax,
        )

        # Set text and spines color based on theme
        text_color = "white" if theme == "dark" else "black"
        ax.set_xlabel("Count", color=text_color)
        ax.set_ylabel("Skill", color=text_color)
        ax.tick_params(axis="x", colors=text_color)
        ax.tick_params(axis="y", colors=text_color)

        for spine in ax.spines.values():
            spine.set_edgecolor(text_color)

        return fig
