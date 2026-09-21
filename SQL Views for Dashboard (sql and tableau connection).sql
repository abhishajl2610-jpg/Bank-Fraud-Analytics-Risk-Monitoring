-- Create Dashboard Summary View

USE bank_fraud_analytics;

CREATE OR REPLACE VIEW vw_dashboard_summary AS
SELECT
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    COUNT(*) - SUM(Is_Fraud) AS genuine_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions;

SELECT * FROM vw_dashboard_summary;
-- --------------------------------------------------------------------

-- Fraud by Transaction Type View

CREATE OR REPLACE VIEW vw_fraud_by_transaction_type AS
SELECT
    Transaction_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Type;

SELECT *
FROM vw_fraud_by_transaction_type
ORDER BY fraud_rate_percentage DESC;
-- ----------------------------------------------------------------------

-- Fraud by Time of Day View
CREATE OR REPLACE VIEW vw_fraud_by_time AS
SELECT
    Time_of_Day,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Time_of_Day;

SELECT *
FROM vw_fraud_by_time
ORDER BY fraud_rate_percentage DESC;
-- -----------------------------------------------------------------------

-- Fraud by Device Type View
CREATE OR REPLACE VIEW vw_fraud_by_device AS
SELECT
    Device_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Device_Type;

SELECT *
FROM vw_fraud_by_device
ORDER BY fraud_rate_percentage DESC;
-- -------------------------------------------------------------

-- Risk-Level View
CREATE OR REPLACE VIEW vw_fraud_by_risk_level AS
SELECT
    Risk_Level,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Risk_Level;

SELECT *
FROM vw_fraud_by_risk_level
ORDER BY fraud_rate_percentage DESC;
-- ------------------------------------------------------------------

-- Monthly Fraud Trend View
CREATE OR REPLACE VIEW vw_monthly_fraud_trend AS
SELECT
    YEAR(Transaction_Date) AS transaction_year,
    MONTH(Transaction_Date) AS transaction_month,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY
    YEAR(Transaction_Date),
    MONTH(Transaction_Date);
    
SELECT *
FROM vw_monthly_fraud_trend
ORDER BY transaction_year, transaction_month;
-- ---------------------------------------------------------------------

-- Top Fraud-Risk Segment View
CREATE OR REPLACE VIEW vw_top_fraud_risk_segments AS
SELECT
    Time_of_Day,
    Device_Type,
    Transaction_Size,
    Risk_Level,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY
    Time_of_Day,
    Device_Type,
    Transaction_Size,
    Risk_Level;
    
SELECT *
FROM vw_top_fraud_risk_segments
ORDER BY fraud_rate_percentage DESC
LIMIT 10;
-- -----------------------------------------------------------

-- Checking that the views were created
SHOW FULL TABLES
WHERE Table_type = 'VIEW';