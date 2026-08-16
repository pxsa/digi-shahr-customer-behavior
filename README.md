# Digishar Technical Task — Vamland

<div align="center">
  <img src="img/digishahr.jpg" alt="Digishar" />
</div>

This repo is my submission for the Digishar data analyst technical task.

The task is based on a fictional lending app called **Vamland**. I got a
snapshot of their database and had to dig into it — write some SQL, investigate
a weird spike the "CEO" noticed, build a dashboard, and write a summary in
Persian.

You can find the original task description in [`TASK_EN.md`](./TASK_EN.md).

## Content

```
queries/        SQL queries (q1–q4), runs against the provided data
analysis/       Python notebook with the investigation + charts
dashboard/      dashboard screenshots + METRICS.md
DATA_NOTES.md   data problems I found, and how I dealt with them
SUMMARY_FA.md   one-page summary for the CEO, in Persian
```

## Task checklist

### Part 1 — SQL
- [X] Q1 — Weekly acquisition funnel (Farvardin & Ordibehesht 1405), by channel
- [X] Q2 — Cohort retention table (by signup month)
- [X] Q3 — Installment aging report (paid on time / late / overdue buckets)
- [X] Q4 — Top 10 customers by total repaid amount

### Part 2 — Investigation (Python)
- [X] Is the "default rate jump" in Ordibehesht real? Quantify it
- [X] Find the root cause, with evidence
- [X] Rule out at least one alternative explanation
- [X] Recommendation for the business

### Part 3 — KPI Dashboard
- [X] 5–7 KPIs covering acquisition, lending volume, and portfolio health
- [X] Dashboard built (Metabase or mockup) + screenshots
- [ ] `dashboard/METRICS.md` — every metric defined precisely

### Part 4 — Executive Summary
- [X] `SUMMARY_FA.md` — one page, Persian, no jargon, for a non-technical reader

### General
- [X] `DATA_NOTES.md` — data issues found + how they were handled
- [X] All SQL/code actually runs against the provided data

## How to run this

1. Load the data (Postgres dump or SQLite file — both work).
2. Open `analysis/investigation.ipynb` and update the DB connection string.
3. Run the SQL files in `queries/` against the same database.

## Notes

This was a ~6 hour task with a 3-day deadline, it takes more than 15 hours ;(
