-- This query identifies the top 3 most declined teams in each season based on the drop in points compared to the previous season.
-- It filters out teams without a previous season record (NULL POINTS_DIFF).
-- Uses RANK() to find teams with the largest negative change in performance (lowest POINTS_DIFF).
-- Useful for spotting underperformers, regressions, or teams affected by tactical or roster changes across seasons.
--most declined team

SELECT SEASON,TEAM, POINTS_DIFF FROM SERIEA.RESULTS.team_trends
WHERE POINTS_DIFF IS NOT NULL
QUALIFY RANK() OVER (PARTITION BY SEASON ORDER BY POINTS_DIFF asc) <=3
ORDER BY SEASON;