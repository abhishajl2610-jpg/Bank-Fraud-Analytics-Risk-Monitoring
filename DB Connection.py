import pandas as pd
import mysql.connector
from pathlib import Path


# Project folder
BASE_DIR = Path(__file__).resolve().parent

# Final feature-engineered CSV
file_path = BASE_DIR / "Bank_Fraud_Feature_Engineered (Final).csv"

print("File being loaded:", file_path)
print("File exists:", file_path.exists())


connection = None
cursor = None
total_rows = 0

try:
    # Check whether the CSV exists
    if not file_path.exists():
        raise FileNotFoundError(
            f"CSV file not found: {file_path}"
        )

    # MySQL connection
    connection = mysql.connector.connect(
        host="________",
        user="________",
        password="________",
        database="____________"
    )

    cursor = connection.cursor()

    print("MySQL connection established successfully.")

    # SQL Insert Query
    insert_query = """
    INSERT INTO transactions (
        Customer_ID, Gender, Age, State, City, Bank_Branch,
        Account_Type, Transaction_ID, Transaction_Date, Transaction_Time,
        Transaction_Amount, Merchant_ID, Transaction_Type, Merchant_Category,
        Account_Balance, Transaction_Device, Transaction_Location, Device_Type,
        Is_Fraud, Transaction_Currency, Transaction_Description,
        Hour, Age_Group, Day_Name, month_name, Transaction_Size,
        Balance, Time_of_Day, Balance_Utilization, Risk_Score, Risk_Level
    )
    VALUES (
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
    )
    """

    # Read CSV in chunks
    for chunk in pd.read_csv(file_path, chunksize=1000):

        # Convert pandas missing values to None
        # for MySQL
        chunk = chunk.where(pd.notnull(chunk), None)

        data = [
            tuple(row)
            for row in chunk.itertuples(
                index=False,
                name=None
            )
        ]

        cursor.executemany(insert_query, data)

        connection.commit()

        total_rows += len(chunk)

        print(f"{total_rows} rows imported")

    print("\nImport completed successfully!")
    print("Total rows imported:", total_rows)


except FileNotFoundError as e:

    print("\nFile Error:")
    print(e)


except mysql.connector.Error as e:

    print("\nMySQL Database Error:")
    print(e)

    # Rollback any incomplete transaction
    if connection is not None:
        connection.rollback()


except Exception as e:

    print("\nUnexpected Error:")
    print(e)

    # Rollback any incomplete transaction
    if connection is not None:
        connection.rollback()


finally:

    # Close cursor
    if cursor is not None:
        cursor.close()
        print("Database cursor closed.")

    # Close connection
    if connection is not None and connection.is_connected():
        connection.close()
        print("MySQL connection closed.")

    print("Database import process finished.")