# Analysis and Visualization of P&L Data in Excel 
### Scenario: 
As a first-year analyst in the internal M&A division of Nike, prepare an Excel profit and loss (P&L) table for analysis, with details of the earnings before interest and taxes (EBIT) level. 

Familiarizing with the structure of the data:
1. Ticker : ADS GY Equity
2. Company :	Adidas AG
3. Periodicity :	A
4. Currency :	USD
5. Filing Status Mnemonic : MR
6. Filing :	Most Recent
7. Units :	MLN

Company Ticker : Abbreviation used as a shortcut to identify public companies in financial databases. It is vital to know the company ticker as to know which company's data we are going to work with.

Periodicity of Financial Statements : In this context, 'A' indicates that the data consists of actual figures and not estimates or projections. It helps in determining the nature of the financial information we are analyzing.

Currency : Vital for accurate analysis.

Measuring Unit : The information is often summarized in a particular unit, such as millions. This tells us how to interpret numerical values throughpout the data.

In Adidas's financial dataset :

To understand the company's revenue structure and performance, business is divided into 3 primary product or brand areas - Wholesale, Retail and Other Businesses

Bloomberg or similar financial systems often employ leading spaces to enhance user experience and clarity reading. These spaces help distinguish between main categories, sub categories or further breakdowns. 

Hence, leading spaces were preserved for lookup functions and for a hierarchial view of the information.
![sheet](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Analysis%20and%20Visualization%20of%20P%26L%20Data%20in%20Excel%20Project/viz./dta.png)


Bloomberg's Format :
1. Mnemonic field contains values that mark the start of a breakdown.

## 1. Created P&L Structure and Applied Formatting

1.  The structure included a revenue breakdown and essential P&L items leading to EBIT.
2.  'Operating income' item was renamed to EBIT in the table.
3.  Non-blank cells were selected after applying filter on Mnemonic Field to hide deeper breakdowns.
4.  Used Custom sort to sort the years from left to right.
5.  Dealt with the leading spaces :
    Not changing anything in the source -> Using a helper column in the P&L sheet

## 2. Looked up Source Data, Calculated Margins and Growth Rates

1. Utilized nested lookups -> Considered two criteria : financial items and period under analysis -> Used INDEX, MATCH (returned the row number), MATCH (returned the column number) combination
2. Added a minus sign before the costs ->Used Custom format (####;####) to hide the negative signs -> for accurate summing up of subtotals -> Used SUM function for calculating Revenue.
3. Used INDEX MATCH MATCH combination to fill up other cells.
4. Added other considerables to the report -> to understand the firm's Gross Profit and EBIT margins andtheir five-year revenue growth rate -> Used CAGR to measure the revenue growth rate.
5. Cross-checked using data from source sheet.
6. Some formulas applied across the report:
   
   1. Cost of Revenue = Revenue - Gross Profit
   2. Profit % = Profit / Revenue * 100
   3. EBIT % = EBIT / Revenue * 100
   4. CAGR =  (Final Value(value in 2023) / Initial Value(value in 2019))<sup>1/4</sup>-1
  
## 3. Created a Visualization
1. Created a stacked column chart illustrating how business lines contributed to the revenue.
2. Added a secondary axis for displaying the EBIT% as a line chart.
3. Formatted the axes, data labels, axis labels and chart design.

   ![chart](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Analysis%20and%20Visualization%20of%20P%26L%20Data%20in%20Excel%20Project/viz./PL_chart.png)

## 4. Interpreted Data

![sheet1](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Analysis%20and%20Visualization%20of%20P%26L%20Data%20in%20Excel%20Project/viz./PL.png)

### Growth Analysis
1. The company exhibited steady revenue growth, with a CAGR of ~7.4% from FY 2019 to FY 2023. This consistent growth is indicative of a solid and expanding business.
2. The Retail segment stood out as the fastest-growing sector, with a CAGR of 14.49%, while the Wholesale segment saw the slowest growth, with a CAGR of 4.84%.
3. The Other Businesses segment also showed commendable growth with a CAGR of 9.64%.
   
### Profitability Analysis
The company's profitability has improved remarkably over the period. 
1. The gross profit grew at a CAGR of 9.72%, and the gross profit margin increased from 46% to 50%. This uptick in margin demonstrates that the company has effectively managed its direct costs and possibly increased sales prices.
2. Furthermore, EBIT grew at a remarkable CAGR of 22.88%, with the EBIT percentage rising from 5% to 9%. This growth signifies better control over operating costs and an enhancement in operational efficiency.

## Summary
The financial data from FY 2019 to FY 2023 reflects a robust performance for the company in growth and profitability. Revenue growth has been steady, with strength in the Retail segment. Profitability has not only been maintained but has also seen significant improvements across key metrics, including substantial growth in EBIT. This balance of top-line growth with bottom-line improvements indicates a well-managed expansion. Adidas demonstrated a robust competitive position in the industry and a sustainable growth trajectory. The combination of growth in both revenue and profitability metrics suggests strategic execution in market penetration and cost control.

NOTE: Refer to the file named "Bloomberg data_source.xlsx" for the entire project.
