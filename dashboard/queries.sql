--------------------------------------
-- 1) Total Applications
SELECT
  count(*)
FROM
  loan_applications
--------------------------------------


--------------------------------------
--  2) Overdue Amount
SELECT
  sum(i.amount)
FROM
  installments i
  LEFT JOIN repayments r ON i.installment_id = r.installment_id
  JOIN dim_date d ON d.date_jalali = i.due_date
WHERE
  r.paid_at IS NULL
  AND d.date_gregorian < '2026-08-15';
--------------------------------------


--------------------------------------
--  3) Approval Rate
SELECT 
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loan_applications), 
        2
    ) AS approval_rate

	
FROM loan_applications l
WHERE status IN ('approved', 'APPROVED');
--------------------------------------


--------------------------------------
-- 4) Loan status
WITH
  normalized_status AS (
    SELECT
      CASE
        WHEN status = 'approved' THEN 'APPROVED'
        WHEN status = 'rejected' THEN 'REJECTED'
        ELSE status
      END AS status_good
    FROM
      loan_applications
  )
SELECT
  status_good,
  COUNT(*) AS COUNT
FROM
  normalized_status
GROUP BY
  status_good
--------------------------------------


--------------------------------------
--  5) Installment aging report (same as q3)
SELECT
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
--------------------------------------


--------------------------------------
-- 6) Total Repaid Amound
SELECT
  sum(repayments.amount)
FROM
  repayments


--------------------------------------
--  7) Repaid Amount per month
SELECT
  d.jalali_year,
  d.jalali_month_name,
  d.jalali_month,
  SUM(r.amount) AS paid_amount_per_month
FROM
  repayments r
  JOIN dim_date d ON r.paid_at::date = d.date_gregorian
GROUP BY
  d.jalali_year,
  d.jalali_month_name,
  d.jalali_month
ORDER BY
  d.jalali_year ASC,
  d.jalali_month
--------------------------------------


--------------------------------------
--  8) Overdue (1-29 days)
SELECT

    SUM(i.amount) AS total_amount

FROM installments i
JOIN dim_date d
    ON i.due_date = d.date_jalali
LEFT JOIN repayments r
    ON i.installment_id = r.installment_id

WHERE r.paid_at IS NULL AND DATE '2026-07-15' - d.date_gregorian BETWEEN 0 AND 29 AND d.date_gregorian <= DATE '2026-07-15'
--------------------------------------


--------------------------------------
-- 9) Overdue (30 - 59 days)
SELECT

    SUM(i.amount) AS total_amount

FROM installments i
JOIN dim_date d
    ON i.due_date = d.date_jalali
LEFT JOIN repayments r
    ON i.installment_id = r.installment_id

WHERE r.paid_at IS NULL AND DATE '2026-07-15' - d.date_gregorian BETWEEN 30 AND 59
--------------------------------------


--------------------------------------
-- 10) Overdue (+60 days)
SELECT

    SUM(i.amount) AS total_amount

FROM installments i
JOIN dim_date d
    ON i.due_date = d.date_jalali
LEFT JOIN repayments r
    ON i.installment_id = r.installment_id

WHERE r.paid_at IS NULL AND DATE '2026-07-15' - d.date_gregorian >= 60
--------------------------------------


