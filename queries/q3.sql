SELECT
--     i.installment_id,
--     d.date_gregorian,
--     i.amount AS installment_amount,
--     r.paid_at,

    CASE
        WHEN r.paid_at IS NOT NULL
             AND r.paid_at <= d.date_gregorian
            THEN 'paid on time'

        WHEN r.paid_at IS NOT NULL
             AND r.paid_at > d.date_gregorian
            THEN 'paid late'

        WHEN r.paid_at IS NULL
             AND DATE '2026-07-15' - d.date_gregorian BETWEEN 0 AND 29
            THEN 'overdue 1-29 days'

        WHEN r.paid_at IS NULL
             AND DATE '2026-07-15' - d.date_gregorian BETWEEN 30 AND 59
            THEN 'overdue 30-59 days'

        WHEN r.paid_at IS NULL
             AND DATE '2026-07-15' - d.date_gregorian >= 60
            THEN 'overdue 60+ days'

    END AS bucket,
    COUNT(*) AS total_installment,
    SUM(i.amount) AS total_amount

FROM installments i
JOIN dim_date d
    ON i.due_date = d.date_jalali
LEFT JOIN repayments r
    ON i.installment_id = r.installment_id

WHERE d.date_gregorian <= DATE '2026-07-15'

GROUP BY bucket
ORDER BY total_installment;
