# CUSTOMER CHURN ANALYSIS

## Scenario
Long-term success in the cutthroat corporate world of today depends on keeping consumers. One important method for comprehending and lowering this client loss is churn analysis. It involves looking at customer data to find trends and explanations for why customers leave. Businesses may identify which consumers are most likely to leave and learn about the causes influencing their choices by utilising machine learning and advanced data analytics. With this information, businesses may take proactive measures to increase client loyalty and satisfaction.

Churn analysis is useful for any company that values keeping customers, from retail and banking to healthcare and beyond. We will examine the strategies, resources, and best practices for enhancing customer loyalty and lowering churn while turning data into useful insights for long-term success.

## Task 
To create an ETL (Extract, Transform, Load) process in a database and further visualize insights using a Power BI dashboard. The goal is to:
- Analyse and visualize customer data at different levels.
- Identify areas for implementing marketing campaigns.
- Find a way to forecast upcoming churners.

## Process
![Pipeline](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Customer%20Churn%20Analysis/Pipeline.png)

### SQL-based Churn Exploration & Data Preparation
SQL file - https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Customer%20Churn%20Analysis/ChurnSQL.sql

In SQL Server: 
- Conducted data profiling to check unique customers, distribution of age, tenure, and revenue, while identifying anomalies (e.g., negative monthly charges, null service values).
- Built a dynamic SQL null-detection script to automatically quantify missing values across all columns.
- Segmented customers into meaningful categories:
  - Demographics: Age bands (18–24, 25–34, …), gender, marital status, states.
  - Tenure groups: New (0–6 months), Early Loyal (7–12), Established (13–24), Long-Term (25–36).
  - Service usage: Internet type, single vs. multiple lines, add-ons (Premium Support, Device Protection, Streaming, Unlimited Data).
  - Billing & payments: Contract length, paperless billing, payment method.
  - Financials: Monthly charges, refunds, extra data charges, long-distance usage.
- Designed dual churn metrics for robust insights:
  - Churn Rate (likelihood within a group).
  - Churn Distribution (group’s overall contribution to churn).
- Standardized data handling by filling nulls with “Not Applicable/None” and created a cleaned dataset (churn_data) along with two analysis-ready views (vw_churn_data, vw_joining_data).
  
Insights:
1. Churn Insights Across Demographics
   To evaluate how customer attributes influenced churn:
   - Age Segmentation: Customers were grouped into decades. The highest churn rate was observed among those aged 75–85, suggesting older customers are more vulnerable.
   - Gender & Marital Status: Both showed similar churn rates, indicating negligible impact.
   - Geographic Patterns: While the majority of customers were from Uttar Pradesh, the highest churn rate was seen in Jammu & Kashmir. This revealed that large customer bases and high churn risk do not always overlap.

2. Tenure & Engagement Analysis
   - Customers with 7–12 months of tenure displayed the highest churn likelihood, pointing to dissatisfaction after the first year.
   - Referrals: Average referrals were the same for churned and retained customers, showing no direct impact.
   - Value Deals: Customers with value deals churned significantly less, highlighting their importance as a retention strategy.

3. Service Usage & Add-ons
   The relationship between service adoption and churn was systematically examined:
   - Phone Services: Customers with multiple lines showed slightly higher churn rates than single-line users.
   - Internet Services: Fiber optic users exhibited the highest churn, signaling potential dissatisfaction with service quality or pricing.
   - Add-on Services: Premium support, device protection, and streaming services all reduced churn likelihood. Among them, streaming music had the strongest retention effect.
   - Unlimited Data: Customers with unlimited data plans churned less frequently, reinforcing the value of transparent and flexible offerings.

4. Billing & Payment Behaviors
   - Contract Types: Month-to-month contracts had the highest churn rate, while two-year contracts had the lowest. This reinforced the stabilizing effect of long-term commitments.
   - Paperless Billing: Customers on paperless billing churned more, particularly elderly customers who may struggle with digital platforms.
   - Payment Methods: Mailed check users had the highest churn rate, though they represented a small portion of the base. In contrast, bank withdrawal users contributed most to total churn, highlighting them as a high-priority segment for intervention.

5. Revenue & Financials
   - Monthly Charges: Higher-paying customers churned more frequently, suggesting price sensitivity or dissatisfaction with value-for-money.
   - Total Revenue vs. Retention: Higher lifetime revenues were associated with longer tenures, confirming that retained customers deliver higher value.
   - Refunds: Customers who received refunds churned less, underscoring the importance of responsive customer service and fair compensation.
   - Extra Data Charges: Customers incurring extra charges were more likely to churn, indicating frustration with unexpected costs.
   - Long-Distance Users: Heavy long-distance callers showed high loyalty, making them a key customer segment to protect.

6. Churn Categories & Reasons
   Further analysis of churn categories revealed:
   - Competitor-driven churn (44%) was the largest contributor, followed by dissatisfaction (17%) and negative interactions with support staff.
   - Regional breakdowns showed state-level variations: e.g., price-related churn in Jammu & Kashmir, and support-related churn in Bihar and Tamil Nadu.
   - Contract-based analysis revealed that month-to-month churn was heavily driven by competitor offers, whereas long-term contracts limited churn volume to renewal events.

### Dashboarding in Power BI - Customer Churn Analysis
Power BI Dashboard link - 

- Imported Data from SQL Server

- Transformations done:
  - Added new column in churn_data
    1. Churn_Status = if [Customer_Status] = “Churned” then 1 else 0
       Changed Churn Status data type to numbers
    2. Monthly_Charge_Category = if [Monthly_Charge] < 40 then “< 40” else if [Monthly_Charge] < 70 then “40-70” else if [Monthly_Charge] < 100 then “70-100” else “100+”
  
  - Created a New Table Reference for segmenting age into groups
    1. age_grouping = if [Age] < 25 then “18-24” else if [Age] < 35 then “25-34” else if [Age] < 45 then “35-44” else if [Age] < 55 then “45-54” else if [Age] < 65 then “55-64” else if [Age] < 75 then “65-74” else "75-85"
    2. Sorted the age groups for better viz. - sorted_AgeGroup = if [Age] < 25 then 1 else if [Age] < 35 then 2 else if [Age] < 45 then 3 else if [Age] < 55 then 4 else if [Age] < 65 then 5 else if [Age] < 75 then 6 else 7
    3. Changed data type of sorted_AgeGroup to Numbers
  
  - Created a new table reference for segmenting tenure into groups
    1. tenure_grouping = if [Tenure_in_Months] < 7 then “0-6 Months” else if [Tenure_in_Months] < 13 then “7-12 Months” else if [Tenure_in_Months] < 25 then “13-24 Months” else "25+ Months”
    2. sorted_TenureGroup = if [Tenure_in_Months] < 7 then 1 else if [Tenure_in_Months] < 13 then 2 else if [Tenure_in_Months] < 25 then 3 else 4
    3. Change data type of sorted_TenureGroup  to Numbers
  
  - Created a new table reference for services
    1. Unpivoted services columns
    2. Renamed Column – Attribute >> Services and Service_Status

- Created DAX Measures:
  1. Total Customers = Count(churn_data[Customer_ID])
  2. New Joiners = CALCULATE(COUNT(churn_data[Customer_ID]), churn_data[Customer_Status] = “Joined”)
  3. Total Churn = SUM(churn_data[Churn Status])
  4. Churn Rate = [Total Churn] / [Total Customers]

- Created Viz.
  1. SUMMARY PAGE:

     ![Summary Page](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Customer%20Churn%20Analysis/Summary%20Page.png)
     ![Summary Page with tooltip](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Customer%20Churn%20Analysis/Summary%20Page%20with%20tooltip.png)

     Components :
     - KPI Cards: Showcased total customers (6,418), churned customers (1,732), churn rate (26.99%), total revenue lost (3.41M), and newly joined customers (411). These provide a one-glance view of churn metrics.
     - Donut Chart: Gender distribution of churners, showing churn split across male/female.
     - Clustered Column + Line Chart: Customer count by tenure segments (0–6, 7–12, 13–24, 25+ months) with churn rate overlay, making it clear where risk peaks.
     - Bar Charts:
       - Churn rate by state, highlighting high-risk geographies like Jammu & Kashmir.
       - Churn rate by internet type (Fiber optic users churn most).
     - Stacked Bar Chart: Churn by contract & payment method, capturing the impact of monthly contracts and mailed checks.
     - Column Chart: Churn distribution by churn categories (Competitor, Attitude, Dissatisfaction). With a tootilp to view the specific churn reasons (e.g., “Network reliability – 66 churns,” “Product dissatisfaction – 71 churns”).
     - Table: Service adoption breakdown (e.g., Unlimited Data, Streaming TV, Premium Support) against churn percentages.
     - Slicers - Demographics: Married status, Gender.
               - Services: Value Deal
               - Billing & Payments: Paperless billing
               - Financials: Monthly charges.

### Predict Churn for newly joined customers using Python
- Imported the cleaned dataset from SQL Server into Python, using SQLAlchemy and imported the curated views (vw_churn_data, vw_joining_data).
- Performed additional preprocessing:
  1. Standardized categorical values by replacing placeholders (e.g., "Not Applicable" → "No", "None" → "No Deal").
  2. Encoded categorical features:
     - Binary variables (e.g., Married, Phone_Service, Internet_Service, Paperless_Billing) mapped to 0/1.
     - Gender encoded as 0 (Female) and 1 (Male).
     - Target variable (Customer_Status) encoded as 0 (Stayed) and 1 (Churned).
  3. Removed irrelevant/non-predictive fields such as Customer_ID, Churn_Reason, Churn_Category, and total financial aggregates to avoid data leakage.
- Trained and evaluated machine learning models to predict churn probability.
  1. Split the dataset into training (80%) and test (20%) sets with stratification to preserve churn proportion.
  2. Built preprocessing and modelling pipelines.
     - Using Column Transformer from sklearn.compose, built preprocessing pipeline to scale(using StandardScaler) and encode (using One Hot Encoder and Ordinal Encoder) columns.
     - Using Pipeline sklearn.pipeline, built modelling pipeline, chaining the preprocessing pipeline with the specific models.
  3. Implemented and compared performance of classification models like Logistic Regression, Random Forest CLassifier and XGBoost Classifier.
  4. Evaluated model performance on test data, focusing on recall and precision for the churn class (positive class), since correctly identifying churners is more valuable than minimizing false positives.
     Model Performance Interpretation:
     1. Overall Accuracy
        - Logistic Regression: 82%
        - Random Forest: 85% (highest)
        - XGBoost: 83%
        All three models performed reasonably well, with Random Forest achieving the best overall accuracy.
     2. Churn Class (Class = 1) – Critical Segment
        - Since the business priority is to correctly identify churners (class 1), recall and precision matter more than raw accuracy:
        1. Recall (ability to catch actual churners):
           - Logistic Regression: 0.62
           - Random Forest: 0.62
           - XGBoost: 0.64 (slightly better)
          Interpretation: All three models only capture ~62–64% of churners. That means ~36–38% of churners are missed (false negatives).
        2. Precision (how many predicted churners are actually churners):
           - Logistic Regression: 0.72
           - Random Forest: 0.81 (best)
           - XGBoost: 0.73
          Interpretation: Random Forest provides the most reliable churn predictions, with fewer false positives.
        3. F1-Score (balance between precision & recall for churners):
           - Logistic Regression: 0.67
           - Random Forest: 0.70 (best)
           - XGBoost: 0.68
     3. Non-Churn Class (Class = 0) – Retained Customers
        - All models are very strong here, with recall ~0.90+ and precision ~0.85+.
        - This means the models are much better at identifying who will stay than who will leave.
     4. AUC (Discrimination Power)
        - Logistic Regression: 0.867
        - Random Forest: 0.880 (best)
        - XGBoost: 0.878
        AUC indicates all three models have good discriminatory power. Random Forest is slightly better.

    Business Implications:
    - Random Forest emerges as the most balanced model:
      1. Best overall accuracy (85%).
      2. Best precision for churners (81%), minimizing wasted retention effort on false positives.
      3. Slightly weaker recall than XGBoost, but not significantly.
    - Logistic Regression is simpler and interpretable but underperforms in precision and recall compared to ensemble methods.
    - XGBoost is competitive, offering slightly higher recall (better at catching churners) but lower precision than Random Forest.

  5. Predicted churner based on all three models, on vw_joining_data.
  6. Merged the predictions with original data and saved into a csv file.

### Add another page to Dashboard - Customer Churn Analysis
- Imported new predictions made on newly joined customers using Python Script
  
- Created DAX Measures:
  1. Total Predicted Churners = “Total Predicted Churners : ” & COUNT(Predictions[Customer_ID])
     
- Created Viz. 
  1. CHURN PREDICTION PAGE:

    ![Churn Prediction](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Customer%20Churn%20Analysis/Churn%20Prediction%20Page.png)

     Components: 
     - KPI Cards: Predicted churners segmented by gender (118 female, 52 male).
     - Bar Chart: Predicted churn count by state, surfacing high-risk geographies.
     - Bar Chart: Predicted churn by payment method (Bank withdrawal vs. credit card).
     - Bar Chart: Predicted churn by contract type, confirming month-to-month users are riskiest.
     - Column Chart: Predicted churn distribution across tenure bands, confirming higher risk in the 7–12 and 13–24 month groups.
     - Customer Detail Table: Tabular list of predicted churners with Customer ID, Monthly Charges, Total Charges, and Extra Data Charges, making the model output operationally actionable (sales/retention teams can directly act).
     - Slicers - Demographics: Married status
               - Services: Value Deal
               - Billing & Payments: Paperless billing

  ## Conclusion
    This project provided a comprehensive, end-to-end framework for understanding and managing customer churn in the telecom industry which can also be extended to other industries. Through SQL-driven exploratory analysis, the key demographic, service, and financial factors influencing churn were uncovered, highlighting high-risk groups such as early-tenure customers, fiber optic users, and those on month-to-month contracts. The insights revealed that competitor-driven and dissatisfaction-related churn accounted for the majority of customer losses, underscoring the need for targeted retention strategies.
  
  Building on these findings, machine learning models were developed to predict churn at the customer level. Among the tested models, Random Forest delivered the strongest performance, achieving an accuracy of 85% and an AUC of 0.88, while maintaining high precision in identifying churners. This predictive capability transformed the analysis from descriptive reporting into proactive foresight, enabling the business to flag at-risk customers before they disengage.
  
  Finally, an interactive Power BI dashboard consolidated the analysis into a decision-support tool. By combining KPIs, segment-level insights, and customer-level predictions, the dashboard equipped stakeholders with both strategic and operational levers to reduce churn. With features such as dynamic slicers and contextual tooltips, the dashboard made complex insights accessible, actionable, and transparent.
  
  Overall, this project demonstrated clear business impact by quantifying the scale of churn (26.99% of customers, equating to a loss of 3.41M in revenue), identifying its root causes, and providing the tools to mitigate it. The deliverables empower the telecom business or other to design targeted interventions—whether through service improvements, loyalty incentives, or tailored retention offers—that can reduce churn, protect revenue streams, and strengthen customer lifetime value.
             
  



     
 



