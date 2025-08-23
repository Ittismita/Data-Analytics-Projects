-- CREATE DATABASE db_churn;
USE db_churn;

SELECT * FROM Customer_Data;

-- Data Exploration
-- Customer Profile Demographics

--Unique Customers - 6418
SELECT COUNT(DISTINCT Customer_ID) FROM Customer_Data;

-- 1. Churn Rate across age groups
-- Max and Min age in the data
SELECT MAX(Age) as max_Age,MIN(Age) as min_Age FROM Customer_Data;

-- As our goal is dashboarding, we will use decade binning, which may show some underpopulated bins if data is skewed
WITH age_range_table AS(
	SELECT Customer_ID,Age,Customer_Status, CASE 
					WHEN Age BETWEEN 18 AND 24 THEN '18-24'
					WHEN Age BETWEEN 25 AND 34 THEN '25-34'
					WHEN Age BETWEEN 35 AND 44 THEN '35-44'
					WHEN Age BETWEEN 45 AND 54 THEN '45-54'
					WHEN Age BETWEEN 55 AND 64 THEN '55-64'
					WHEN Age BETWEEN 65 AND 74 THEN '65-74'
					WHEN Age BETWEEN 75 AND 85 THEN '75-85'
				END AS Age_range
    FROM Customer_Data
	WHERE Customer_Status IN ('Stayed','Churned')
)

SELECT Age_range,
	SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned_count,
    SUM(CASE WHEN Customer_Status='Stayed' THEN 1 ELSE 0 END) AS stayed_count,
    COUNT(*) AS total_customers,
	(SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*1.0)*100/COUNT(*) AS churn_rate
FROM age_range_table
GROUP BY Age_range
ORDER BY churn_rate DESC;
-- Majority of customers who churned were in the age group 75-85

-- 2. Does Gender play a role in churn likelihood? 
SELECT Gender, COUNT(Gender) as #, 
ROUND(COUNT(Gender)*100.0/(SELECT COUNT(*) FROM Customer_Data),2) as perc_distribution, 
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) as churn_rate,
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Customer_Status='Churned') as churn_dist
FROM Customer_Data
GROUP BY Gender;
-- 63% female, 37% male- percentage distribution across the dataset
-- Both genders show almost similar churn rate, so we cannot say gender plays a role in churn likelihood


-- 3. Which states have highest churn percentages?
-- Top 5 states where we have our customers
SELECT TOP 5 State, COUNT(State) AS #, COUNT(State)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_distribution
FROM Customer_Data
GROUP BY State
ORDER BY perc_distribution desc;
-- Largest number or percentage of customers are from Uttar Pradesh

-- Top 5 states with highest churn percentage
SELECT TOP 5 State, COUNT(State) AS #, COUNT(State)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_distribution,
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*1.0*100/COUNT(*) as churn_rate
FROM Customer_Data
GROUP BY State
ORDER BY churn_rate desc;
-- Highest churn percentage is of Jammu and Kashmir

--Both the above top 5s do not match, rather those with lower % distributions showed higher churn rate

-- 4. Does marital status influence churn rates?
SELECT Married, COUNT(Married) AS #, COUNT(Married)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_distribution,
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*1.0*100/COUNT(*) as churn_rate,
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Customer_Status='Churned') as churn_dist
FROM Customer_Data
GROUP BY Married;
-- 50% each - percentage distribution
-- Both show nearly equal churn rate, so we can say that marital status does not influence churn rate



-- Tenure and Engagement
-- 5. How does tenure in months correlate with churn?(eg. do new customers churn faster?)
SELECT MAX(Tenure_in_Months) AS max_tenure, MIN(Tenure_in_Months) AS min_tenure
FROM Customer_Data;

-- For dashboarding purposes will segment the tenure into following categories
WITH tenure_segment AS(
	SELECT Customer_ID,Tenure_in_Months,Customer_Status, CASE
	                      WHEN Tenure_in_Months BETWEEN 0 AND 6 THEN 'New (0-6)'
						  WHEN Tenure_in_Months BETWEEN 7 AND 12 THEN 'Early Loyal (7-12)'
						  WHEN Tenure_in_Months BETWEEN 13 AND 24 THEN 'Established (13-24)'
						  WHEN Tenure_in_Months BETWEEN 25 AND 36 THEN 'Long-term (25-36)'
						END AS tenure_group
	FROM Customer_Data)

SELECT tenure_group,COUNT(tenure_group)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_distribution,
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) as churned,
SUM(CASE WHEN Customer_Status='Stayed' THEN 1 ELSE 0 END) as stayed,
SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*1.0*100/COUNT(*) as churn_rate
FROM tenure_segment
GROUP BY tenure_group
ORDER BY churn_rate DESC;
-- No direct correlation between churn rate and tenure, highest churn rate were found in customers who had a tenure between 7 and 12 months suggesting customers are more likely to leave right after their first

-- 6. What is the average number of referrals for churned vs. retained customers?
SELECT Customer_Status, AVG(Number_of_Referrals) as avg_referrals
FROM Customer_Data
WHERE Customer_Status IN ('Stayed', 'Churned')
GROUP BY Customer_Status;
-- Both 7

-- 7. Are customers with value deals less likely to churn?
SELECT SUM(CASE WHEN Value_Deal IS NOT NULL THEN 1 ELSE 0 END)*1.0*100/COUNT(*) AS perc_customer_with_value_deal,
	   SUM(CASE WHEN Value_Deal IS NULL THEN 1 ELSE 0 END)*1.0*100/COUNT(*) AS perc_customer_withOUT_value_deal
FROM Customer_Data
WHERE Customer_Status = 'Churned';
-- Among the churned customers, those without value deal were contributed more

SELECT Customer_Status,
       SUM(CASE WHEN Value_Deal IS NULL THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Value_Deal IS NULL) perc_cust_WITHOUT_value_deal,
       SUM(CASE WHEN Value_Deal IS NOT NULL THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Value_Deal IS NOT NULL) perc_cust_WITH_value_deal
FROM Customer_Data
GROUP BY Customer_Status;
-- Yes, customers with value deals are comparatively less likely to churn.



-- Service Usage & Add-ons
-- 8. Do customers with multiple lines churn more than single-line users?
SELECT Multiple_Lines, COUNT(*) #, COUNT(*)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_dist 
FROM Customer_Data
GROUP BY Multiple_Lines;

SELECT Multiple_Lines, COUNT(*) #,SUM(CASE WHEN Phone_Service='No' THEN 1 ELSE 0 END) as Phone_service 
FROM Customer_Data
GROUP BY Multiple_Lines;

-- We have ~10% null values in this column because these 10% customers do not have phone service
-- Hence considering these null values as not applicable
-- Hence filtering out people who had phone service

SELECT Multiple_Lines, ROUND(SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate,
                       SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Customer_Status='Churned') churn_dist
FROM Customer_Data
WHERE Phone_Service='Yes'
GROUP BY Multiple_Lines;
-- Both single-line and multiple-line users contribute almost equally to overall churn, since their churn distribution is similar. 
-- However, the churn rate is slightly higher among customers with multiple lines, suggesting they are marginally more at risk of churning compared to single-line users.

-- churn rate - out of all customers in a particular group how many churned - risk analysis - Likelihood of churn 
-- churn dist - out of all churned customers, which category contributed more - impact analysis - Total churn burden
-- If there is difference in group sizes these two metrics should be considered
-- Because a group may be smaller but has higher churn rate within, but may contribute less to the overall churn distribution across the data
-- Smaller groups, higher churn rate within that group,but lower contribution to overall churn dist
-- In such a case we might look to improve those who contributed majorly to the churn dist.
-- But if we are targetting segment wise improvements then churn rate would be considered.

-- 9. Which internet type has highest churn?
SELECT Internet_Type,ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM Customer_Data),2) as perc_dist
FROM Customer_Data
GROUP BY Internet_Type;
-- We have ~22% null values in this column, which again is a result of customers not having internet service
-- checking that
SELECT Internet_Type,COUNT(*) #, SUM(CASE WHEN Internet_Service='No' THEN 1 ELSE 0 END) Internet_Service
FROM Customer_Data
GROUP BY Internet_Type;

-- Hence considering the null values as Not available
SELECT Internet_Type, SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) as churn_rate
FROM Customer_Data
WHERE Internet_Type IS NOT NULL
GROUP BY Internet_Type
ORDER BY churn_rate DESC;
-- Those who had Fiber optics as internet type churned the most.

-- Checking if the nulls in other services(Premium_Support, Device_Protection_Plan etc.) columns are a result of customers with no internet service
SELECT Premium_Support,Device_Protection_Plan,Online_Security,Online_Backup,Streaming_TV,Streaming_Music,Streaming_Movies,Unlimited_Data	   
FROM Customer_Data
WHERE Internet_Service='No' AND
      (Premium_Support IS NOT NULL OR
	  Device_Protection_Plan IS NOT NULL OR
	  Online_Security IS NOT NULL OR
	  Online_Backup IS NOT NULL OR
	  Streaming_TV IS NOT NULL OR
	  Streaming_Music IS NOT NULL OR
	  Streaming_Movies IS NOT NULL OR
	  Unlimited_Data IS NOT NULL)
-- No records were retuned, so yes other services columns have nulls because that particular customer doesnt have internet service.
-- Hence, considering these nulls as Not Applicable/Available

-- 10. Are customers with premium support or device protection plans less likely to churn?
SELECT 
   'Premium_Support' AS Service_type,Premium_Support AS Has_Service,
   COUNT(*) AS Total_Customers,
   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS Churn_Rate
FROM Customer_Data
WHERE Internet_Service='Yes'
GROUP BY Premium_Support

UNION ALL

SELECT 
   'Device_Protection_Plan' AS Service_type, Device_Protection_Plan AS Has_Service,
   COUNT(*) AS Total_Customers,
   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS churn_rate
FROM Customer_Data
WHERE Internet_Service='Yes'
GROUP BY Device_Protection_Plan;
-- Yes, customers with such services are less likely to churn, so we can that these services are valuable and hence helpful in customer retention/joining

-- 11. Which streaming services are most correlated to churn?
SELECT 'Streaming TV' AS Streaming_Services, Streaming_TV AS Has_Service,
       COUNT(*) #,
	   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) as churn_rate
FROM Customer_Data
WHERE Internet_Service='Yes'
GROUP BY Streaming_TV

UNION ALL

SELECT 'Streaming Movies' AS Streaming_Services, Streaming_Movies AS Has_Service,
       COUNT(*) #,
	   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) as churn_rate
FROM Customer_Data
WHERE Internet_Service='Yes'
GROUP BY Streaming_Movies

UNION ALL

SELECT 'Streaming Music' AS Streaming_Services, Streaming_Music AS Has_Service,
       COUNT(*) #,
	   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) as churn_rate
FROM Customer_Data
WHERE Internet_Service='Yes'
GROUP BY Streaming_Music;
-- Customers without these services churned relatively more than those who had those services, so these services helped in retention to certain extent
-- The service most strongly associated with lower churn is Streaming Music, followed closely by Streaming TV and Streaming Movies. 
-- This suggests that offering streaming add-ons may help in customer retention.

-- 12. Is unlimited data linked to lower churn rates?
SELECT Unlimited_Data, COUNT(*) #, SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) churn_rate
FROM Customer_Data
WHERE Internet_Service='Yes'
GROUP BY Unlimited_Data;
-- Yes unlimited data is related to comparatively lower churn rates. Suggesting, offering this as a service may helpin retention/joining.


-- Billings & Payments
-- 13. What is churn rate across contract types?
-- Perc Distribution of Contract
SELECT Contract, COUNT(Contract) AS #, COUNT(Contract)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_distribution,
		SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) #nulls
FROM Customer_Data
GROUP BY Contract
ORDER BY perc_distribution desc;
-- Majority of the contracts are Month-to-month based
-- Least are One Year based
-- no nulls
SELECT Contract, COUNT(*) #, SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) churn_rate,
       SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Customer_Status='Churned') churn_dist
FROM Customer_Data
GROUP BY Contract;
-- Month to Month contract types have the highest churn rate, also contributes the most among the customers who have churned
-- Suggesting, shorter terms, easier for customers to leave,without bearing any charges.
-- Contributing heavily towards churn distribution,month to month contract types inflates churn rate too, bringing down the overall customerlifetime value
-- Providing additional benefits to customers upon transitioning from month-to-month to yearly subscriptions
-- Two year contracts, lowest churn rates, suggesting longer commitment,may be at comparatively lower prices, reduced freedom to leave
-- Getting more customers to choose longer contracts will make revenue more steady and predictable, and the business won’t lose money as often from people leaving.

-- 14. Do customers on paperless billing churn more than others?
SELECT Paperless_Billing, COUNT(*) #, SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) churn_rate,
       SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Customer_Status='Churned') churn_dist
FROM Customer_Data
GROUP BY Paperless_Billing;
-- Yes customers on paperless billing churn more than others
-- Earlier, we found that the highest churn rate was of the age group 75-85, suggesting Older customers or those less tech-savvy may feel forced into a system they don’t trust or cannot easily use.
-- Struggle with digital platforms, billing apps, or online payments. Relying on paperless billing -> may get delayed bills/might miss the bills -> missed payments -> service-cutoffs-> involuntary churn
-- Segmented billing strategy, flagging customers aged 70+ who are on paperless billing -> monitoring their complaints, payment delays, and churn risk closely.

-- 15. How does churn vary by payment method?
-- Perc Distribution of Payment method opted by customers
SELECT Payment_Method, COUNT(Payment_Method) AS #, COUNT(Payment_Method)*100.0/(SELECT COUNT(*) FROM Customer_Data) as perc_distribution,
		SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) #nulls
FROM Customer_Data
GROUP BY Payment_Method;
--no nulls

SELECT Payment_Method, COUNT(*) #, SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) churn_rate,
       SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/(SELECT COUNT(*) FROM Customer_Data WHERE Customer_Status='Churned') churn_dist
FROM Customer_Data
GROUP BY Payment_Method;
-- Mailed check showed the highest churn rate but lowest churn distribution
-- A small group of people use this method, but within this small group most customers left or are most likely to churn
-- Indicating, for segmented targetting or improvement, Mailed check should be focused upon, 
-- encouraging switching to digital payments along withproper awareness and education on how to do so
-- While for overall improvement, Bank Withdrawal should be the area of focus, most churned customers use this method
-- If funds not available -> failed payment -> involuntary churn, trust issues
-- Advanced remainders for customers before payment date, auditing and monitoring repeated fail checks-> churn alerts 
-- Credit card payers are a “safe” customer base


-- Revenue & Financials
-- 16. How do monthly charges differ between churned vs. retained customers?
-- Number of negative values in each
SELECT MIN(Monthly_Charge),MAX(Monthly_Charge), SUM(CASE WHEN Monthly_Charge IS NULL THEN 1 ELSE 0 END) #nulls
FROM Customer_Data;

SELECT Customer_Status, SUM(CASE WHEN Monthly_Charge < 0 THEN 1 ELSE 0 END) #negative_values 
FROM Customer_Data
GROUP BY Customer_Status;
-- In telecom negative charges usually mean refunds, credits or promotions

SELECT Customer_ID,Monthly_Charge,Total_Refunds,Total_Charges
FROM Customer_Data
WHERE Monthly_Charge<0;
-- Upon checking we also have customers with negative values as monthly charge but non zero values as total refunds, suggesting data error or data not logged in


SELECT CASE WHEN Monthly_Charge<0 THEN 'Negative charge' ELSE Customer_Status END as group_type,COUNT(*) AS customer_count, AVG(Monthly_Charge) avg_monthly_charge
FROM Customer_Data
GROUP BY CASE WHEN Monthly_Charge<0 THEN 'Negative charge' ELSE Customer_Status END;
-- Higher-paying customers are more likely to churn, possibly due to price sensitivity or dissatisfaction with value-for-money
-- Lower-charged customers (Joined group) are new and less likely to churn yet

-- 17. Are higher total revenues associated with longer customer retention?
SELECT MIN(Total_Revenue),MAX(Total_Revenue), SUM(CASE WHEN Total_Revenue IS NULL THEN 1 ELSE 0 END) #nulls
FROM Customer_Data;

SELECT CASE WHEN Total_Revenue BETWEEN 20 AND 2400 THEN 'Very Low (20-2400)'
            WHEN Total_Revenue BETWEEN 2401 AND 4800 THEN 'Low (2401-4800)'
            WHEN Total_Revenue BETWEEN 4801 AND 7200 THEN 'Medium (4801-7200)'
            ELSE 'High (7201+)'
	   END AS revenue_category,
	   COUNT(*) #,
	   AVG(Tenure_in_Months) avg_tenure
FROM Customer_Data
GROUP BY CASE WHEN Total_Revenue BETWEEN 20 AND 2400 THEN 'Very Low (20-2400)'
            WHEN Total_Revenue BETWEEN 2401 AND 4800 THEN 'Low (2401-4800)'
            WHEN Total_Revenue BETWEEN 4801 AND 7200 THEN 'Medium (4801-7200)'
            ELSE 'High (7201+)'
	   END; 

-- 18. Do customers who received refunds have a higher churn rate?
SELECT CASE WHEN Total_Refunds>0 THEN 'Received_refund'
       ELSE 'Didnt_receive_refund' END AS Refund, 
	   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) churn_rate
FROM Customer_Data
GROUP BY CASE WHEN Total_Refunds>0 THEN 'Received_refund'
         ELSE 'Didnt_receive_refund' END ;
-- Yes ,customers who didnt receive a refund have higher churn rates
-- If customers face service issues but get no monetary relief, they may leave out of frustration
-- Customers who successfully claim refunds see the company as fair/responsive, reducing churn
-- Simplify and proactively manage refund policies to ensure customers feel compensated when issues occur 
-- timely credits or small refunds can reduce churn at a lower cost than losing customers, while targeted offers for high-risk segments can further improve retention. 

-- 19. How does extra data charge usage affect churn?
SELECT CASE WHEN Total_Extra_Data_Charges>0 THEN 'used_extra_data'
       ELSE 'Didnt_use_extra_data' END AS extra_data_usage, 
	   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) churn_rate
FROM Customer_Data
GROUP BY CASE WHEN Total_Extra_Data_Charges>0 THEN 'used_extra_data'
         ELSE 'Didnt_use_extra_data' END ;
-- Customers who used extra data are more likely to churn, suggesting frustration over unexpected/extra costs
-- Offering data add-on packs, transparent data usage alerts, or shifting these customers to higher data plans to reduce surprise charges.

-- 20. What proportion of long-distance heavy users churn vs. stay?
SELECT MIN(Total_Long_Distance_Charges),MAX(Total_Long_Distance_Charges)
FROM Customer_Data;

-- Suppose top 25% of the total long distance charges are the customers who are heavy users
WITH top25 AS(
   SELECT DISTINCT PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Total_Long_Distance_Charges) OVER() pc75 FROM Customer_Data)
SELECT pc75 FROM top25;

SELECT CASE WHEN Total_Long_Distance_Charges>=1182.91744995117 THEN 'Heavy'
            ELSE 'Normal'
	   END AS long_distance_usage_category,
	   SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*) prop_churned,
	   SUM(CASE WHEN Customer_Status='Stayed' THEN 1 ELSE 0 END)*100.0/COUNT(*) prop_stayed
FROM Customer_Data
WHERE Total_Long_Distance_Charges>0
GROUP BY CASE WHEN Total_Long_Distance_Charges>=1182.91744995117 THEN 'Heavy'
            ELSE 'Normal'
			END;
-- 12% of long distance heavy users churned while 87% stayed, suggesting
-- Heavy long-distance users are valuable customers. They are engaged and appear relatively loyal compared to lighter users.
-- Protect heavy users via retention strategies, study churned heavy users for risk signals


-- Churn - Specific
-- 21. What are the top churn categories?
SELECT Customer_Status,COUNT(Customer_Status) #, SUM(CASE WHEN Churn_Category IS NULL THEN 1 ELSE 0 END) #churn_category_nulls
FROM Customer_Data
GROUP BY Customer_Status;
-- 4686 nulls, because wherever customer_status is stayed or joined, there churned category is not present, quite obvious!

SELECT Churn_Category, COUNT(Churn_Category) #
FROM Customer_Data
WHERE Churn_Category IS NOT NULL
GROUP BY Churn_Category
ORDER BY # DESC;
-- Top 3 churn categories are Competitors, Attitude, Dissatisfaction
-- So, customers are maybe finding better alternatives, or are dissatisfied with the services or attitude of the company
-- Now, keeping up with ongoing trends in the market, introducing incentives serving customers better with minimum loss, being more customer focused addressing pain points well and early
-- Could help with better retention

-- 22. What are the most common churn reasons?
SELECT Churn_Reason, COUNT(Churn_Reason) #
FROM Customer_Data
WHERE Churn_Reason IS NOT NULL
GROUP BY Churn_Reason
ORDER BY # DESC;
-- Top 3 reasons were Competitors had better devices, made better offer and Attitude of support person
-- Aligning with earlier churn category

-- 23. Do churn reasons differ by state, age group, or contract type?
SELECT DISTINCT Churn_Reason FROM Customer_Data WHERE Churn_Reason IS NOT NULL;

SELECT *
FROM (
  SELECT State, Churn_Reason FROM Customer_Data WHERE Churn_Category IS NOT NULL) as source_table
PIVOT (Count(Churn_Reason)
       FOR Churn_Reason IN(
	    [Attitude of service provider],
		[Poor expertise of phone support],
		[Lack of self-service on Website],
		[Competitor offered more data],
		[Limited range of services],
		[Network reliability],
		[Don't know],
		[Competitor had better devices],
		[Lack of affordable download/upload speed],
		[Service dissatisfaction],
		[Poor expertise of online support],
		[Attitude of support person],
		[Moved],
		[Long distance charges],
		[Price too high],
		[Extra data charges],
		[Competitor made better offer],
		[Deceased],
		[Competitor offered higher download speeds],
		[Product dissatisfaction]
)) AS PivotTable
ORDER BY State;
-- Yes, churn reasons clearly differ by state.
-- Competition-driven churn dominates in states like Uttar Pradesh, Tamil Nadu, Karnataka, Gujarat (competitor offering more data, better devices).
-- Price-driven churn is extreme in Jammu & Kashmir (133 customers citing “Price too high”) and noticeable in Haryana/Maharashtra.
-- Service-driven churn stands out in Bihar and Tamil Nadu (high counts for “Attitude of support person”).
-- Network reliability issues are scattered but matter in Tamil Nadu, Haryana, and Kerala.

SELECT DISTINCT Contract FROM Customer_Data WHERE Churn_Reason IS NOT NULL;

SELECT *
FROM (
  SELECT Contract, Churn_Reason FROM Customer_Data WHERE Churn_Category IS NOT NULL) as source_table
PIVOT (Count(Contract)
       FOR Contract IN(
	    [Month-to-Month],
		[One Year],
		[Two Year]
)) AS PivotTable
ORDER BY Churn_Reason;
-- Longer contracts reduce churn volume significantly.
-- Month-to-Month churn = competitor offers/devices + service dissatisfaction (highly volatile).
-- One-Year churn = still competitor-led, but with stronger service-related churn.
-- Two-Year churn = rare, usually at renewal, triggered by competitor offers or product dissatisfaction.

-- 24. What percentage of churn is due to competitors vs. dissatisfaction?
SELECT SUM(CASE WHEN Churn_Category='Competitor' THEN 1 ELSE 0 END)*100.0/COUNT(*) perc_competitors,
	   SUM(CASE WHEN Churn_Category='Dissatisfaction' THEN 1 ELSE 0 END)*100.0/COUNT(*) perc_dissatisfaction
FROM Customer_Data
WHERE Customer_Status='Churned';
-- ~44% of churn is due to Competitors, while 17% is due to Dissatisfaction

-- 25. What's the average tenure at churn for each churn category?
SELECT Churn_Category, AVG(Tenure_in_Months) avg_tenure
FROM Customer_Data
WHERE Churn_Category IS NOT NULL
GROUP BY Churn_Category;

-- Perc Distribution of Customer status
SELECT Customer_Status, COUNT(Customer_Status) AS #, ROUND(COUNT(Customer_Status)*100.0/(SELECT COUNT(*) FROM Customer_Data),2) as perc_distribution
FROM Customer_Data
GROUP BY Customer_Status;
-- Newly joined - 6.40%
-- Stayed - 66.61%
-- Churned - 26.99%



-- Data Cleaning
-- Handling null values
-- Finding nulls in a Single column
SELECT COUNT(*)
FROM Customer_Data 
WHERE Value_Deal IS NULL;

-- Finding nulls in all columns
-- Using a reusable script

-- declare variables
DECLARE @table_name NVARCHAR(20)='Customer_Data';
DECLARE @schema_name NVARCHAR(20)='dbo';
DECLARE @sql NVARCHAR(MAX)='';

-- column expression
-- INFORMATION_SCHEMA.COLUMNS -- system view listing all columns in table
SELECT @sql=STRING_AGG(
				'SUM(CASE WHEN ['+COLUMN_NAME+'] IS NULL THEN 1 ELSE 0 END) AS ['+COLUMN_NAME+'_nulls]',
				', ')

FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME=@table_name
  AND TABLE_SCHEMA=@schema_name;

-- wrapping inside select, final sql statement
SET @sql = 'SELECT '+ @sql +'FROM ['+@schema_name+'].['+@table_name+'];'

-- PRINT @sql

-- sp_executesql - system procedure to execute sql contained in a variable
EXEC sp_executesql @sql;

SELECT COUNT(*) FROM Customer_Data;
-- Total rows - 6418

-- Filling nulls, creating a new table
SELECT 
  Customer_ID, Gender, Age, Married, State, Number_of_Referrals, Tenure_in_Months,
  ISNULL(Value_Deal, 'None') Value_Deal, Phone_Service,
  ISNULL(Multiple_Lines,'Not Applicable') Multiple_Lines, 
  Internet_Service, ISNULL(Internet_Type,'Not Applicable') Internet_Type,
  ISNULL(Online_Security,'Not Applicable') Online_Security,
  ISNULL(Online_Backup,'Not Applicable') Online_Backup,
  ISNULL(Device_Protection_Plan,'Not Applicable') Device_Protection_Plan,
  ISNULL(Premium_Support,'Not Applicable') Premium_Support,
  ISNULL(Streaming_TV,'Not Applicable') Streaming_TV,
  ISNULL(Streaming_Movies,'Not Applicable') Streaming_Movies,
  ISNULL(Streaming_Music,'Not Applicable') Streaming_Music,
  ISNULL(Unlimited_Data,'Not Applicable') Unlimited_Data,
  Contract, Paperless_Billing, Payment_Method, Monthly_Charge, Total_Charges,
  Total_Refunds, Total_Extra_Data_Charges,Total_Long_Distance_Charges,Total_Revenue,
  Customer_Status,ISNULL(Churn_Category,'Not Applicable') Churn_Category,
  ISNULL(Churn_Reason,'Not Applicable') Churn_Reason

INTO [db_churn].[dbo].[churn_data]
FROM [db_churn].[dbo].[Customer_Data];

-- Creating views
CREATE VIEW vw_churn_data AS (
	SELECT * FROM churn_data WHERE Customer_Status IN ('Stayed','Churned')
	)

CREATE VIEW vw_joining_data AS (
	SELECT * FROM churn_data WHERE Customer_Status IN ('Joined')
	)

