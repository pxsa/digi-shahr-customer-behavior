WITH top_users AS
(    select
        u.user_id,
        SUM(r.amount) AS total_repaid_amount
    --     u.full_name,
    --     l.application_id,
    --     i.installment_id,
    
    from repayments r
    JOIN installments i
        ON i.installment_id = r.installment_id
    JOIN loan_applications l
        ON l.application_id = i.application_id
    JOIN users u
        ON u.user_id = l.user_id
    JOIN dim_date d
        ON d.date_gregorian = r.paid_at::date
    
    WHERE d.jalali_year = 1405
    
    GROUP BY u.user_id
    ORDER BY total_repaid_amount DESC
    LIMIT 10
)
SELECT
    u.full_name,
    u.acquisition_channel,
    t.total_repaid_amount
FROM users u
JOIN top_users t
    ON t.user_id = u.user_id;