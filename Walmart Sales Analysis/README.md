## Walmart Sales Analysis: SQL-Based EDA with Tableau Dashboards
### Project Overview 
This project analyzes Walmart’s point-of-sale transactional data to uncover key sales trends, customer purchasing patterns, and product performance insights. Using SQL for exploratory data analysis and Tableau for visualization, the project demonstrates end-to-end analytical workflow — from data cleaning to insight communication — essential for retail business decision-making.

### Problem Statement 
Walmart aims to understand which branches, product lines, and customer segments contribute most to sales and profitability. The analysis seeks to answer questions like:
Which factors drive total revenue and gross income?
How do customer types and genders differ in spending patterns?
What times of day and days of the week record peak transactions?
How does branch performance vary across cities?


### Dataset
Source: [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). 

This dataset contains sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. 
The data contains 17 columns and 1000 rows:

| Column                  | Description                             | Data Type |
| :---------------------- | :-------------------------------------- | :---------|
| invoice_id              | Invoice of the sales made               | VARCHAR   |
| branch                  | Branch at which sales were made         | VARCHAR   |
| city                    | The location of the branch              | VARCHAR   |
| customer_type           | The type of the customer                | VARCHAR   |
| gender                  | Gender of the customer making purchase  | VARCHAR   |
| product_line            | Product line of the product solf        | VARCHAR   |
| unit_price              | The price of each product               | DECIMAL   |
| quantity                | The amount of the product sold          | INT       |
| VAT                     | The amount of tax on the purchase       | FLOAT     |
| total                   | The total cost of the purchase          | DECIMAL   |
| date                    | The date on which the purchase was made | DATE      |
| time                    | The time at which the purchase was made | TIMESTAMP |
| payment_method          | The total amount paid                   | DECIMAL   |
| cogs                    | Cost Of Goods sold                      | DECIMAL   |
| gross_margin_percentage | Gross margin percentage                 | FLOAT     |
| gross_income            | Gross Income                            | DECIMAL   |
| rating                  | Rating                                  | FLOAT     |


### Tools and skills used
| Category      | Tools / Technologies                              |
| ------------- | ------------------------------------------------- |
| Data Querying | SQL (Sub-queries, CTEs, Joins, Aggregations)      |
| Visualization | Tableau (Dashboarding, Filters, Storytelling)     |
| Data Cleaning | SQL CASE, COALESCE, TRIM, handling NULLs          |
| Analysis      | Descriptive Statistics, EDA, Sale drivers         |
| Communication | Executive summary, business storytelling          |


### Process
#### 1. Analytical Process
- Data Understanding & Profiling
- Reviewed schema, null counts, unique key distribution.
- Ensured data types match business logic (e.g., VAT derived from total * 0.05).
- Reviewed data quality through defining calculations like:
   - Revenue And Profit Calculations
       1. COGS = unitsPrice * quantity
       2. VAT = 5% * COGS
          - VAT is added to the COGS and this is what is billed to the customer.
       3. total(gross_sales) = VAT + COGS
       4. grossProfit(grossIncome) = total(gross_sales) - COGS 
          - **Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)
       5. Gross Margin = gross income/total revenue
          - <u>**Example with the first row in our DB:**</u>
            - **Data given:**
               - Unit Price = 45.79$
               - Quantity = 7$
               - COGS = 45.79 * 7 = 320.53 $
               - VAT = 5% * COGS= 5%  320.53 = 16.0265 $
               - total = VAT + COGS= 16.0265 + 320.53 = 336.5565$
               - Gross Margin Percentage = gross income/total revenue = 16.0265/336.5565 = 0.047619(approx 4.7619%)

#### 2. Data Cleaning
- Checked for missing or duplicate invoices.
- Corrected rounding mismatches in total = unit_price × quantity × (1 + VAT%).

#### 3. Feature Engineering
- Extracted time-based fields: time_of_day, day_name, month_name.
- Fetched each product line and added a column to those product line showing "Good", "Bad". Good if its greater than average sales.
- Derived KPIs: gross_profit_margin, sales_per_transaction.
  
#### 4. Exploratory Analysis via SQL
##### 🏙️ City & Branch
**Q:** How many unique cities does the data have?  
**A:** 3  

**Q:** In which city is each branch located?  
**A:** A → Yangon, B → Mandalay, C → Naypyitaw  

---

##### 🛍️ Product Analysis
**Q:** How many unique product lines exist?  
**A:** 6  

**Q:** What is the most common payment method?  
**A:** E-wallet  

**Q:** What is the most selling product line?  
**A:** Electronic Accessories  

**Q:** What is the total revenue by month?
**A:** 1. January = 116291.87
       2. February = 97219.37
       3. March = 109455.51
   
**Q:** What month had the largest COGS?
**A:** January
   
**Q:** Which product line generated the highest revenue?  
**A:** Food and Beverages  

**Q:** Which city generated the highest revenue?  
**A:** Naypyitaw  

**Q:** Which product line had the largest VAT?  
**A:** Home and Lifestyle  

**Q:** Which branch sold more products than average?  
**A:** Branch C  

**Q:** Most common product line by gender?  
**A:** Female → Fashion Accessories, Male → Health and Beauty

**Q:** Average rating of each product line?  
| Product Line | Avg Rating |
| :------------ | :----------- |
| Home & Lifestyle | 6.84 |
| Electronic Accessories | 6.92 |
| Sports & Travel | 6.92 |
| Health & Beauty | 7.00 |
| Fashion Accessories | 7.03 |
| Food & Beverages | 7.11 |

---
##### Sales

**Q:** Sales made in each time of the day per weekday
   
   | day_name                | time_of_day                             | total_sales_day_wise |
   | :---------------------- | :-------------------------------------- | :--------------------|
   | Monday                  | Afternoon                               | 48                   |
   | Monday                  | Morning                                 | 21                   |
   | Monday                  | Night                                   | 56                   |
   | Tuesday                 | Afternoon                               | 53                   |
   | Tuesday                 | Morning                                 | 36                   |
   | Tuesday                 | Night                                   | 69                   |
   | Wednesday               | Afternoon                               | 61                   |
   | Wednesday               | Morning                                 | 22                   |
   | Wednesday               | Night                                   | 60                   |
   | Thursday                | Afternoon                               | 49                   |
   | Thursday                | Morning                                 | 33                   |
   | Thursday                | Night                                   | 56                   |
   | Friday                  | Afternoon                               | 58                   |
   | Friday                  | Morning                                 | 29                   |
   | Friday                  | Night                                   | 52                   |
   | Saturday                | Afternoon                               | 55                   |
   | Saturday                | Morning                                 | 28                   |
   | Saturday                | Night                                   | 81                   |
   | Sunday                  | Afternoon                               | 53                   |
   | Sunday                  | Morning                                 | 22                   |
   | Sunday                  | Night                                   | 58                   |
   
**Q:** Which customer type brings the most revenue?  
**A:** Member → 164,223.44  

**Q:** Which city has the highest VAT?  
**A:** Naypyitaw  

**Q:** Which customer type pays the most VAT?  
**A:** Member

##### Customer Insights

**Q:** How many unique customer types?  
**A:** 2 (Member, Normal)  

**Q:** How many unique payment methods?  
**A:** 3 (E-wallet, Cash, Credit Card)  

**Q:** What is the most common customer type?  
**A:** Member  

**Q:** Which gender dominates purchases?  
**A:** Female  

**Q:** Gender distribution per branch? 
   |Branch| Gender | gender_count|
   | :----| :------| :-----------|
   |A     |Female  | 161         |
   |A     | Male   | 179         |
   |B     | Female | 162         |
   |B     | Male   | 170         |
   |C     | Female | 178         |   
   |C     | Male   | 150         |

**Q:** Which time of day sees the most ratings?  
**A:** Afternoon 
   
**Q:** Which time of the day do customers give most ratings per branch?
**A:** 1. A - Afternoon
       2. B - Morning
       3. C - Night

**Q:** Which day has the best average ratings?  
**A:** Monday  


**Q:** Which day of the week has the best average ratings per branch?
**A:** 1. A - Friday
       2. B - Monday
       3. C - Friday


#### 5. Visualization in Tableau
- Revenue by Product Line (Bar Chart)
- Daily Sales Trend (Time Series Line Chart)
- Branch Comparison by Gross Income (Tree Map)
- Gender vs. Rating Heatmap
- Payment Method Distribution (Pie Chart)
- Customer Type Segmentation Dashboard

### Key Insights Summary
- **Top-performing city:** Naypyitaw  
- **Top-selling product line:** Food & Beverages  
- **Most profitable customer type:** Members  
- **Most popular payment method:** E-wallet  
- **Peak sales period:** Afternoons and weekends  
- **Best-rated day:** Monday  
- **Gender impact:** Nearly balanced; no major influence on sales  
- **Branch outperformer:** Branch C shows higher product sales than average 






