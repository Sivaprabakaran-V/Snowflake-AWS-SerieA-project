-- This query analyzes overall team performance trends across seasons.
-- It calculates key performance metrics per team per season:
-- - match_played: Total matches played
-- - TOTAL_POINTS: Total points earned (W = 3, D = 1, L = 0)
-- - WINS, DRAWS, LOSS: Match outcomes
-- - goals_scored, goals_conceded: Offensive and defensive totals
-- - xg_efficiency: Goals Scored / Expected Goals (measures finishing quality)
-- - win_percentage: Win rate as a percentage of matches played
-- Useful for season-over-season comparison of team performance and efficiency.

--Analyze team performance trends over seasons
SELECT * FROM SERIEA.VIEWS.PROCESSED_VIEW;


CREATE OR REPLACE TABLE performance_trends AS
WITH team_stats AS(
SELECT SEASON, TEAM, 
    COUNT(*) AS match_played,
    SUM(CASE
            WHEN RESULT = 'W' THEN 3 
            WHEN RESULT = 'D' THEN 1
            ELSE 0 END) AS TOTAL_POINTS,
    SUM(CASE WHEN RESULT = 'W' THEN 1 ELSE 0 END) AS WINS,
    SUM(CASE WHEN RESULT = 'D' THEN 1 ELSE 0 END) AS DRAWS,
    SUM(CASE WHEN RESULT = 'L' THEN 1 ELSE 0 END) AS LOSS,
    SUM(GOALS_FOR) AS goals_scored,
    SUM(GOALS_AGAINST) AS  goals_conceded,
    ROUND(SUM(GOALS_FOR)/SUM(EXPECTED_GOALS),2) AS xg_efficieny,
      
FROM SERIEA.VIEWS.PROCESSED_VIEW
GROUP BY SEASON, TEAM),
performance_trends AS(
SELECT *,
    ROUND((WINS*100.0)/match_played,2) AS win_percentage
FROM team_stats
)
SELECT * FROM performance_trends
ORDER BY SEASON, TEAM;

SELECT * FROM SERIEA.RESULTS.PERFORMANCE_TRENDS;