-- This query evaluates attacking efficiency and possession effectiveness of teams.
-- Metrics calculated per season, team, and venue:
-- - On-Target Ratio: Total Shots / Shots on Target (lower is better accuracy)
-- - Shot Conversion Rate: Goals Scored / Total Shots (higher means clinical finishing)
-- - Possession Effectiveness: Goals Scored / Possession % (how well possession is turned into goals)
-- Useful for analyzing teams’ ability to convert chances and make use of ball control.

--Shots-to-Goals Conversion & Possession Effectiveness
CREATE OR REPLACE TABLE SERIEA.RESULTS.SHOTS_TO_GOALS AS 
SELECT 
SEASON, TEAM, VENUE,
SUM(SHOTS) AS TOTAL_SHOTS_TAKE,
SUM(shots_on_target) AS TOTAL_SHOTS_TARGET,
SUM(GOALS_FOR) AS TOTAL_GOALS,
ROUND(SUM(shots)/SUM(shots_on_target),2) AS ON_TARGET_RATIO,
ROUND(SUM(GOALS_FOR)/SUM(SHOTS),2) AS SHOT_CONVERSION_RATE,
ROUND(AVG(POSSESSION),2) AS AVG_POSSESSION,
ROUND(SUM(GOALS_FOR)/SUM(POSSESSION),2) AS POSSESSION_EFFECTIVENESS
FROM SERIEA.VIEWS.PROCESSED_VIEW
GROUP BY SEASON, TEAM, VENUE
ORDER BY SEASON, TEAM ASC;