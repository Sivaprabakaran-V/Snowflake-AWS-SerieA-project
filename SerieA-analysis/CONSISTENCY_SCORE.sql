-- This query calculates a Consistency Score for each team based on their xG performance.
-- Steps:
-- 1. Computes xG-based attacking and defending efficiency for each team, season, and venue.
-- 2. Calculates the standard deviation of the difference between xG efficiency and conceding efficiency.
-- - A lower consistency score indicates stable performance (less variation in match outcomes).
-- - A higher score suggests fluctuation in performance — inconsistent finishing or defending.
-- Helps identify which teams are tactically and performance-wise consistent throughout the season.

CREATE OR REPLACE TABLE SERIEA.RESULTS.CONSISTENCY_SCORE AS


WITH CTE AS (
  SELECT 
    SEASON, 
    TEAM, 
    VENUE,
    SUM(EXPECTED_GOALS) AS TEAM_XG,
    SUM(GOALS_FOR) AS TOTAL_GOAL_SCORED,
    SUM(GOALS_FOR) / NULLIF(SUM(EXPECTED_GOALS), 0) AS XG_EFFICIENCY_RATIO,
    SUM(EXPECTED_GOALS_AGAINST) AS XG_GOAL_CONCEDED,
    SUM(GOALS_AGAINST) AS GOAL_CONCEDED,
    SUM(GOALS_AGAINST) / NULLIF(SUM(EXPECTED_GOALS_AGAINST), 0) AS CONCEDING_XG_EFFICIENCY_RATIO
  FROM SERIEA.VIEWS.PROCESSED_VIEW
  GROUP BY SEASON, TEAM, VENUE
)

SELECT 
  TEAM, SEASON,TEAM_XG,
  STDDEV(XG_EFFICIENCY_RATIO - CONCEDING_XG_EFFICIENCY_RATIO) AS CONSISTENCY_SCORE
FROM CTE
GROUP BY TEAM, SEASON
ORDER BY SEASON, TEAM ASC;

SELECT * FROM SERIEA.RESULTS.CONSISTENCY_SCORE;

SELECT * FROM SERIEA.VIEWS.PROCESSED_VIEW;