-- This query examines the impact of crowd attendance during away matches on team performance.
-- Steps:
-- 1. Filters away matches with valid xG and goals scored data.
-- 2. Calculates:
--    - XG_EFF: Goals Scored / Expected Goals (rounded), to measure attacking efficiency.
--    - POINTS: Match points based on result (Win = 3, Draw = 1, Loss = 0).
-- 3. Computes correlations:
--    - CORR_XG_ATTENDANCE: Correlation between away crowd attendance and xG efficiency.
--    - CORR_POINTS_ATTENDANCE: Correlation between attendance and match outcomes.
-- This helps assess whether playing in front of larger away crowds influences performance positively or negatively.


CREATE OR REPLACE TABLE seriea.results.away_correlation AS
WITH team_performace as (
SELECT 
    TEAM, SEASON,
    ROUND(GOALS_FOR/EXPECTED_GOALS) AS XG_EFF,
        CASE WHEN RESULT = 'W' THEN 3
             WHEN RESULT =  'D' THEN 1 
             ELSE 0 END AS POINTS,
    ATTENDANCE
    FROM SERIEA.VIEWS.PROCESSED_VIEW
    WHERE VENUE = 'Away' AND GOALS_FOR != 0 AND EXPECTED_GOALS !=0),
team_corr AS
(
SELECT 
    TEAM,
    SEASON,
    CORR(XG_EFF,ATTENDANCE)AS CORR_XG_ATTENDANCE,
    CORR (POINTS,ATTENDANCE) AS CORR_POINTS_ATTENDANCE
    FROM team_performace
    GROUP BY TEAM, SEASON
    HAVING COUNT(*) >= 2
)
SELECT * FROM team_corr
ORDER BY SEASON, TEAM;