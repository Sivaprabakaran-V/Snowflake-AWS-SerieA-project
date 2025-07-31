-- This query tracks each team's recent form across the season by looking at the last 5 matches.
-- It calculates:
-- - LAST_1 to LAST_5: Results from the previous 5 matches (W/D/L), using LAG window functions.
-- - FORM_SCORE: Total points earned in the last 5 matches (Win = 3, Draw = 1, Loss = 0).
-- This helps evaluate short-term momentum and recent consistency in team performance.
-- Useful for predicting outcomes, identifying in-form teams, or tracking slumps/recoveries.

--tracking team's recent performance
SELECT * FROM SERIEA.VIEWS.PROCESSED_VIEW;

CREATE OR REPLACE TABLE SERIEA.RESULTS.teams_recent_performance AS
SELECT SEASON,
       TEAM,
       MATCH_DATE,
       OPPONENT
       RESULT,
       LAG(RESULT,1) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE) AS LAST_1,
       LAG(RESULT,2) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE) AS LAST_2,
       LAG(RESULT,3) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE) AS LAST_3,
       LAG(RESULT,4) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE) AS LAST_4,
       LAG(RESULT,5) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE) AS LAST_5,
       SUM(CASE WHEN RESULT = 'W' THEN 3
            WHEN RESULT = 'D' THEN 1
            ELSE 0 END) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS FORM_SCORE

FROM SERIEA.VIEWS.PROCESSED_VIEW
ORDER BY SEASON, TEAM ASC;