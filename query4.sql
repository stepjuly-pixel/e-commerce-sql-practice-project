-- Query 4: Cumulative Revenue vs Target
-- Description:
-- Calculate cumulative actual revenue vs cumulative predicted revenue by date
-- and compute the percentage of target achievement.
-- Use UNION ALL to combine actual revenue and predicted revenue data.

SELECT
    date,
    SUM(revenue) OVER(ORDER BY date) AS revenue_progress,
    SUM(predict_revenue) OVER(ORDER BY date) AS revenue_predict_progress,
    ROUND(
        SUM(revenue) OVER(ORDER BY date) / SUM(predict_revenue) OVER(ORDER BY date) * 100,
        2
    ) AS percentage_real_predict_revenue
FROM
(
    SELECT
        date,
        SUM(revenue) AS revenue,
        SUM(predict_revenue) AS predict_revenue
    FROM
    (
        -- Actual revenue per day
        SELECT
            ss.date AS date,
            SUM(p.price) AS revenue,
            0 AS predict_revenue
        FROM `data-analytics-mate.DA.order` o
        JOIN `data-analytics-mate.DA.product` p
            ON p.item_id = o.item_id
        JOIN `data-analytics-mate.DA.session` ss
            ON o.ga_session_id = ss.ga_session_id
        GROUP BY ss.date

        UNION ALL

        -- Predicted revenue per day
        SELECT
            date,
            0 AS revenue,
            predict AS predict_revenue
        FROM `data-analytics-mate.DA.revenue_predict`
    )
    GROUP BY date
);