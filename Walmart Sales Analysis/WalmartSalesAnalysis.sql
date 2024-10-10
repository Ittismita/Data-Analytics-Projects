CREATE DATABASE IF NOT EXISTS WALMART;
SELECT * FROM Walmart.`walmartsalesdata.csv`;

-- Adding relevant features------------------------------------------------------
-- " time_of_day " column 
SELECT Time, CASE 
				WHEN Time BETWEEN  '00:00:00' AND '11:59:00' THEN "Morning" 
				WHEN Time BETWEEN '12:00:00' AND '16:00:00' THEN "Afternoon"
				ELSE "Night"
				END AS time_of_day
FROM Walmart.`walmartsalesdata.csv`;

ALTER TABLE Walmart.`walmartsalesdata.csv` ADD COLUMN time_of_day VARCHAR(20);
UPDATE Walmart.`walmartsalesdata.csv`
SET time_of_day=(
	CASE 
		WHEN Time BETWEEN  '00:00:00' AND '11:59:00' THEN "Morning" 
		WHEN Time BETWEEN '12:00:00' AND '16:00:00' THEN "Afternoon"
		ELSE "Night"
		END
	
);

-- "month" column
SELECT Date, MONTHNAME(Date)
FROM Walmart.`walmartsalesdata.csv`;

ALTER TABLE Walmart.`walmartsalesdata.csv` ADD COLUMN month_name VARCHAR(20);
UPDATE Walmart.`walmartsalesdata.csv`
SET month_name=MONTHNAME(Date);

-- "day_name" column
SELECT Date, DAYNAME(Date)
FROM Walmart.`walmartsalesdata.csv`;

ALTER TABLE Walmart.`walmartsalesdata.csv` ADD COLUMN day_name VARCHAR(20);
UPDATE Walmart.`walmartsalesdata.csv`
SET day_name=DAYNAME(Date);

-- EDA---------------------------------------------------------------------------
-- Generic Questions-------------------------------------------------------------
-- 1. How many unique cities in the dataset ?
SELECT COUNT(DISTINCT City) AS Unique_cities
FROM Walmart.`walmartsalesdata.csv`;

-- 2.In which city is each branch?
SELECT DISTINCT Branch, City 
FROM Walmart.`walmartsalesdata.csv`;

-- Product related Questions-----------------------------------------------------
-- 3.How many unique product lines does the data have?
SELECT COUNT(DISTINCT `Product line`)
FROM Walmart.`walmartsalesdata.csv`;

-- 4. What is the most common payment method?
SELECT Payment,COUNT(*) as Frequency
FROM Walmart.`walmartsalesdata.csv`
GROUP BY PAYMENT
ORDER BY Frequency DESC
LIMIT 1;

-- 5.What is the most selling product line?
SELECT `Product line`,SUM(Quantity) as total_sale
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY total_sale DESC
LIMIT 1;

-- 6.What is the total revenue by month?
SELECT month_name, ROUND(SUM(Total),2) as total_revenue
FROM Walmart.`walmartsalesdata.csv`
GROUP BY month_name;

-- 7. What month had the largest COGS?
SELECT month_name, SUM(cogs) as Largest_COGS
FROM Walmart.`walmartsalesdata.csv`
GROUP BY month_name
ORDER BY Largest_COGS DESC
LIMIT 1;

-- 8. What product line had the largest revenue?
SELECT `Product line`, SUM(Total) AS largest_revenue_by_product
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Product Line`
ORDER BY largest_revenue_by_product DESC
LIMIT 1;

-- 9. What is the City with the largest revenue?
SELECT City, SUM(Total) AS largest_revenue_by_city
FROM Walmart.`walmartsalesdata.csv`
GROUP BY City
ORDER BY largest_revenue_by_city DESC
LIMIT 1;

-- 10. What product line had the largest VAT?
SELECT `Product line`, AVG(`Tax 5%`) as largest_VAT
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY largest_VAT DESC
LIMIT 1;

-- 11. Categorising products as good or bad on the basis of their average sales
SELECT AVG(Quantity) as avg_sales FROM Walmart.`walmartsalesdata.csv`; -- 5.51

SELECT `Product line`,AVG(quantity) as avg_sales_by_product
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Product line`;

SELECT `Product line`,AVG(quantity) as avg_sales, IF(AVG(quantity)>(SELECT AVG(Quantity) FROM Walmart.`walmartsalesdata.csv`),"Good","Bad") as remark
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Product line`;

-- 12. Which Branch sold more than average products sold?
SELECT AVG(Quantity) as avg_sales FROM Walmart.`walmartsalesdata.csv`; -- 5.51

SELECT Branch,AVG(quantity) as avg_sales_by_branch
FROM Walmart.`walmartsalesdata.csv`
GROUP BY Branch;

SELECT Branch,AVG(Quantity) as avg_sales_by_branch
FROM Walmart.`walmartsalesdata.csv`
GROUP BY Branch
HAVING AVG(Quantity) > (SELECT AVG(Quantity) FROM Walmart.`walmartsalesdata.csv`);

-- 13. What is the most common product line by gender?
SELECT Gender,`Product line`, COUNT(`Product line`) as num
FROM Walmart.`walmartsalesdata.csv`
GROUP BY Gender,`Product line`
ORDER BY Gender,num desc;

-- 14. What is the average rating of each product line?
SELECT `Product line`, ROUND(AVG(Rating),2) as avg_rating_by_productLine
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY avg_rating_by_productLine;

-- Sales Based Questions------------------------------------------------------
-- 15. Number of sales made in each time of the day per weekday
SELECT day_name,time_of_day, COUNT(*) as total_sales_day_wise
FROM Walmart.`walmartsalesdata.csv`
GROUP BY day_name, time_of_day
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),time_of_day;

-- 16. Which of the customer types brings the most revenue?
SELECT `Customer type`, ROUND(SUM(Total),2) as revenue
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY revenue DESC;

-- 17. Which city has the largest tax percent/VAT(Value Added Tax)?
SELECT City,ROUND(AVG(`Tax 5%`),2) as avg_VAT
FROM Walmart.`walmartsalesdata.csv`
GROUP BY City 
ORDER BY avg_VAT DESC
LIMIT 1;

-- 18. Which customer type pays the most VAT?
SELECT `Customer type`, ROUND(AVG(`Tax 5%`),2) as avg_VAT
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY avg_VAT DESC
LIMIT 1;

-- Customer Based Questions------------------------------------------------
-- 19. How many unique customer types does the data have?
SELECT DISTINCT `Customer type` as customer_type
FROM Walmart.`walmartsalesdata.csv`;

-- 20. How many unique payment methods does the data have?
SELECT DISTINCT Payment as payment_method
FROM Walmart.`walmartsalesdata.csv`;

-- 21. What is the most common customer type?
SELECT `Customer type`as most_common_customer_type,COUNT(*) as no 
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY no DESC
LIMIT 1;

-- 22. Which customer type buys the most?
SELECT `Customer type`as most_buying_customer,SUM(Quantity) as no_of_buys 
FROM Walmart.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY no_of_buys DESC
LIMIT 1;

-- 23. What is the gender of most of the customers?
SELECT Gender as most_common_gender,COUNT(*) as no 
FROM Walmart.`walmartsalesdata.csv`
GROUP BY Gender
ORDER BY no DESC
LIMIT 1;

-- 24. What is the gender distribution per branch?-- almost same across branches hence no such effect on sales
SELECT Branch,Gender,COUNT(Gender) as gender_count 
FROM Walmart.`walmartsalesdata.csv`
GROUP BY Branch,Gender
ORDER BY Branch;

-- 25. Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(Rating) as avg_rating
FROM Walmart.`walmartsalesdata.csv`
GROUP BY time_of_day;

-- 26. Which time of the day do customers give most ratings per branch?
SELECT Branch, time_of_day, avg_rating as best_avg_rating
FROM(
	SELECT Branch, time_of_day, ROUND(AVG(Rating),2) as avg_rating, 
		   RANK() OVER(PARTITION BY Branch ORDER BY AVG(Rating) desc) AS rnk
	FROM Walmart.`walmartsalesdata.csv`
	GROUP BY Branch, time_of_day 
)ranked_data
WHERE rnk=1;

-- 27. Which day of the week has the best avg ratings?
SELECT day_name, ROUND(AVG(Rating),2) as best_avg_rating
FROM Walmart.`walmartsalesdata.csv`
GROUP BY day_name
ORDER BY best_avg_rating desc
LIMIT 1;

-- 28. Which day of the week has the best average ratings per branch?
SELECT Branch, day_name, avg_rating as best_avg_rating
FROM(
	SELECT Branch, day_name, ROUND(AVG(Rating),2) as avg_rating, 
		   RANK() OVER(PARTITION BY Branch ORDER BY AVG(Rating) desc) AS rnk
	FROM Walmart.`walmartsalesdata.csv`
	GROUP BY Branch, day_name 
)ranked_data
WHERE rnk=1;










       




