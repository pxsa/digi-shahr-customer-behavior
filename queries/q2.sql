
WITH user_cohorts AS (
    SELECT
        u.user_id,
        d.jalali_year AS signup_year,
        d.jalali_month AS signup_month
    FROM users u
    JOIN dim_date d
        ON d.date_gregorian = u.signup_at::date
),

user_activity AS (
    SELECT
        e.user_id,
        d.jalali_year AS event_year,
        d.jalali_month AS event_month
    FROM app_events e
    JOIN dim_date d
        ON e.event_time::date = d.date_gregorian
),

cohort_activity AS (
    SELECT
        c.user_id,
        c.signup_year,
        c.signup_month,
        a.event_year,
        a.event_month,

        (a.event_year - c.signup_year) * 12 +
        (a.event_month - c.signup_month) AS month_number

    FROM user_cohorts c
    JOIN user_activity a
        ON c.user_id = a.user_id
),
cohort_size AS (
    SELECT
        signup_year,
        signup_month,
        COUNT(DISTINCT user_id) AS cohort_users
    FROM user_cohorts
    GROUP BY signup_year, signup_month
),
retention AS (
    SELECT
        signup_year,
        signup_month,
        month_number,
        COUNT(DISTINCT user_id) AS active_users
    FROM cohort_activity
    WHERE month_number IN (1, 2, 3)
    GROUP BY
        signup_year,
        signup_month,
        month_number
)

SELECT
    r.signup_year,
    r.signup_month,
    r.month_number,
    cs.cohort_users,
    r.active_users,
    ROUND(
        100.0 * r.active_users / cs.cohort_users,
        2
    ) AS retention_percentage
FROM retention r
JOIN cohort_size cs
    ON r.signup_year = cs.signup_year
    AND r.signup_month = cs.signup_month
ORDER BY
    r.signup_year,
    r.signup_month,
    r.month_number;
