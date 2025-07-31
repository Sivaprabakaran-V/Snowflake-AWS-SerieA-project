-- This query compares average goals scored and conceded by each team between the 2024 and 2025 seasons.
-- It calculates:
-- - GS_2024 & GS_2025: Average goals scored per match in each season.
-- - GC_2024 & GC_2025: Average goals conceded per match in each season.
-- - scoring_trend: Indicates improvement (↑), decline (↓), or no change (~) in attacking performance.
-- - defensive_trend: Indicates improvement (↓), decline (↑), or no change (~) in defensive performance.
-- Useful for identifying tactical changes, scoring improvements, or defensive regressions between seasons.

--Goal Metrics Evolution
SELECT DISTINCT SEASON FROM SERIEA.VIEWS.PROCESSED_VIEW;

WITH team_goals_summary AS
(
SELECT SEASON, TEAM, 
       ROUND(AVG(GOALS_FOR),2) AS avg_goals_scored,
       ROUND(AVG(GOALS_AGAINST),2) AS avg_goals_against
FROM SERIEA.VIEWS.PROCESSED_VIEW
WHERE SEASON IN ('2024','2025') 
GROUP BY SEASON, TEAM
)
SELECT 
    g24.team as TEAM,
    g24.avg_goals_scored as GS_2024,
    g25.avg_goals_scored as GS_2025,
    CASE
        WHEN g24.avg_goals_scored < g25.avg_goals_scored THEN '↑'
        WHEN g24.avg_goals_scored > g25.avg_goals_scored THEN '↓'
        ELSE '~'
    END AS scoring_trend,
    g24.avg_goals_against as GC_2024,
    g25.avg_goals_against as GC_2025,
    CASE 
        WHEN g24.avg_goals_against > g25.avg_goals_against then '↑'
        WHEN g24.avg_goals_against < g25.avg_goals_against then '↓'
        ELSE '~'
    END AS defensive_trend
 FROM team_goals_summary g24
 JOIN team_goals_summary g25 on g24.team = g25.team
 WHERE g24.season ='2024' and g25.season ='2025'
 ORDER BY TEAM;