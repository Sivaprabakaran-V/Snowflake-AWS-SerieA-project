-- This query tracks cumulative and recent performance trends of each team across the season.
-- It calculates:
-- - running_total_points: Cumulative points earned by each team up to each matchday (Win = 3, Draw = 1, Loss = 0).
-- - moving_avg_goals: Rolling average of goals scored over the last 5 matches (including current).
-- These metrics help visualize both overall season progression and short-term performance fluctuations.
-- Useful for identifying improving/declining teams and monitoring point trends across fixtures.

--Running Totals and Moving Averages of Team Performance in Serie A Matches

SELECT SEASON, TEAM, MATCH_DATE, RESULT, OPPONENT,
    SUM(CASE
            WHEN RESULT = 'W' THEN 3 
            WHEN RESULT = 'D' THEN 1
            ELSE 0 END) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_points,
    ROUND(AVG(GOALS_FOR) OVER(PARTITION BY SEASON, TEAM ORDER BY MATCH_DATE ROWS BETWEEN 4 PRECEDING AND CURRENT ROW),2) AS moving_avg_goals    

FROM SERIEA.VIEWS.PROCESSED_VIEW
ORDER BY SEASON, TEAM, MATCH_DATE;