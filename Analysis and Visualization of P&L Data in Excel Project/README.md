# Analysis and Visualization of P&L Data in Excel 
### Senario: 
As a first-year analyst in the internal M&A division of Nike, prepare an Excel profit and loss (P&L) table for analysis, with details of the earnings before interest and taxes (EBIT) level. 

Familiarizing with the structure of the data:
Ticker : ADS GY Equity
Company :	adidas AG
Periodicity :	A
Currency :	USD
Filing Status Mnemonic :	MR
Filing :	Most Recent
Units :	MLN

1. Company Ticker : Abbreviation used as a shortcut to identify public companies in financial databases. It is vital to know the company ticker as to know which company's data we are going to work with.
2. Periodicity of Financial Statements : In this context, 'A' indicates that the data consists of actual figures and not estimates or projections. It helps in determining the nature of the financial information we are analyzing.
3. Currency : Vital for accurate analysis.
4. Measuring Unit : The information is often summarized in a particular unit, such as millions. This tells us how to interpret numerical values throughpout the data.

In Adidas's financial dataset 
To understand the company's revenue structure and performance, business is divided into 3 primary product or brand areas - Wholesale, Retail and Other Businesses

Bloomberg or similar financial systems often employ leading spaces to enhance user experience and clarity reading. These spaces help distinguish between main categories, sub categories or further breakdowns. 

Hence, leading spaces were preserved for lookup functions and for a hierarchial view of the information.
![Dashboard](https://github.com/Ittismita/Data-Analytics-Projects/blob/main/Analysis%20and%20Visualization%20of%20P%26L%20Data%20in%20Excel%20Project/viz./dta.png)


Bloomberg's Format:
1. Mnemonic field contains values that mark the start of a breakdown.
2. 

## 1. Created P&L Structure and Applied Formatting

1.  The structure included a revenue breakdown and essential P&L items leading to EBIT.
2.  'Operating income' item was renamed to EBIT in the table.
3.  Non-blank cells were selected after applying filter on Mnemonic Field to hide deeper breakdowns.
4.  Used Custom sort to sort the years from left to right.
5.  Dealt with the leading spaces :
    Not changing anything in the source -> Using a helper column in the P&L sheet

## 2. Looked up Source Data, Calculated Margins and Growth Rates

1. Utilized nested lookups -> Considered two criteria : financial items and period under analysis -> Used INDEX, MATCH, MATCH combination



