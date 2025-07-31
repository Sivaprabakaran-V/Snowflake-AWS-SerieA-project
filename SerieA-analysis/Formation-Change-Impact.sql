-- This query analyzes the impact of changing formations on match outcomes for each team by season.
-- Logic:
-- 1. `prev_formation`: Captures the formation used in the previous match for each team (using LAG).
-- 2. `formation_status`: Labels each match as 'CHANGED' if the current formation differs from the previous one; otherwise 'SAME'.
-- 3. Groups data by TEAM, SEASON, and formation status to:
--     - Count how many matches were played with/without formation changes.
--     - Calculate the win rate for each case (i.e., success rate of formation changes).
-- This helps assess whether sticking to or changing formations affects team performance.

--Formation Change Impact on Result
WITH ordered_games AS (
    SELECT *, 
           LAG(FORMATION) OVER(PARTITION BY TEAM ORDER BY MATCH_DATE) AS prev_formation
    FROM SERIEA.VIEWS.PROCESSED_VIEW
)
SELECT 
    TEAM, 
    SEASON,
    CASE 
        WHEN FORMATION != prev_formation THEN 'CHANGED' 
        ELSE 'SAME' 
    END AS formation_status,
    COUNT(*) AS MATCHES_PLAYED,
    ROUND(AVG(CASE WHEN RESULT = 'W' THEN 1 ELSE 0 END), 2) AS win_rate
FROM ordered_games
WHERE prev_formation IS NOT NULL
GROUP BY TEAM, SEASON, formation_status
ORDER  BY SEASON, TEAM;