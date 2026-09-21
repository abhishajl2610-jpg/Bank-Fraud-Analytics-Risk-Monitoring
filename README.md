# Data-Driven Bank Fraud Analytics and Risk Monitoring

## Overview
An end-to-end analytics project on 200,000 banking transactions to find
fraud patterns and support risk monitoring. It covers data cleaning, feature
engineering, exploratory analysis, SQL analysis in MySQL, a rule-based risk
score and an interactive Tableau dashboard.

<img width="800" alt="Bank Fraud Analytics and Risk Monitoring" src="https://github.com/user-attachments/assets/a451a5bc-2f6c-41d8-9c0e-10bf9cd4dfdb" />

## Dataset
- Bank Fraud Analytics Dataset (source: Dynamic Duniya)
- 200,000 transactions, 24 original columns
- Target: `Is_Fraud` (1 = fraud, 0 = genuine)
- 10,088 fraudulent transactions (5.04%), so the data is imbalanced and
  fraud **rates** were used instead of raw counts for comparisons
- Transactions cover January 2025

## Workflow
1. **Data cleaning**: filled missing text fields with "Unknown", checked duplicates and invalid values (age, amount, balance, fraud label)
2. **Data quality check**: found one repeated Transaction ID, investigated it and found the two records differed in transaction type and contact, so it was flagged and not deleted
3. **Feature engineering**: Hour, Age Group, Day Name, Month Name, Transaction Size, Balance category, Time of Day, Balance Utilization, Risk Score, Risk Level
4. **Privacy**: removed customer name, contact and email from the analytical dataset
5. **Exploratory analysis** in Python (pandas, NumPy, Matplotlib)
6. **SQL analysis** in MySQL: aggregations, fraud-rate calculations, subqueries, multi-factor segment analysis and 7 reporting views
7. **Dashboard** in Tableau with KPI cards, charts and filters

## Rule-Based Risk Score
A cumulative score built from analyst-defined rules. It is **not** a machine
learning model.

| Condition | Points |
|---|---|
| Very High transaction size | +30 |
| High transaction size | +20 |
| Late Night transaction | +20 |
| Very High account balance | +15 |
| Balance utilisation above 2 | +35 |

Low Risk: 0-20, Medium Risk: 21-50, High Risk: above 50

| Risk Level | Transactions | Fraud | Fraud Rate |
|---|---|---|---|
| Low Risk | 101,589 | 3,435 | 3.38% |
| Medium Risk | 54,676 | 3,147 | 5.76% |
| High Risk | 43,735 | 3,506 | 8.02% |

## Key Insights
- Overall fraud rate is 5.04% (10,088 of 200,000)
- **Late Night** transactions have a 13.01% fraud rate, against about 2% in the morning, afternoon and evening
- **Mobile** has the highest device fraud rate (7.33%), and ATM the lowest (3.23%)
- **Transfer** has the highest transaction-type fraud rate (5.90%), followed by Withdrawal (5.25%)
- **Electronics** has the highest merchant-category fraud rate (6.05%)
- Fraud rate rises with risk level: 3.38% to 5.76% to 8.02%

## Dashboard
- KPIs: total transactions, fraud transactions, fraud rate, high-risk transactions
- Fraud rate by transaction type, device type, risk level, merchant category, state and time of day
- Filters: transaction date, transaction type, account type, risk level, device type

## Limitations
- The risk score is rule-based, with weights chosen by the analyst and not learned from data
- No machine learning model in this version
- The data covers one month, so it cannot show long-term trends
- Correlation and fraud-rate differences do not prove causation

## Future Scope
Machine learning fraud prediction, real-time monitoring, customer behaviour
profiling, anomaly detection and automated alerts.

## Tools Used
Python (pandas, NumPy, Matplotlib), MySQL, Tableau Public

## How to Run
1. Install the libraries:
   `pip install pandas numpy matplotlib openpyxl mysql-connector-python`
2. Run the scripts in order: cleaning, feature engineering, then the analysis scripts
3. To load the data into MySQL: create the database and `transactions` table using the SQL file, open the import script, fill in your own MySQL details and run it
4. Open the Tableau workbook in Tableau Public or Tableau Desktop

Note: database credentials are not included in this repository.
