# Vamland — Data Dictionary

Export snapshot taken on **2026-07-15**. All timestamps in this export are stored in **UTC**.

Per Vamland's data-governance policy, direct identifiers are **pseudonymized**
in analyst exports: names are reduced to display names, and emails/phones are
masked. Email domains are preserved for domain-level analytics. Analytical
fields (amounts, dates, events) are untouched.

The data is provided in three equivalent formats — use whichever you prefer:

- `vamland_postgres.sql` — load into PostgreSQL: `psql -d vamland -f vamland_postgres.sql`
- `vamland.sqlite` — a ready-to-query SQLite database
- `csv/` — one CSV per table

## Tables

### `users`
| column | type | description |
|---|---|---|
| user_id | int | primary key |
| full_name | text | display name (pseudonymized: first name + last-name initial) |
| email | text | masked local part; domain preserved (e.g. `re***@gmail.com`) |
| phone | text | masked (e.g. `0912***0425`) |
| city | text | |
| acquisition_channel | text | marketing channel the user came from |
| signup_at | timestamp | registration time |

### `loan_applications`
| column | type | description |
|---|---|---|
| application_id | int | primary key |
| user_id | int | FK → users |
| created_at | timestamp | when the application was submitted |
| status | text | `pending` / `approved` / `rejected` |
| requested_amount | bigint | requested loan amount (Toman) |
| n_installments | int | number of monthly installments (approved loans only) |
| approved_at | timestamp | approval time (approved loans only) |

### `installments`
| column | type | description |
|---|---|---|
| installment_id | int | primary key |
| application_id | int | FK → loan_applications |
| installment_no | int | 1..n within the loan |
| due_date | text | installment due date |
| amount | bigint | installment amount |

### `repayments`
| column | type | description |
|---|---|---|
| repayment_id | int | primary key |
| installment_id | int | FK → installments |
| paid_at | timestamp | when payment was received |
| amount | bigint | paid amount |
| payment_method | text | `card` / `wallet` / `auto_debit` |

### `app_events`
| column | type | description |
|---|---|---|
| event_id | bigint | primary key |
| user_id | int | FK → users |
| session_id | text | client session identifier |
| event_name | text | `app_open`, `view_loan_products`, `start_application`, `submit_application`, `view_wallet`, `view_installments` |
| event_time | timestamp | client event time |
| platform | text | `android` / `ios` / `web` |

### `dim_date`
Calendar dimension table, one row per Gregorian day (2025-01-01 → 2027-03-20).

| column | type | description |
|---|---|---|
| date_gregorian | date | primary key |
| date_jalali | text | `YYYY/MM/DD` (Jalali / Shamsi) |
| jalali_year | int | |
| jalali_month | int | 1–12 |
| jalali_month_name | text | Persian month name |
| day_of_week | text | English weekday name |
