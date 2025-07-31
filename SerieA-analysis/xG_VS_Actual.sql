-- This query analyzes team performance by comparing actual goals with expected goals (xG) metrics.
-- It calculates offensive and defensive efficiency across seasons and venues:
-- - xG Efficiency Ratio = Actual Goals Scored / Expected Goals (Higher means clinical finishing)
-- - Conceding xG Efficiency Ratio = Actual Goals Conceded / Expected Goals Against (Lower means better defense)
-- Helps identify teams that consistently overperform or underperform their xG expectations.
CREATE OR REPLACE TABLE xG_VS_Actual
AS
SELECT SEASON, TEAM, VENUE,
SUM(EXPECTED_GOALS) AS TEAM_XG,
SUM(GOALS_FOR) AS TOTAL_GOAL_SCORED,
ROUND(SUM(GOALS_FOR)/SUM(EXPECTED_GOALS),2) as XG_EFFICIENCY_RATIO,
SUM(EXPECTED_GOALS_AGAINST) AS XG_GOAL_CONCEDED,
SUM(GOALS_AGAINST) AS GOAL_CONCEDED,
ROUND(SUM(GOALS_AGAINST)/SUM(EXPECTED_GOALS_AGAINST)) AS CONCEDING_XG_EFFICIENCY_RATIO
FROM SERIEA.VIEWS.PROCESSED_VIEW
GROUP BY SEASON, TEAM,VENUE
ORDER BY SEASON, TEAM ASC;