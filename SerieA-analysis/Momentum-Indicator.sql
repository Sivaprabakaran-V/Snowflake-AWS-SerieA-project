-- This query calculates a Momentum Indicator using a 5-match rolling average of goals scored.
-- It tracks recent form of each team across the season:
-- - avg_5_goal_per_match: Rolling average of goals from the current and previous 4 matches
-- Helps identify teams on a hot streak or declining form based on recent performance trends.
CREATE OR REPLACE TABLE SERIEA.RESULTS.momentum_indicator AS
SELECT 
TEAM, SEASON, MATCH_DATE, GOALS_FOR,
AVG(GOALS_FOR) OVER(PARTITION BY TEAM ORDER BY MATCH_DATE ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS avg_5_goal_per_match    
FROM SERIEA.VIEWS.PROCESSED_VIEW
ORDER BY season, team;