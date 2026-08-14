# Data Analyst Technical Task — "Vamland"

Welcome! This task simulates a real week at a lendtech company. **Vamland** is a
fictional installment-lending app: users sign up, apply for a loan, and (if
approved) repay it in monthly installments.

You have received a snapshot of Vamland's production database (see
`DATA_DICTIONARY.md`). Like any real production export, the data is **not
guaranteed to be clean** — part of your job is to decide what to trust.

## Ground rules

- **Time budget:** aim for ~6 focused hours. You have **5 calendar days** to
  submit. We do not expect perfection on every part — prioritize, and note what
  you would do with more time.
- **Tools:** anything goes — SQL client, Python, Excel, Metabase, and yes, AI
  assistants. **However:** the follow-up session is a live, 30-minute
  walkthrough where you will explain and modify your own work on the spot.
  Submit only work you fully understand.
- **Business definitions:**
  - *Defaulted installment* = no repayment received within **30 days** after
    its due date. Only judge installments whose due date is at least 30 days
    before the snapshot date (2026-07-15).
  - Financial reporting at Vamland is done in **Tomans** and on the
    **Jalali (Shamsi) calendar**. Business hours follow **Tehran time**.

## Deliverables

Submit a zip file or a git repository containing:

```
queries/           q1.sql … q4.sql  (runnable against the provided data)
analysis/          notebook (.ipynb) or scripts + rendered charts
dashboard/         screenshots or a Metabase export + METRICS.md
DATA_NOTES.md      data-quality issues you found and how you handled them
SUMMARY_FA.md      one-page executive summary in Persian
```

---

## Part 1 — SQL (4 queries)

Your queries must actually run against the provided PostgreSQL dump or SQLite
file. State any assumptions as comments in the SQL.

**Q1 — Acquisition funnel.** For **Farvardin and Ordibehesht 1405**, build a
weekly funnel of *unique users* through
`app_open → view_loan_products → start_application → submit_application`,
broken down by acquisition channel, with a step-to-step conversion rate.

**Q2 — Cohort retention.** For each **Jalali signup-month cohort**, what
percentage of users was active (≥1 app event) in months +1, +2, and +3 after
their signup month? Present it as a cohort table.

**Q3 — Installment aging report.** As of the snapshot date (2026-07-15),
bucket every already-due installment into: *paid on time*, *paid late*,
*overdue 1–29 days*, *overdue 30–59 days*, *overdue 60+ days*. Report count
and total value **in Tomans** per bucket.

**Q4 — Top customers.** The marketing team wants to send a gift to our **top
10 customers by total repaid amount** in 1405 so far. Produce the list: name,
acquisition channel, and total repaid **in Tomans**.

## Part 2 — Investigation (Python)

On 1405/03/02 the CEO sent this message to the analytics channel:

> «نرخ نکول اردیبهشت پریده بالا. چه خبره؟ واقعیه یا مشکل داده‌ست؟»
> ("The default rate jumped in Ordibehesht. What's going on? Is it real or a
> data problem?")

Investigate in a Python notebook (pandas + matplotlib/plotly):

1. Is the jump real? Quantify it.
2. What is driving it? Support your root cause with evidence and rule out at
   least one alternative explanation.
3. What do you recommend the business do?

We grade the **reasoning chain**, not just the conclusion. Show your dead ends.

## Part 3 — KPI dashboard

Design a dashboard the Vamland leadership team would check every morning.

- 5–7 KPIs / charts covering acquisition, lending volume, and portfolio health.
- Build it in **Metabase** if you can (screenshots are fine; a free local
  Metabase + the Postgres dump works well). Otherwise, mock it up with any
  tool and include the SQL behind each card.
- In `dashboard/METRICS.md`, define each metric **precisely** (formula,
  filters, calendar, currency) and justify why you chose it.

## Part 4 — Executive summary (Persian)

`SUMMARY_FA.md`: a one-page summary of your findings for the CEO — a
non-technical reader. Persian, no jargon, lead with what matters, include the
one or two numbers that deserve attention and your recommendation.

---

*Questions about the task? Email us — asking good clarifying questions counts
in your favor, not against you.*
