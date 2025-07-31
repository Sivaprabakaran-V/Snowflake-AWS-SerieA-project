-- This query analyzes tactical and strategic shifts by identifying each team's most frequently used formation per season.
-- Steps:
-- 1. Counts the number of matches played in each formation per team per season.
-- 2. Ranks formations by usage count for each team and season.
-- 3. Selects the top-ranked (most used) formation as the primary tactical setup for the season.
-- Helps understand tactical evolution, stability, or shifts in team strategies year-over-year.


--Tactical and Strategic Shifts: Formation Evolution
SELECT * FROM SERIEA.VIEWS.PROCESSED_VIEW;

WITH team_formation AS(
SELECT SEASON, TEAM, FORMATION,
    COUNT(*) AS formation_count,
    RANK() OVER(PARTITION BY SEASON, TEAM ORDER BY FORMATION_COUNT DESC) AS formation_rnk

FROM SERIEA.VIEWS.PROCESSED_VIEW
GROUP BY SEASON, TEAM, FORMATION
ORDER BY formation_rnk ASC)

SELECT SEASON, TEAM,FORMATION,FORMATION_COUNT FROM team_formation
WHERE FORMATION_RNK =1
ORDER BY SEASON, TEAM ASC;