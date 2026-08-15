# Data Notes

Things I find wrong and was challengin in the data for me.

## 1. `status` column in loan_applications

`loan_applications.status` had two different spellings for the same thing:
- `approved` and `APPROVED`
- `rejected` and `REJECTED`


I made everything uppercase with `.str.upper()`.

the switch from lowercase to uppercase happens. That's not random because I create a cross tab in `investigation.ipynb1 and it shows something changed in yout system.
around that time (probably a new system or a data migration).

> It wasn't very important in Ordibehsht jump analysis but I transfer it.

## 2. Some due dates didn't match anything

`installments.due_date` was in Jalali date, like `1405/02/30` and even in string format ;(.
To use it, I had to look up the matching regular (Gregorian) date in the
`dim_date` table. About 1,600 rows didn't find a match.

I checked which dates failed. They were all dates from
1406/01–1406/02  — dates that are just missing
from the `dim_date` table, it doesn't go that far yet.

These are all due dates in the future. They can't be
"defaulted" yet anyway, so leaving them out doesn't hurt the analysis.

> It wasn't also very important in Ordibehsht jump analysis so I didn't do anything to handle it ;).

but it caused some missing values which of course maks data ugly and scary.

## 3. repayments and installments

This is not very important just want to make this file longer.

I first assumed one installment could get paid in multiple pieces (like
paying half now, half later), so I used `groupby().sum()` to add up all
the payments for each installment.

I counted how many `repayments` rows exist per
installment. It's always exactly 1 or 0. And when there is a payment, the
amount paid always exactly matches the amount owed.

I removed the `groupby().sum()` step. A simple merge is
enough — if a repayment row exists for an installment, it's paid in full.


## 4. `Default` column

There's no `is_default` field anywhere. based on TASK instruction I assumed:

> An installment is "defaulted" if its due date was more than 30 days
> ago, and there's still no matching repayment.

98% of payments
happen within 30 days of the due date. So if it's been more than 30 days
with no payment, it's very unlikely to still show up — safe to call it
a default.

> I think it's better to have this column, I used it for the second part of the task.