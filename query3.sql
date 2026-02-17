-- Query 3: Session Engagement Rate by Device
-- Description:
-- Calculate the percentage of events where session_engaged = 1
-- out of all events where session_engaged is not NULL, grouped by device.

WITH session_engaged AS (
    SELECT
        ga_session_id,
        params.value.string_value AS session_engaged
    FROM DA.event_params ep,
    UNNEST(event_params) AS params
    WHERE params.key = 'session_engaged'
)

SELECT
    sp.device,
    COUNT(CASE WHEN session_engaged LIKE '1' THEN sp.ga_session_id END) AS session_engaged_1_cnt,
    ROUND(
        COUNT(CASE WHEN session_engaged LIKE '1' THEN sp.ga_session_id END) 
        / COUNT(CASE WHEN session_engaged IS NOT NULL THEN sp.ga_session_id END) * 100,
        2
    ) AS percent_from_not_null
FROM session_engaged se
JOIN DA.session_params sp
    ON se.ga_session_id = sp.ga_session_id
GROUP BY sp.device;