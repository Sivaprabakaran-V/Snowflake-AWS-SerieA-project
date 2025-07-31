-- This query identifies the top 3 most improved teams in each season based on points gained compared to the previous season.
-- It filters out teams without a previous season record (NULL POINTS_DIFF).
-- Uses RANK() to rank teams by the highest positive change in points (POINTS_DIFF).
-- Helps highlight teams that showed significant progress or turnaround performances across seasons.

--most improved team
SELECT SEASON,TEAM, POINTS_DIFF FROM SERIEA.RESULTS.team_trends
WHERE POINTS_DIFF IS NOT NULL
QUALIFY RANK() OVER (PARTITION BY SEASON ORDER BY POINTS_DIFF DESC) <=3
ORDER BY SEASON;