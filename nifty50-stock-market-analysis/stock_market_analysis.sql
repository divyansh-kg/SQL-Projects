--------------------------------------------------
-- Project: NIFTY 50 Stock Market Analysis Using SQL
--------------------------------------------------


/* Project Overview:
   This project analyzes 5 years of historical
   stock market data for selected NIFTY 50 companies
   using SQL. The analysis focuses on price behavior,
   return patterns, trading activity, volatility,
   and risk-adjusted performance metrics.
*/


--------------------------------------------------
-- Database Creation
--------------------------------------------------


CREATE DATABASE Stock_Market_Analysis;
USE Stock_Market_Analysis;


--------------------------------------------------
-- Importing Historical Stock Market Dataset
-- Imported using MSSQL Import Wizard
--------------------------------------------------


SELECT * FROM stock_data;

ALTER TABLE stock_data
ALTER COLUMN PctChange DECIMAL(10,2);

sp_help stock_data;


--------------------------------------------------
-- Section 1: Data Exploration
--------------------------------------------------

/* Objective 1: 
   Identify all stocks present in the dataset 
*/


SELECT DISTINCT Stock 
FROM stock_data;


/* Insight:
   The dataset contains 5 NIFTY 50 companies from
   different sectors for comparative market analysis. 
   The 5 companies are TCS, Reliance, Sun Pharma, SBI and 
   L&T.
*/

----------------------------------------------------------

/* Objective 2:
   Identify the overall historical date range covered
   in the dataset.
*/


SELECT MIN([DATE]) AS start_date,
	   MAX([DATE]) AS end_date
FROM stock_data;


/* Insight:
   The dataset contains 5 years of historical daily
   stock market data from 03 May 2021 to 30 April 2026.
*/

----------------------------------------------------------

/* Objective 3:
   Determine the total number of records present
   in the dataset.
*/


SELECT COUNT(*) AS total_records
FROM stock_data;


/* Insight:
   The dataset contains 6,200 historical daily
   trading records across 5 NIFTY 50 companies.
*/

----------------------------------------------------------

/* Objective 4:
   Determine the number of historical trading
   records available for each stock in the dataset.
*/


SELECT Stock,
	   COUNT(*) AS stock_count
FROM stock_data
GROUP BY Stock;


/* Insight:
   All 5 companies contain 1,240 historical
   trading records each, indicating consistent
   data coverage across the dataset.
*/

----------------------------------------------------------

/* Objective 5:
   Check whether the dataset contains any
   duplicate trading records.
*/


SELECT Stock,
       [Date],
       COUNT(*) AS duplicate_count
FROM stock_data
GROUP BY Stock,
         [Date]
HAVING COUNT(*) > 1;


/* Insight:
   No duplicate records were identified in the
   dataset, indicating good data consistency
   and integrity.
*/


--------------------------------------------------
-- Section 2: Price & Performance Analysis
--------------------------------------------------


/* Objective 6: 
   What is the average closing price of each stock? 
*/


SELECT Stock,
       ROUND(AVG([Close]), 2) AS avg_close
FROM stock_data
GROUP BY Stock
ORDER BY avg_close;


/* Insight:
   The selected companies exhibit significantly
   different average price levels, reflecting
   differences in market valuation and stock pricing.
   SBI recorded the lowest average closing price at 673.21
   whereas TCS recorded highest average closing price at 3478.38.
*/

----------------------------------------------------------

/* Objective 7:
   Identify the highest closing price recorded
   by each stock in the dataset.
*/


SELECT Stock,
       ROUND(MAX([Close]), 2) AS max_close
FROM stock_data
GROUP BY Stock
ORDER BY max_close DESC;


/* Insight:
   The selected companies recorded significantly
   different peak closing price levels during the
   5-year analysis period. TCS recorded the highest 
   closing price at 4553.75.
*/

----------------------------------------------------------

/* Objective 8:
   Identify the lowest closing price recorded
   by each stock in the dataset.
*/


SELECT Stock,
       ROUND(MIN([Close]), 2) AS min_close
FROM stock_data
GROUP BY Stock
ORDER BY min_close;


/* Insight:
   The selected companies experienced different
   minimum closing price levels during the 5-year
   period, reflecting varying market conditions
   and price behavior. SBI recorded the minimum
   closing price at 350.6.
*/

----------------------------------------------------------

/* Objective 9:
   Calculate the average daily percentage change
   for each stock in the dataset.
*/


SELECT Stock,
      CAST(AVG([PctChange]) AS DECIMAL(10,2)) 
      AS avg_pct_change
FROM stock_data
GROUP BY Stock
ORDER BY avg_pct_change DESC;


/* Insight:
   The selected companies exhibited different
   average daily return patterns during the
   analysis period. SBI recorded the highest
   average daily percentage change at 0.10%,
   while TCS recorded the lowest at -0.01%.
*/

----------------------------------------------------------

/* Objective 10:
   Identify the highest single-day percentage gain
   recorded by each stock during the analysis period.
*/


SELECT Stock,
      ROUND(MAX(PctChange), 2) AS max_pct_gain
FROM stock_data
GROUP BY Stock
ORDER BY max_pct_gain DESC;


/* Insight:
   The selected companies experienced different
   levels of extreme positive daily price movement
   during the 5-year analysis period. Sun Pharma
   recorded the highest single-day percentage gain
   among the selected stocks at 10.09%.
*/

--------------------------------------------------------

/* Objective 11:
   Identify the largest single-day percentage loss
   recorded by each stock during the analysis period.
*/


SELECT Stock,
       ROUND(MIN(PctChange), 2) AS max_loss
FROM stock_data
GROUP BY Stock
ORDER BY max_loss;


/* Insight:
   The selected companies experienced different
   levels of extreme negative daily price movement
   during the 5-year analysis period. SBI
   recorded the highest single-day percentage loss
   among the selected stocks at -14.40%.
*/

--------------------------------------------------------

/* Objective 12:
   Calculate the closing price range for each stock
   to identify which stock exhibited the widest
   price movement during the analysis period.
*/


SELECT Stock,
       ROUND(MAX([Close]) - MIN([Close]), 2) AS closing_price_range
FROM stock_data
GROUP BY Stock
ORDER BY closing_price_range DESC;


/* Insight:
   The selected companies exhibited different
   levels of price movement during the 5-year
   period, reflecting varying market volatility
   and trading behavior. L&T recorded the widest
   closing price range at 3080.50 points among
   the selected stocks.
*/


--------------------------------------------------
-- Section 3: Trading Activity Analysis
--------------------------------------------------


/* Objective 13:
   Calculate the average trading volume for each
   stock to identify the most actively traded
   company in the dataset.
*/


SELECT Stock,
       AVG(Volume) AS avg_trading_volume
FROM stock_data
GROUP BY Stock
ORDER BY avg_trading_volume DESC;


/* Insight:
   The selected companies exhibited different
   levels of trading activity during the analysis
   period, reflecting varying investor participation
   and market liquidity. SBI recorded the highest
   average trading volume among the selected stocks.
*/

--------------------------------------------------------

/* Objective 14:
   Identify the highest single-day trading volume
   recorded by each stock during the analysis period.
*/


SELECT Stock,
       CAST(MAX(Volume) AS BIGINT) AS max_volume
FROM stock_data
GROUP BY Stock
ORDER BY max_volume DESC;


/* Insight:
   The selected companies experienced different
   levels of peak trading activity during the
   analysis period, reflecting varying levels
   of market participation and investor interest.
   SBI recorded the highest single-day trading
   volume among the selected stocks.
*/

--------------------------------------------------------

/* Objective 15:
   Analyze the consistency of trading activity
   for each stock during the analysis period.
*/


SELECT Stock,
       ROUND(AVG(Volume), 2) AS avg_volume,
       ROUND(STDEV(Volume), 2) AS volume_std_dev
FROM stock_data
GROUP BY Stock
ORDER BY volume_std_dev DESC;


/* Insight:
   The selected companies exhibited varying
   levels of trading volume consistency during
   the analysis period. SBI showed the highest
   trading activity as well as the highest
   fluctuation in volume, indicating more
   volatile market participation compared to
   the other selected stocks.
*/

--------------------------------------------------------

/* Objective 16:
   Analyze the volatility of daily returns for
   each stock using the standard deviation of
   percentage changes during the analysis period.
*/


SELECT Stock,
       CAST(AVG([PctChange]) AS DECIMAL(10,2)) AS avg_daily_returns,
       ROUND(STDEV(PctChange), 2) AS daily_returns_volatility
FROM stock_data
GROUP BY Stock
ORDER BY daily_returns_volatility DESC;


/* Insight:
   The selected companies exhibited different
   levels of return volatility during the
   analysis period, reflecting varying levels
   of market risk and price fluctuation.
   SBI and L&T generated the highest average
   daily returns but also exhibited higher
   volatility, while Sun Pharma demonstrated
   relatively strong returns with comparatively
   lower volatility.
*/


--------------------------------------------------
-- Section 4: Advanced Comparative Insights
--------------------------------------------------


/* Objective 17:
   Evaluate the risk-adjusted return behavior
   of each stock by comparing average daily
   returns relative to return volatility.
*/


SELECT Stock,
         ROUND(AVG([PctChange]) / STDEV([PctChange]), 2) AS risk_adjusted_return
FROM stock_data
GROUP BY Stock
ORDER BY risk_adjusted_return DESC;


/* Insight:
   The selected companies exhibited different
   levels of risk-adjusted performance during
   the analysis period, reflecting variations
   in return efficiency relative to market risk.
   Sun Pharma and L&T demonstrated the strongest
   risk-adjusted return behavior among the
   selected stocks, while TCS recorded a
   negative risk-adjusted return ratio.
*/


--------------------------------------------------
--------------- End of Project -------------------
--------------------------------------------------