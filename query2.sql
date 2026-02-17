-- Query 2: Monthly Marketing Cost Share
-- Description:
-- Calculate the percentage of monthly paid search costs relative to total costs across the entire period.
-- Use a window function to compute the percentages.
-- Output should display each month with its percentage of total costs.

SELECT
    month_date,
    year_date,
    month_cost,
    SUM(month_cost) OVER() AS total_cost,
    ROUND(month_cost / SUM(month_cost) OVER() * 100, 2) AS total_cost_percentage
FROM
(
    SELECT
        EXTRACT(MONTH FROM date) AS month_date,
        EXTRACT(YEAR FROM date) AS year_date,
        SUM(cost) AS month_cost
    FROM
        (
            SELECT
                date,
                cost
            FROM `data-analytics-mate.DA.paid_search_cost`
        ) day_cost_table
    GROUP BY month_date, year_date
) month_cost_table
ORDER BY year_date, month_date;