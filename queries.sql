-- ========================================================================================
-- Pharmaceutical Drug Spending Analysis
-- Dataset: Pharmaceutical Drug Spending by Countries (OECD)
-- Source: https://datahub.io/core/pharmaceutical-drug-spending
-- Author: Sofia Hernandez Bellone
-- Description: Exploratory analysis of global pharmaceutical drug spending
--              covering country rankings, spending trends over 50 years,
--              GDP and health budget prioritization, and per capita
--              expenditure comparisons across OECD countries (1971-2022).
-- ========================================================================================

-- ========================================================================================
-- 1. OVERVIEW
-- ========================================================================================

-- 1.1 General Summary
-- High-level snapshot of the dataset: countries, years and spending covered.
SELECT
    COUNT(*)                        AS total_rows,
    COUNT(DISTINCT location)        AS total_countries,
    MIN(time)                       AS first_year,
    MAX(time)                       AS last_year,
    ROUND(SUM(total_spend), 2)      AS total_spend_all_time,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita
FROM pharma;

-- 1.2 Total Spending by Country (all years)
-- Identifies which countries have spent the most on pharmaceuticals over the entire 
-- period covered by the dataset.
SELECT
    location,
    ROUND(SUM(total_spend), 2)      AS total_spend,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    ROUND(AVG(pc_healthxp), 2)        AS avg_pc_health
FROM pharma
GROUP BY location
ORDER BY total_spend DESC;

-- 1.3 Top 10 Countries by Total Spending
-- USA leads global pharmaceutical, followed by Japan and Germany.
-- The top 10 countries concentrate the vast majority of total expenditure.
SELECT
    location,
    ROUND(SUM(total_spend), 2)      AS total_spend,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita
FROM pharma
GROUP BY location
ORDER BY total_spend DESC
LIMIT 10;

-- 1.4 Top 10 Countries by Spending per Capita
-- USA leads per capita spending, followed by Malta and Switzerland.
-- Notably, smaller economies like Malta and Slovenia rank above larger ones.
SELECT
    location,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp
FROM pharma
GROUP BY location
ORDER BY avg_spend_per_capita DESC
LIMIT 10;

-- 1.5 Top 10 Countries by Pharmaceutical Spending as % of GDP
-- Eastern European countries (Bulgaria, Hungary, Slovakia) allocate the largest share of 
-- their GDP to pharmaceuticals, despite lower absolute spending levels.
SELECT
    location,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    ROUND(AVG(pc_healthxp), 2)        AS avg_pc_health,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita
FROM pharma
GROUP BY location
ORDER BY avg_pc_gdp DESC
LIMIT 10;

-- 1.6 Top 10 Countries by Pharmaceutical Spending as % of Health Budget
-- Bulgaria leads its health budget spent on pharmaceuticals, suggesting a 
-- heavy reliance on medication over other healthcare services.
SELECT
    location,
    ROUND(AVG(pc_healthxp), 2)        AS avg_pc_health,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita
FROM pharma
GROUP BY location
ORDER BY avg_pc_health DESC
LIMIT 10;

-- ========================================================================================
-- 2. SPENDING TRENDS OVER TIME
-- ========================================================================================

-- 2.1 Global Spending by Year
-- Global pharmaceutical spending grew consistently in 1970 to a peak
-- in 2019, with a notable decline in 2022 likely due to incomplete data.
SELECT
    time                                AS year,
    ROUND(SUM(total_spend), 2)          AS total_spend,
    ROUND(AVG(usd_cap), 2)              AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)               AS avg_pc_gdp,
    ROUND(AVG(pc_healthxp), 2)          AS avg_pc_health
FROM pharma
GROUP BY time
ORDER BY time;

-- 2.2 First and Last Year Spending by Country
-- USA shows the highest absolute growth, nearly Japan's growth.
SELECT
    location,
    MIN(time)                           AS first_year,
    MAX(time)                           AS last_year,
    ROUND(MIN(total_spend), 2)          AS first_year_spend,
    ROUND(MAX(total_spend), 2)          AS last_year_spend,
    ROUND(MAX(total_spend) - MIN(total_spend), 2) AS absolute_growth
FROM pharma
GROUP BY location
ORDER BY absolute_growth DESC;

-- 2.3 Decade Analysis
-- Global spending grew exponentially
SELECT
    CASE
        WHEN time BETWEEN 1971 AND 1980 THEN '1970s'
        WHEN time BETWEEN 1981 AND 1990 THEN '1980s'
        WHEN time BETWEEN 1991 AND 2000 THEN '1990s'
        WHEN time BETWEEN 2001 AND 2010 THEN '2000s'
        WHEN time BETWEEN 2011 AND 2020 THEN '2010s'
        ELSE '2020s'
    END                                 AS decade,
    ROUND(SUM(total_spend), 2)          AS total_spend,
    ROUND(AVG(usd_cap), 2)              AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)               AS avg_pc_gdp
FROM pharma
GROUP BY decade
ORDER BY decade;

-- 2.4 Top 5 Countries with Highest Spending Growth
-- USA, Japan, Germany, France and South Korea lead absolute spending growth, reflecting both 
-- economic size and pharmaceutical market development.
SELECT
    location,
    MIN(time)                           AS first_year,
    MAX(time)                           AS last_year,
    ROUND(MIN(total_spend), 2)          AS first_year_spend,
    ROUND(MAX(total_spend), 2)          AS last_year_spend,
    ROUND(MAX(total_spend) - MIN(total_spend), 2) AS absolute_growth
FROM pharma
GROUP BY location
ORDER BY absolute_growth DESC
LIMIT 5;

-- ========================================================================================
-- 3. COUNTRY COMPARISONS
-- ========================================================================================

-- 3.1 Spending per Capita vs % of GDP by Country
-- USA leads per capita spending, followed by Malta and Switzerland.
-- Eastern European countries (BGR, SVK, HUN) show high GDP share but moderate per capita,
-- reflecting lower income levels despite heavy pharmaceutical reliance.
SELECT
    location,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    ROUND(AVG(pc_healthxp), 2)      AS avg_pc_health
FROM pharma
GROUP BY location
ORDER BY avg_spend_per_capita DESC;

-- 3.2 Countries with Highest Spending as % of Health Budget
-- Bulgaria allocates its health budget to pharmaceuticals the highest among
-- all reported countries, followed by Slovakia and Hungary.
-- All top 10 are Eastern European countries, suggesting a regional pattern.
-- Note: Countries with limited data were filtered out to ensure comparability.
SELECT
    location,
    ROUND(AVG(pc_healthxp), 2)      AS avg_pc_health,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    COUNT(time)                     AS years_reported
FROM pharma
GROUP BY location
HAVING years_reported >= 5
ORDER BY avg_pc_health DESC
LIMIT 10;

-- 3.3 Countries with Lowest Spending per Capita
-- Turkey shows the lowest per capita spending, though its data only covers 1981-2000.
-- Note: Countries with limited data were filtered out to ensure comparability.
SELECT
    location,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    COUNT(time)                     AS years_reported
FROM pharma
GROUP BY location
HAVING years_reported >= 5
ORDER BY avg_spend_per_capita ASC
LIMIT 10;

-- 3.4 Most Consistent Reporters
-- Canada, South Korea and Iceland have the most complete data.
-- Several countries like Chile and Brazil have very limited data,
-- which affects the reliability of their averages in other queries.
SELECT
    location,
    COUNT(time)                     AS years_reported,
    MIN(time)                       AS first_year,
    MAX(time)                       AS last_year
FROM pharma
GROUP BY location
ORDER BY years_reported DESC;

-- ========================================================================================
-- 4. HEALTH BUDGET ANALYSIS
-- ========================================================================================

-- 4.1 Pharmaceutical Spending as % of Health Budget Over Time
-- The global average peaked in the 2000s and has been declining since.
-- The gap between min and max across countries remains wide.
SELECT
    time                                AS year,
    ROUND(AVG(pc_healthxp), 2)          AS avg_pc_health,
    ROUND(MIN(pc_healthxp), 2)          AS min_pc_health,
    ROUND(MAX(pc_healthxp), 2)          AS max_pc_health
FROM pharma
GROUP BY time
ORDER BY time;

-- 4.2 Countries with the Most Stable Health Budget Share
-- Switzerland shows the most stable pharmaceutical budget share,
-- followed by Israel and Germany.
-- Note: Countries with limited data were filtered out to ensure comparability
SELECT
    location,
    ROUND(AVG(pc_healthxp), 2)          AS avg_pc_health,
    ROUND(MAX(pc_healthxp) - MIN(pc_healthxp), 2) AS range_pc_health,
    COUNT(time)                         AS years_reported
FROM pharma
GROUP BY location
HAVING years_reported >= 10
ORDER BY range_pc_health ASC
LIMIT 10;

-- 4.3 Global Average Health Budget Share by Decade
-- The pharmaceutical share of health budgets peaked in the 2000s
-- and has declined since.
SELECT
    CASE
        WHEN time BETWEEN 1971 AND 1980 THEN '1970s'
        WHEN time BETWEEN 1981 AND 1990 THEN '1980s'
        WHEN time BETWEEN 1991 AND 2000 THEN '1990s'
        WHEN time BETWEEN 2001 AND 2010 THEN '2000s'
        WHEN time BETWEEN 2011 AND 2020 THEN '2010s'
        ELSE '2020s'
    END                                 AS decade,
    ROUND(AVG(pc_healthxp), 2)          AS avg_pc_health,
    ROUND(MIN(pc_healthxp), 2)          AS min_pc_health,
    ROUND(MAX(pc_healthxp), 2)          AS max_pc_health
FROM pharma
GROUP BY decade
ORDER BY decade;
