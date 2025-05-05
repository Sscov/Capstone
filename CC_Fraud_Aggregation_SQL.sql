/*
Create a schema named finance, set finance as the default schema, and create tables with cc_data.csv and location_data.csv 

*/

CREATE TABLE IF NOT EXISTS cc_data(
idx Integer Primary KEY NOT NULL,
cc_num Integer not null,
trans_date date,
trans_time timestamp,
merchant Varchar(255),
category Varchar(255),
amt Integer,
first_name Varchar(255) not null,
last_name Varchar(255) not null,
gender Varchar(255),
street Varchar(255),
city Varchar(255),
state Varchar(255),
zip Varchar(255) not null,
lat Float,
long Float,
city_pop Integer,
job Varchar(255),
dob Date not null,
trans_num Varchar(255),
unix_time Float,
merch_lat Float,
merch_long Float,
is_fraud Integer
);


CREATE TABLE IF NOT EXISTS loaction_data(
idx Integer not null,
cc_num Integer not null,
lat Float,
long Float,
Foreign Key (idx) References cc_data(idx)
);


SELECT cd.trans_date, cd.trans_time 
FROM cc_data cd 

SELECT *
FROM loaction_data ld 

/*
4. Data Exploration with SQL:

Calculate the total number of transactions in the cc_data table

Identify the top 10 most frequent merchants in the cc_data table

Find the average transaction amount for each category of transactions in the cc_data table

Determine the number of fraudulent transactions and the percentage of total transactions that they represent

Join the cc_data and location_data tables to identify the latitude and longitude of each transaction

Identify the city with the highest population in the location_data table

Find the earliest and latest transaction dates in the cc_data table
 */


------------------------------------------------------------------------------------------------------------------------------------ 
-- Calculate the total number of transactions in the cc_data table

SELECT count(cd.trans_num) as Total_Number_Transactions
FROM cc_data cd 

------------------------------------------------------------------------------------------------------------------------------------ 
-- Identify the top 10 most frequent merchants in the cc_data table

SELECT merchant as Merchant,
count(cd.trans_num) as Total_Number_Transactions
FROM cc_data cd 
GROUP BY Merchant
order by Total_Number_Transactions Desc
Limit 10;
------------------------------------------------------------------------------------------------------------------------------------ 
-- Find the average transaction amount for each category of transactions in the cc_data table


SELECT category, 
(round(AVG(amt),2)) as Avg_Transaction_Amt
from cc_data 
GROUP BY category
order by Avg_Transaction_Amt Desc;

------------------------------------------------------------------------------------------------------------------------------------ 
--Determine the number of fraudulent transactions and the percentage of total transactions that they represent
--- 2252
-- 386,750

WITH Fraud_Count AS (
    SELECT
    SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END) AS Fraud_Transactions,
    COUNT(is_fraud) AS Total_Transactions
    FROM cc_data
)
SELECT
    (CAST(Fraud_Transactions AS REAL) / Total_Transactions) * 100.0 AS Fraud_Percentage
FROM
    Fraud_Count;

-- Less than 1% ---

------------------------------------------------------------------------------------------------------------------------------------ 
-- Join the cc_data and location_data tables to identify the latitude and longitude of each transaction

SELECT cd.trans_num,
ld.lat as Location_Data_lat,
ld.long as Location_Data_long
FROM cc_data cd 
LEFT JOIN loaction_data ld on cd.idx = ld.idx
WHERE ld.long IS NOT NULL AND ld.lat IS NOT NULL

------------------------------------------------------------------------------------------------------------------------------------ 
--Identify the city with the highest population in the location_data table

SELECT 
cd.city,
cd.state,
cd.city_pop as Population,
ld.long as Location_long,
ld.lat as Location_lat
FROM loaction_data ld  
LEFT JOIN cc_data cd on ld.idx = cd.idx 
WHERE ld.long IS NOT NULL AND ld.lat IS NOT NULL
GROUP BY cd.city
Order BY Population Desc;

-- 1st -- Houston, TX at 2,906,700

-- 2nd -- Brooklyn NY at 2,504,700
-- 3rd -- Los Angeles CA at 2,383,912

------------------------------------------------------------------------------------------------------------------------------------ 

-- Find the earliest and latest transaction dates in the cc_data table

SELECT 
min(cd.trans_date) as Earliest_Transaction,
max(cd.trans_date) as Latest_Transaction
FROM cc_data cd

-- earliest = 2019-01-01 -- 01-01-2019 
-- latest = 2020-12-06  -- 12-6-2020

------------------------------------------------------------------------------------------------------------------------------------ 

/*
5. Using Data Aggregation with SQL:

What is the total amount spent across all transactions in the cc_data table?

How many transactions occurred in each category in the cc_data table?

What is the average transaction amount for each gender in the cc_data table?

Which day of the week has the highest average transaction amount in the cc_data tab
*/

------------------------------------------------------------------------------------------------------------------------------------
-- What is the total amount spent across all transactions in the cc_data table?

SELECT Sum(cd.amt) as Total_Amt_Spent
FROM cc_data cd 

-- $27,402,136.52 Total Spent

------------------------------------------------------------------------------------------------------------------------------------
--How many transactions occurred in each category in the cc_data table?

SELECT category, 
count(amt) as Total_Count_Each_Category
from cc_data 
GROUP BY category
order by Total_Count_Each_Category Desc

--- Top Category -- gas_transport w/ -- 39,633

------------------------------------------------------------------------------------------------------------------------------------
--What is the average transaction amount for each gender in the cc_data table?

SELECT gender, 
(round(AVG(amt),2)) as Avg_Transaction_Amt_Gender
from cc_data 
GROUP BY gender
order by Avg_Transaction_Amt_Gender Desc


-- Males -- $71.15
-- Females -- $69.85

------------------------------------------------------------------------------------------------------------------------------------
--Which day of the week has the highest average transaction amount in the cc_data tab

SELECT
strftime('%w', cd.trans_date) AS Day_of_Week,
AVG(amt) AS Avg_Transaction_Amount
FROM cc_data as cd
GROUP BY Day_of_Week
ORDER BY Avg_Transaction_Amount DESC
LIMIT 1;


-- 1 = Monday --- Monday has the highest average transaction amount in the cc_data w/ --- $71.41
------------------------------------------------------------------------------------------------------------------------------------





