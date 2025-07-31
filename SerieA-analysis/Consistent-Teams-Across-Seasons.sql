-- This query identifies the most consistent top-performing teams across multiple seasons.
-- Steps:
-- 1. Selects the top 3 ranked teams per season based on total points.
-- 2. Counts how many distinct seasons each team appeared in the top 3.
-- 3. Filters for teams that were in the top 3 for at least 3 out of 4 seasons.
-- Helps recognize elite teams with sustained performance and dominance over time.

WITH top_3 AS (
    SELECT SEASON, TEAM, TOTAL_POINTS,
           RANK() OVER(PARTITION BY SEASON ORDER BY TOTAL_POINTS DESC) AS RANK
    FROM SERIEA.RESULTS.team_trends
    QUALIFY RANK() OVER(PARTITION BY SEASON ORDER BY TOTAL_POINTS DESC) <= 3
)
SELECT TEAM, COUNT(DISTINCT SEASON) AS season_in_Top3
FROM top_3
GROUP BY TEAM 
HAVING season_in_Top3 >= 3
ORDER BY TEAM;
