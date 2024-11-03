## Walmart Sales Analysis
Link to the dataset: https://github.com/Princekrampah/WalmartSalesAnalysis/blob/master/WalmartSalesData.csv.csv

Project to expore Walmart Sales answering business questions related to product,sales and customers, with insights to some generic questions.

The major aim of this project is to gain insights into the sales data of Walmart to understand the different factors that affect sales of the different branches.

### Data
The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). 
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


### Process

1. **Data Wrangling:** This is the first step where data was inspected to make sure **NULL** values are identified and hence replaced.
> 1. Database built
> 2. Data was imported using MySQL Workbench's import wizard.

2. **Feature Engineering:** This helped generate new columns from existing ones.

> 1. Added a new column named `time_of_day` with values: Morning, Afternoon and Evening. This helped answer on which part of the day sales were made.

> 2. Added a new column named `day_name` with values: Mon, Tue, Wed, Thur, Fri. This helped answer on which the day sales were made.

> 3. Added a new column named `month_name` with values:Jan, Feb, Mar. This helped answer in which month sales were made.

3. **Exploratory Data Analysis (EDA):** Exploratory data analysis was done to answer the listed questions below and hence fulfill the objective of this project.

### Business Questions To Answer

#### Generic Questions

1. How many unique cities does the data have?
   > 3
2. In which city is each branch?
   >A  Yangon
     
   >B  Mandalay
   
   >C  Naypyitaw

#### Product

1. How many unique product lines does the data have?
   > 6
   
2. What is the most common payment method?
   > E-wallet
   
3. What is the most selling product line?
   > Electronic accessories
   
4. What is the total revenue by month?
   > January = 116291.87
   
   > February = 97219.37
   
   > March = 109455.51
   
5. What month had the largest COGS?
   > January
   
6. What product line had the largest revenue?
   > Food and beverages
   
7. What is the city with the largest revenue?
   > Naypyitaw
   
8. What product line had the largest VAT?
   > Home and lifestyle
   
9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
    
10. Which branch sold more products than average product sold?
    > C
    
11. What is the most common product line by gender?
    > Female > Fashion accessories
    
    > Male > Health and beauty


12. What is the average rating of each product line?
    > Home and lifestyle > 6.84
    
    > Electronic accessories > 6.92
    
    > Sports and travel > 6.92
    
    > Health and beauty > 7
    
    > Fashion accessories > 7.03
    
    > Food and beverages > 7.11


#### Sales

1. Number of sales made in each time of the day per weekday
   
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
   


2. Which of the customer types brings the most revenue?
   > Member 164223.44

3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
   > Naypyitaw
   
4. Which customer type pays the most in VAT?
   > Member

#### Customer

1. How many unique customer types does the data have?
   > 2 > Member, Normal
   
2. How many unique payment methods does the data have?
   > 3 > E-wallet, Cash, Credit Card
   
3. What is the most common customer type?
   > Member
   
4. Which customer type buys the most?
   > Member
   
5. What is the gender of most of the customers?
   > Female
   
6. What is the gender distribution per branch?
   
   |Branch| Gender | gender_count|
   | :----| :------| :-----------|
   |A     |Female  | 161         |
   |A     | Male   | 179         |
   |B     | Female | 162         |
   |B     | Male   | 170         |
   |C     | Female | 178         |   
   |C     | Male   | 150         |

   Gender distribution is almost same across branches, hence no such effect on sales.

7. Which time of the day do customers give most ratings?
   > Afternoon
   
8. Which time of the day do customers give most ratings per branch?
   > A > Afternoon

   > B > Morning

   > C > Night

   
9. Which day fo the week has the best avg ratings?
   > Monday

10. Which day of the week has the best average ratings per branch?
    > A > Friday

    > B > Monday

    > C > Friday


### Revenue And Profit Calculations

1. COGS = unitsPrice * quantity

2. VAT = 5% * COGS

   VAT is added to the COGS and this is what is billed to the customer.

3. total(gross_sales) = VAT + COGS

4. grossProfit(grossIncome) = total(gross_sales) - COGS 

**Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)

5. Gross Margin = gross income/total revenue

<u>**Example with the first row in our DB:**</u>

**Data given:**

- Unit Price = 45.79$
- Quantity = 7$

 COGS = 45.79 * 7 = 320.53 $

 VAT = 5% * COGS= 5%  320.53 = 16.0265 $

 total = VAT + COGS= 16.0265 + 320.53 = 336.5565$

 Gross Margin Percentage = gross income/total revenue = 16.0265/336.5565 = 0.047619(approx 4.7619%)

