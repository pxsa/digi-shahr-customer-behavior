# Metabase Metrics



## Content

- [Summary Table](#summary-table)
- [Bucket Explanation](#bucket-explanation)


## Summary Table

| Metric                    | Formula                                            | Filters                                                    | Calendar             | Currency | Why I chose it                                                            |
| ------------------------- | -------------------------------------------------- | ---------------------------------------------------------- | -------------------- | -------- | ------------------------------------------------------------------------- |
| **Total Applications**    | `COUNT(*)`                                         | All loan applications                                      | No date filter       | —        | Shows how much demand we are getting.                                     |
| **Approval Rate**         | `Approved applications / Total applications × 100` | Status = `approved`                                        | No date filter       | —        | Shows how many applications turn into approved loans.                     |
| **Total Repaid Amount**   | `SUM(repayments.amount)`                           | All repayments                                             | No date filter       | Tomans  | Shows how much money has been collected from customers.                   |
| **Monthly Repaid Amount** | `SUM(repayments.amount)` grouped by month          | All repayments                                             | Jalali calendar      | Tomans  | Shows whether repayments are increasing or decreasing over time.          |
| **Overdue Amount**        | `SUM(installment.amount)`                          | Unpaid installments with due date before the snapshot date | Snapshot: 2026-07-15 | Tomans  | Shows the amount of money currently overdue.                              |
| **Installment Aging**     | `SUM(installment.amount)` by aging bucket          | Unpaid/paid installments due by 2026-07-15                 | Snapshot: 2026-07-15 | Tomans  | Shows whether overdue payments are recent or seriously late.              |
| **Loan Status**           | `COUNT(*)` by status                               | All loan applications                                      | No date filter       | —        | Gives a quick view of approved, rejected, and other application statuses. |


## Bucket Explanation

| Bucket                 | Definition                            |
| ---------------------- | ------------------------------------- |
| **Paid on time**       | Paid on or before the due date        |
| **Paid late**          | Paid after the due date               |
| **Overdue 1–29 days**  | Not paid and 1–29 days past due       |
| **Overdue 30–59 days** | Not paid and 30–59 days past due      |
| **Overdue 60+ days**   | Not paid and 60 or more days past due |


