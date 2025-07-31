-- This query calculates percentile rankings of teams based on their season performance.
-- It evaluates:
-- - XG_EFFICIENCY: Ratio of Goals Scored to Expected Goals (higher = better finishing).
-- - TOTAL_POINTS: Sum of match points (W = 3, D = 1, L = 0).
-- - PERCENTILE_TOTAL_POINTS: Rank of each team based on total points within their season.
-- - PERCENTILE_XG_EFFICIENCY: Rank of each team based on xG efficiency within their season.
-- These percentile metrics help compare relative team performance and finishing quality across seasons.
--Percentile Rankings of Team Performance by Season (Based on Points and xG Efficiency)

CREATE OR REPLACE TABLE Percentile_Rankings AS

WITH team_performance AS(
SELECT SEASON, TEAM, 
    ROUND(SUM(GOALS_FOR)/SUM(EXPECTED_GOALS),2) AS XG_EFFICIENCY,
    SUM(CASE
            WHEN RESULT = 'W' THEN 3 
            WHEN RESULT = 'D' THEN 1
            ELSE 0 END) AS TOTAL_POINTS    
FROM SERIEA.VIEWS.PROCESSED_VIEW
GROUP BY SEASON, TEAM)

SELECT 
    SEASON,
    TEAM,
    XG_EFFICIENCY,
    TOTAL_POINTs,
    PERCENT_RANK() OVER(PARTITION BY SEASON ORDER BY TOTAL_POINTS) AS PERCENTILE_TOTAL_POINTS,
    PERCENT_RANK() OVER(PARTITION BY SEASON ORDER BY XG_EFFICIENCY ) AS PERCENTILE_XG_EFFICIENCY    

FROM TEAM_PERFORMANCE
ORDER BY SEASON, PERCENTILE_TOTAL_POINTS DESC;