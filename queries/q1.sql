WITH user_funnel AS (

    SELECT
        e.user_id,
        u.acquisition_channel,

        FLOOR(
            (MIN(e.event_time::date) - DATE '2026-03-21') / 7
        ) + 1 AS week_number,

        MIN(CASE
            WHEN e.event_name = 'app_open'
            THEN e.event_time
        END) AS app_open_time,

        MIN(CASE
            WHEN e.event_name = 'view_loan_products'
            THEN e.event_time
        END) AS view_products_time,

        MIN(CASE
            WHEN e.event_name = 'start_application'
            THEN e.event_time
        END) AS start_application_time,

        MIN(CASE
            WHEN e.event_name = 'submit_application'
            THEN e.event_time
        END) AS submit_application_time

    FROM app_events e

    JOIN users u
        ON e.user_id = u.user_id

    JOIN dim_date d
        ON e.event_time::date = d.date_gregorian

    WHERE d.jalali_year = 1405
      AND d.jalali_month IN (1, 2)

      AND e.event_name IN (
          'app_open',
          'view_loan_products',
          'start_application',
          'submit_application'
      )

    GROUP BY
        e.user_id,
        u.acquisition_channel
),

funnel_counts AS (

    SELECT
        week_number,
        acquisition_channel,

        COUNT(DISTINCT CASE
            WHEN app_open_time IS NOT NULL
            THEN user_id
        END) AS app_open_users,

        COUNT(DISTINCT CASE
            WHEN app_open_time IS NOT NULL
             AND view_products_time > app_open_time
            THEN user_id
        END) AS view_products_users,

        COUNT(DISTINCT CASE
            WHEN app_open_time IS NOT NULL
             AND view_products_time > app_open_time
             AND start_application_time > view_products_time
            THEN user_id
        END) AS start_application_users,

        COUNT(DISTINCT CASE
            WHEN app_open_time IS NOT NULL
             AND view_products_time > app_open_time
             AND start_application_time > view_products_time
             AND submit_application_time > start_application_time
            THEN user_id
        END) AS submit_application_users

    FROM user_funnel

    GROUP BY
        week_number,
        acquisition_channel
)

SELECT
    week_number,
    acquisition_channel,

    app_open_users,
    view_products_users,
    start_application_users,
    submit_application_users,

    ROUND(
        100.0 * view_products_users
        / NULLIF(app_open_users, 0),
        2
    ) AS app_open_to_view_pct,

    ROUND(
        100.0 * start_application_users
        / NULLIF(view_products_users, 0),
        2
    ) AS view_to_start_pct,

    ROUND(
        100.0 * submit_application_users
        / NULLIF(start_application_users, 0),
        2
    ) AS start_to_submit_pct

FROM funnel_counts

ORDER BY
    week_number,
    acquisition_channel;