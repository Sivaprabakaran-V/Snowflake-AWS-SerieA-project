-- This query calculates the Formation Stability Score to measure how consistent each team is in using specific formations during a season.
-- Logic:
-- 1. `formation_variety`: Counts the number of unique formations used by each team in a season.
-- 2. `formation_stability_score`: Ratio of unique formations to total matches played, indicating tactical consistency.
--     - A lower score → Higher stability (used fewer formations consistently).
--     - A higher score → More tactical variation or experimentation.
-- Useful for identifying teams with stable tactical approaches vs. those frequently adjusting formations.

--Formation Stability Score
SELECT SEASON, TEAM, COUNT(DISTINCT FORMATION) AS formation_variety,
    ROUND(COUNT(DISTINCT FORMATION)/COUNT(*):: FLOAT,2) AS formation_stability_score
FROM SERIEA.VIEWS.PROCESSED_VIEW
GROUP BY SEASON, TEAM
ORDER BY SEASON, formation_stability_score ASC;
