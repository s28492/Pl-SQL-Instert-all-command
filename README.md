# Pl-SQL-Instert-all-command


The PL/SQL procedure DML_INSERT_ALL is designed to dynamically generate and execute an INSERT ALL statement for any given table in an Oracle database. The purpose of this script is to replicate the entire content of a specified table into another, possibly new, table that has the same structure. Here's a breakdown of the script's components and functionality:

Procedure Declaration: The procedure DML_INSERT_ALL takes a single parameter v_nazwa_tabeli, which is the name of the table from which the data will be copied.

Variable Declarations:

v_insert_all: A string initialized to 'INSERT ALL', used as the beginning of the dynamic SQL statement.
AssocTab: A user-defined associative array type for storing VARCHAR values.
t_nazwy_kolumn and t_typy_danych: Associative arrays used to store column names and their respective data types from the input table.
v_insert_into: Constructs the 'INTO' part of the SQL statement, specifying the target table and columns.
v_values: Used to build the 'VALUES' clause of the SQL statement dynamically.
v_iterator and v_liczba_wierszy: Integers used for iterating through records and counting rows, respectively.
Dynamic SQL Execution:

Retrieves the column names and data types of the input table and stores them in t_nazwy_kolumn and t_typy_danych.
Constructs the INSERT INTO part of the statement by iterating over the column names.
Determines the total number of rows in the input table using a COUNT SQL query and executes this query dynamically.
Iteratively constructs and executes a select statement for each row in the table based on the unique identifier (assumed to be the first column), fetching each column's value.
Data Handling:

Depending on the data type of each column (e.g., VARCHAR2, DATE), the script formats the values appropriately, adding necessary SQL syntax (like quotes for strings or TO_DATE for dates).
Constructs the VALUES clause by appending each value from the row, properly formatted based on its data type.
Output:

Each constructed INSERT statement is printed using DBMS_OUTPUT.PUT_LINE, allowing the user to see the complete command for inserting data.
Finally, outputs SELECT * FROM DUAL; to allow the statement to run without errors in some SQL environments that require a terminating command.
Loops and Control Structures:

Uses loops to iterate through columns and rows of the table.
Conditional statements manage data type differences and ensure correct SQL syntax is generated.
This procedure is useful for creating backup copies of tables, migrating data between tables with identical schemas, or generating data fixtures for testing or development purposes. The script assumes that the table structure (schema) of the source and target tables are identical.