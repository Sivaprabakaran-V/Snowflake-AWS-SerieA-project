-- This query analyzes year-over-year performance trends of each team in terms of total points earned.
-- It computes:
-- - PERV_POINTS: Points earned in the previous season (using LAG function).
-- - POINTS_DIFF: Change in points compared to the previous season.
-- Helps track team progression or regression across seasons and identify consistent improvements or declines.
-- Useful for trend analysis, performance forecasting, and understanding long-term growth or drop-offs.

--League Performance by Season — Points and Position Trends
CREATE TABLE team_trends AS 
SELECT SEASON, TEAM, TOTAL_POINTS,
    LAG(TOTAL_POINTS) OVER(PARTITION BY TEAM ORDER BY SEASON) AS PERV_POINTS,
    TOTAL_POINTS - LAG(TOTAL_POINTS) OVER(PARTITION BY TEAM ORDER BY SEASON) AS POINTS_DIFF

FROM SERIEA.RESULTS.PERFORMANCE_TRENDS
ORDER BY SEASON, TEAM;