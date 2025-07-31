-- This query identifies the top 3 teams in each season based on total points earned.
-- Uses RANK() to rank teams within each season in descending order of performance.
-- Highlights season leaders or consistently high-performing teams across multiple years.
-- Useful for recognizing dominant teams and tracking leadership consistency in the league.
--Persistent Leaders (Top 3 in each season)

SELECT SEASON, TEAM, TOTAL_POINTS FROM SERIEA.RESULTS.team_trends
QUALIFY RANK() OVER(PARTITION BY SEASON ORDER BY TOTAL_POINTS DESC) <=3
ORDER BY SEASON, TOTAL_POINTS DESC;