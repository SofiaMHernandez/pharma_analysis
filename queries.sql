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
-- USA leads global pharmaceutical spending with $7.8B, followed by Japan and Germany.
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
-- USA leads per capita spending ($730), followed by Malta and Switzerland.
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
-- Bulgaria leads with 35.28% of its health budget spent on pharmaceuticals, suggesting a 
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
-- Global pharmaceutical spending grew consistently from $8,492 in 1970 to a peak
-- of $1,039,235M in 2019, with a notable decline in 2022 likely due to incomplete data.
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
-- USA shows the highest absolute growth ($433,963M), nearly 4x Japan's growth ($107,628M).
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
-- Global spending grew exponentially: from $152,719M in the 1970s to $9,019,498M in the 2010s,
-- a 59x increase over five decades.
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
-- USA leads per capita spending ($730), followed by Malta ($669) and Switzerland ($652).
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
-- Bulgaria allocates 35.28% of its health budget to pharmaceuticals, the highest among
-- all reported countries, followed by Slovakia (29.66%) and Hungary (29.56%).
-- All top 10 are Eastern European countries, suggesting a regional pattern.
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
-- Turkey shows the lowest per capita spending ($35.17), though its data only covers
-- 1981-2000. Among well-reported countries, Norway ($221) and Denmark ($218) appear
-- low due to strong generic drug policies and price controls.
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
-- Canada, South Korea and Iceland have the most complete data (53 years, 1970-2022).
-- Several countries like Chile (3 years) and Brazil (5 years) have very limited data,
-- which affects the reliability of their averages in other queries.
SELECT
    location,
    COUNT(time)                     AS years_reported,
    MIN(time)                       AS first_year,
    MAX(time)                       AS last_year
FROM pharma
GROUP BY location
ORDER BY years_reported DESC;

-- 3.5 Spending Efficiency: High GDP Share but Low Per Capita
-- Brazil and Portugal allocate over 1.5% of GDP to pharmaceuticals
-- but maintain relatively low per capita spending, suggesting large populations
-- or price control policies limiting individual expenditure.
SELECT
    location,
    ROUND(AVG(pc_gdp), 2)           AS avg_pc_gdp,
    ROUND(AVG(usd_cap), 2)          AS avg_spend_per_capita,
    ROUND(AVG(pc_healthxp), 2)      AS avg_pc_health
FROM pharma
GROUP BY location
HAVING avg_pc_gdp > 1.5 AND avg_spend_per_capita < 300
ORDER BY avg_pc_gdp DESC;

-- ========================================================================================
-- 4. HEALTH BUDGET ANALYSIS
-- ========================================================================================

-- 4.1 Pharmaceutical Spending as % of Health Budget Over Time
-- The global average peaked in the 2000s (around 20%) and has been declining since,
-- reaching 12.25% in 2022. The gap between min and max across countries remains wide,
-- reflecting significant differences in national pharmaceutical policies.
SELECT
    time                                AS year,
    ROUND(AVG(pc_healthxp), 2)          AS avg_pc_health,
    ROUND(MIN(pc_healthxp), 2)          AS min_pc_health,
    ROUND(MAX(pc_healthxp), 2)          AS max_pc_health
FROM pharma
GROUP BY time
ORDER BY time;

-- 4.2 Countries Where Pharmaceutical Share of Health Budget is Increasing
-- Turkey and Greece show the largest increases in pharmaceutical share of health budget
-- (+15.41% and +10% respectively). Most countries show a declining trend,
-- suggesting a global shift toward other healthcare expenditures.
WITH split AS (
    SELECT
        location,
        AVG(CASE WHEN time <= (
            SELECT ROUND((MIN(time) + MAX(time)) / 2)
            FROM pharma p2
            WHERE p2.location = p1.location
        ) THEN pc_healthxp END)         AS first_half_avg,
        AVG(CASE WHEN time > (
            SELECT ROUND((MIN(time) + MAX(time)) / 2)
            FROM pharma p2
            WHERE p2.location = p1.location
        ) THEN pc_healthxp END)         AS second_half_avg
    FROM pharma p1
    GROUP BY location
)
SELECT
    location,
    ROUND(first_half_avg, 2)            AS first_half_avg,
    ROUND(second_half_avg, 2)           AS second_half_avg,
    ROUND(second_half_avg - first_half_avg, 2) AS trend
FROM split
ORDER BY trend DESC;

-- 4.3 Countries with the Most Stable Health Budget Share
-- Switzerland shows the most stable pharmaceutical budget share (range of only 0.67%),
-- followed by Israel (3%) and Germany (3.82%), reflecting consistent long-term policies.
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

-- 4.4 Global Average Health Budget Share by Decade
-- The pharmaceutical share of health budgets peaked in the 2000s (19.47% average)
-- and has declined since, suggesting a global rebalancing toward other healthcare services.
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

-- ========================================================================================
-- 5. ADVANCED ANALYSIS
-- ========================================================================================

-- 5.1 Country Ranking by Per Capita Spending (each year)
-- USA has held the #1 position in per capita spending consistently since 1997.
-- In the early years (1970s), France and Germany led the rankings.
SELECT
    time                                AS year,
    location,
    ROUND(usd_cap, 2)                   AS usd_cap,
    RANK() OVER (
        PARTITION BY time
        ORDER BY usd_cap DESC
    )                                   AS rank_per_capita
FROM pharma
ORDER BY time, rank_per_capita;

-- 5.2 Year-over-Year Growth in Per Capita Spending by Country
-- Korea shows the most sustained growth over 50 years, starting at $3.98 in 1970
-- and reaching $803 in 2022. Costa Rica shows the most volatile year-over-year changes,
-- including a -42% drop in 2017.
SELECT
    location,
    time                                AS year,
    ROUND(usd_cap, 2)                   AS usd_cap,
    ROUND(LAG(usd_cap) OVER (
        PARTITION BY location
        ORDER BY time
    ), 2)                               AS prev_year_usd_cap,
    ROUND(
        (usd_cap - LAG(usd_cap) OVER (
            PARTITION BY location
            ORDER BY time
        )) / LAG(usd_cap) OVER (
            PARTITION BY location
            ORDER BY time
        ) * 100
    , 2)                                AS yoy_growth_pct
FROM pharma
ORDER BY location, time;

-- 5.3 Cumulative Spending by Country
-- USA has accumulated over $7.8 trillion in pharmaceutical spending since 1987,
-- dwarfing all other countries. Japan is second with $2.2 trillion since 1980.
SELECT
    location,
    time                                AS year,
    ROUND(total_spend, 2)               AS total_spend,
    ROUND(SUM(total_spend) OVER (
        PARTITION BY location
        ORDER BY time
    ), 2)                               AS cumulative_spend
FROM pharma
ORDER BY location, time;

-- 5.4 Countries Ranked by GDP Share Each Year
-- Bulgaria and Greece consistently rank in the top 2 for pharmaceutical GDP share
-- in recent years, while Norway and Denmark consistently rank last,
-- reflecting strong generic drug policies and price controls.
SELECT
    time                                AS year,
    location,
    ROUND(pc_gdp, 2)                    AS pc_gdp,
    RANK() OVER (
        PARTITION BY time
        ORDER BY pc_gdp DESC
    )                                   AS rank_pc_gdp
FROM pharma
ORDER BY time, rank_pc_gdp;

-- 5.5 Moving Average of Global Per Capita Spending (3-year)
-- Global per capita spending grew from $25 in 1970 to $668 in 2022.
-- The 3-year moving average confirms a smooth and sustained upward trend
-- with no major reversals, even during economic downturns.
SELECT
    time                                AS year,
    ROUND(AVG(usd_cap), 2)              AS avg_usd_cap,
    ROUND(AVG(AVG(usd_cap)) OVER (
        ORDER BY time
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                               AS moving_avg_3yr
FROM pharma
GROUP BY time
ORDER BY time;
