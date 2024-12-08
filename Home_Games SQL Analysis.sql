/*
NOTE - Can comment Season filter and add Having clause for the particular team
To check team's performance over the years
*/

-- 1. Did teams perform better or worse at home during the COVID period? 
SELECT 
    season,
    team,
    SUM(CASE WHEN season IN ('2019-20', '2020-21') THEN wins END) AS covid_home_wins,
    SUM(CASE WHEN season NOT IN ('2019-20', '2020-21') THEN wins END) AS non_covid_home_wins,
    SUM(CASE WHEN season IN ('2019-20', '2020-21') THEN matches END) AS covid_home_matches,
    SUM(CASE WHEN season NOT IN ('2019-20', '2020-21') THEN matches END) AS non_covid_home_matches,
    ROUND(SUM(CASE WHEN season IN ('2019-20', '2020-21') THEN wins END) * 1.0 /
          NULLIF(SUM(CASE WHEN season IN ('2019-20', '2020-21') THEN matches END), 0), 2) AS covid_win_rate,
    ROUND(SUM(CASE WHEN season NOT IN ('2019-20', '2020-21') THEN wins END) * 1.0 /
          NULLIF(SUM(CASE WHEN season NOT IN ('2019-20', '2020-21') THEN matches END), 0), 2) AS non_covid_win_rate
FROM laliga_home
GROUP BY season, team;

-- 2. Was there a difference in goals scored at home during COVID seasons?
SELECT 
    season,
    team,
    SUM(gf) AS total_goals_scored,
    SUM(ga) AS total_goals_conceded,
    SUM(gf)/SUM(matches) AS avg_goals_scored_per_match,
    SUM(ga)/SUM(matches) AS avg_goals_conceded_per_match
FROM laliga_home
WHERE season IN ('2019-20', '2020-21')
GROUP BY season, team;

-- 3. Was the home-field advantage significantly reduced?
SELECT 
    season,
    team,
    SUM(points) AS total_points,
    ROUND(SUM(points)/SUM(matches), 2) AS avg_points_per_match
FROM laliga_home
WHERE season IN ('2019-20', '2020-21')
GROUP BY season, team;

-- 4. Did the number of draws increase during the COVID period?
SELECT 
    season,
    team,
    SUM(draws) AS total_draws,
    SUM(draws)/SUM(matches) AS avg_draws_per_match
FROM laliga_home
WHERE season IN ('2019-20', '2020-21')
GROUP BY season, team;

-- 5. Were there specific teams or leagues most impacted?
SELECT 
    team,
    season,
    SUM(points) AS total_points,
    SUM(wins) AS total_wins,
    SUM(loses) AS total_losses
FROM laliga_home
WHERE season IN ('2019-20', '2020-21')
GROUP BY team, season
ORDER BY total_points DESC;

-- 6. Did the total number of goals decrease in the leagues during COVID seasons?
SELECT 
    season,
    SUM(gf) AS total_goals_for,
    SUM(ga) AS total_goals_against,
    (SUM(gf) + SUM(ga)) AS total_goals
FROM laliga_home
WHERE season IN ('2019-20', '2020-21')
GROUP BY season;

-- 7. How did team rankings change across seasons?
WITH ranked_teams AS (
    SELECT 
        season,
        team,
        RANK() OVER (PARTITION BY season ORDER BY points DESC) AS team_rank
    FROM laliga_home
)
SELECT 
    team,
    MAX(CASE WHEN season NOT IN ('2019-20', '2020-21') THEN COALESCE(team_rank, 0) END) AS pre_covid_rank,
    MAX(CASE WHEN season IN ('2019-20', '2020-21') THEN COALESCE(team_rank, 0) END) AS covid_rank,
    MIN(CASE WHEN season NOT IN ('2019-20', '2020-21') THEN COALESCE(team_rank, 0) END) AS pre_covid_rank,
    MIN(CASE WHEN season IN ('2019-20', '2020-21') THEN COALESCE(team_rank, 0) END) AS covid_rank
FROM ranked_teams
GROUP BY team;

