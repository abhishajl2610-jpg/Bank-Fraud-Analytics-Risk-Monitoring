create database bank_fraud_analytics;
use bank_fraud_analytics;
CREATE TABLE transactions (
    Customer_ID TEXT,
    Customer_Name TEXT,
    Gender TEXT,
    Age INT,
    State TEXT,
    City TEXT,
    Bank_Branch TEXT,
    Account_Type TEXT,
    Transaction_ID TEXT,
    Transaction_Date DATETIME,
    Transaction_Time TEXT,
    Transaction_Amount DOUBLE,
    Merchant_ID TEXT,
    Transaction_Type TEXT,
    Merchant_Category TEXT,
    Account_Balance DOUBLE,
    Transaction_Device TEXT,
    Transaction_Location TEXT,
    Device_Type TEXT,
    Is_Fraud INT,
    Transaction_Currency TEXT,
    Customer_Contact TEXT,
    Transaction_Description TEXT,
    Customer_Email TEXT,
    Hour INT,
    Age_Group TEXT,
    Day_Name TEXT,
    month_name TEXT,
    Transaction_Size TEXT,
    Balance TEXT,
    Time_of_Day TEXT,
    Balance_Utilization DOUBLE,
    Risk_Score INT,
    Risk_Level TEXT
);

DESCRIBE transactions;

USE bank_fraud_analytics;

SELECT COUNT(*) AS total_rows
FROM transactions;

SELECT *
FROM transactions
LIMIT 10;

SELECT COUNT(*) AS total_transactions
FROM transactions;

SELECT COUNT(DISTINCT Transaction_ID) AS unique_transactions
FROM transactions;

SELECT
    Transaction_ID,
    COUNT(*) AS occurrence_count
FROM transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

SELECT
    Customer_ID,
    Customer_Name,
    Transaction_ID,
    Transaction_Date,
    Transaction_Time,
    Transaction_Amount,
    Merchant_ID,
    Transaction_Type,
    Merchant_Category,
    Account_Balance,
    Transaction_Device,
    Transaction_Location,
    Device_Type,
    Is_Fraud,
    Customer_Contact,
    Transaction_Description,
    Customer_Email
FROM transactions
WHERE Transaction_ID = 'b16e585d-31a8-4324-96e5-32f4c3d22cde';

SELECT
    COUNT(*) AS duplicate_transaction_ids
FROM (
    SELECT Transaction_ID
    FROM transactions
    GROUP BY Transaction_ID
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    COUNT(*) AS total_rows,
    SUM(Customer_ID IS NULL) AS missing_customer_id,
    SUM(Customer_Name IS NULL) AS missing_customer_name,
    SUM(Gender IS NULL) AS missing_gender,
    SUM(Age IS NULL) AS missing_age,
    SUM(State IS NULL) AS missing_state,
    SUM(City IS NULL) AS missing_city,
    SUM(Transaction_ID IS NULL) AS missing_transaction_id,
    SUM(Transaction_Amount IS NULL) AS missing_transaction_amount,
    SUM(Account_Balance IS NULL) AS missing_account_balance,
    SUM(Is_Fraud IS NULL) AS missing_is_fraud
FROM transactions;

SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY Is_Fraud;

SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY Is_Fraud;

-- Which transaction types have the most fraud?
SELECT
    Transaction_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Type
ORDER BY fraud_rate_percentage DESC;

-- Which states have the most fraud?
SELECT
    State,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY State
ORDER BY fraud_rate_percentage DESC;

-- Which merchant categories have the highest fraud rate?
SELECT
    Merchant_Category,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Merchant_Category
ORDER BY fraud_rate_percentage DESC;

-- Which transaction devices are associated with higher fraud rates?
SELECT
    Transaction_Device,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Device
ORDER BY fraud_rate_percentage DESC;

-- Are fraudulent transactions more common during particular times of day?
SELECT
    Time_of_Day,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Time_of_Day
ORDER BY fraud_rate_percentage DESC;

SELECT
    Hour,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Hour
ORDER BY fraud_rate_percentage DESC;

-- Which account types have higher fraud rates?
SELECT
    Account_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Account_Type
ORDER BY fraud_rate_percentage DESC;

-- Are fraudulent transactions generally larger in value?
SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Transaction_Amount), 2) AS average_amount,
    ROUND(MIN(Transaction_Amount), 2) AS minimum_amount,
    ROUND(MAX(Transaction_Amount), 2) AS maximum_amount
FROM transactions
GROUP BY Is_Fraud;

-- fraud by transaction size
 SELECT
    Transaction_Size,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Size
ORDER BY fraud_rate_percentage DESC;

-- Does account balance differ between fraudulent and non-fraudulent transactions?
SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Account_Balance), 2) AS average_balance,
    ROUND(MIN(Account_Balance), 2) AS minimum_balance,
    ROUND(MAX(Account_Balance), 2) AS maximum_balance
FROM transactions
GROUP BY Is_Fraud;

-- Balance Utilization
 SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Balance_Utilization), 2) AS average_utilization,
    ROUND(MIN(Balance_Utilization), 2) AS minimum_utilization,
    ROUND(MAX(Balance_Utilization), 2) AS maximum_utilization
FROM transactions
GROUP BY Is_Fraud;

-- Risk Score vs Fraud
SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Risk_Score), 2) AS average_risk_score,
    MIN(Risk_Score) AS minimum_risk_score,
    MAX(Risk_Score) AS maximum_risk_score
FROM transactions
GROUP BY Is_Fraud;

-- Risk Level vs actual fraud
SELECT
    Risk_Level,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Risk_Level
ORDER BY fraud_rate_percentage DESC;

-- Does fraud rate differ between genders?
SELECT
    Gender,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Gender
ORDER BY fraud_rate_percentage DESC;

-- age groups
 SELECT
    Age_Group,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Age_Group
ORDER BY fraud_rate_percentage DESC;

-- device type
 SELECT
    Device_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Device_Type
ORDER BY fraud_rate_percentage DESC;

-- transaction currency
SELECT
    Transaction_Currency,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Currency
ORDER BY fraud_rate_percentage DESC;

-- fraud by day of the week
SELECT
    Day_Name,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Day_Name
ORDER BY fraud_rate_percentage DESC;

-- transaction description
 SELECT
    Transaction_Description,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Description
ORDER BY fraud_rate_percentage DESC;

-- fraud by month
SELECT
    month_name,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY month_name
ORDER BY fraud_rate_percentage DESC;

-- Late Night + Mobile 
SELECT
    Time_of_Day,
    Device_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
WHERE Time_of_Day = 'Late Night'
GROUP BY Time_of_Day, Device_Type
ORDER BY fraud_rate_percentage DESC;

-- transaction size
 SELECT
    Time_of_Day,
    Device_Type,
    Transaction_Size,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
WHERE Time_of_Day = 'Late Night'
  AND Device_Type = 'Mobile'
GROUP BY
    Time_of_Day,
    Device_Type,
    Transaction_Size
ORDER BY fraud_rate_percentage DESC;

-- Risk_Level
 SELECT
    Risk_Level,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
WHERE Time_of_Day = 'Late Night'
  AND Device_Type = 'Mobile'
  AND Transaction_Size = 'Very High'
GROUP BY Risk_Level
ORDER BY fraud_rate_percentage DESC;

-- --------------------------------------------------------------
-- Dashboard
 SELECT
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    COUNT(*) - SUM(Is_Fraud) AS genuine_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions;

-- Fraud vs Genuine
 SELECT
    Is_Fraud,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY Is_Fraud
ORDER BY Is_Fraud;

-- Fraud by transaction type
SELECT
    Transaction_Type,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Type
ORDER BY fraud_rate_percentage DESC;

-- Fraud by state
SELECT
    State,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY State
ORDER BY fraud_rate_percentage DESC;

-- Fraud by merchant category
SELECT
    Merchant_Category,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Merchant_Category
ORDER BY fraud_rate_percentage DESC;

-- Fraud by transaction device
SELECT
    Transaction_Device,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Transaction_Device
ORDER BY fraud_rate_percentage DESC;

-- Fraud by time of day
SELECT
    Time_of_Day,
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
GROUP BY Time_of_Day
ORDER BY fraud_rate_percentage DESC;

-- combined risk segment
SELECT
    COUNT(*) AS total_transactions,
    SUM(Is_Fraud) AS fraud_transactions,
    COUNT(*) - SUM(Is_Fraud) AS genuine_transactions,
    ROUND(
        SUM(Is_Fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percentage
FROM transactions
WHERE Time_of_Day = 'Late Night'
  AND Device_Type = 'Mobile'
  AND Transaction_Size = 'Very High';