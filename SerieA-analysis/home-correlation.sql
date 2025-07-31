-- This query measures the correlation between home match attendance and team performance metrics.
-- Steps:
-- 1. Filters home matches with valid xG and goal data.
-- 2. Calculates:
--    - XG_EFF (Goals Scored / Expected Goals) as a measure of attacking efficiency.
--    - POINTS earned per match (Win = 3, Draw = 1, Loss = 0).
-- 3. Computes correlation coefficients:
--    - CORR_XG_ATTENDANCE: Correlation between attendance and xG efficiency.
--    - CORR_POINTS_ATTENDANCE: Correlation between attendance and match results.
-- Helps evaluate whether higher home crowd support impacts team efficiency or match outcomes.

CREATE OR REPLACE TABLE SERIEA.RESULTS.home_correlation as 
WITH team_performace as (
SELECT 
    TEAM, SEASON,
    ROUND(GOALS_FOR/EXPECTED_GOALS) AS XG_EFF,
    CASE WHEN RESULT = 'W' THEN 3
         WHEN RESULT =  'D' THEN 1 
         ELSE 0 END AS POINTS,
    ATTENDANCE
    FROM SERIEA.VIEWS.PROCESSED_VIEW
    WHERE VENUE = 'Home' AND GOALS_FOR != 0 AND EXPECTED_GOALS !=0),
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

