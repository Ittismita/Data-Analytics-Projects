# Regression Analysis in Excel

## Correlation Analysis
Before delving into predictive modelling one needs to understand the relationship between the variables. So to determine the ***linear relationship*** between two variables correlation analysis was carried out.

The two columns under consideration were -> "Discount" and "Total Amount Spent"
Used scatter plots to visualize the relationship between these two variables.

## Simple Linear Regression


## Mutiple Linear Regression

## Advanced Multiple Linear Regression
1. In Power Query the following tasks were carried out:
   1. Changed the data type of columns.
   2. Removed blank rows.
   3. Mapped or created dummy variables of features containing categorical values. The columns under consideration are:
      1. Gender -
         1. Female - 1
         2. Male - 0
      
      2. User Region - North, East, South, West
         Dropping value "North", reducing multicollinearity 3 dummy variables were created where absence all zeroes in a row indicated the value "North". While all other values              were indicated by 1.
          
      3. Product Category - 5 categories - Books, Clothing, Electronics, Home & Kitchen, Sports & Outdoors
         Dropping value "Books", reducing multicollinearity 4 dummy variables were created where absence all zeroes in a row indicated the value "Books". While all other values 
         were indicated by 1.

2. Carried out VIF(Variance Inflation Factor) analysis of the independent variables to check for multicolinearity among them.
   VIF - Tells us
         -  how much the variance of an estimated regression coefficient increases because of multicollinearity
         -  how much a variable is contributing to the standard error in a regression model.
         -  if a predictor has a strong linear relationship with another predictor.
   
   - A VIF value of 1 means there’s no correlation among the predictor variables, which is ideal.
   - A value between 1 and 5 suggests moderate correlation but not enough to warrant concern.
   - A VIF above 5 suggests significant multicollinearity that should be addressed.

   For example, imagine we’re trying to predict the price of a house based on its size and the number of rooms. If size and the number of rooms are highly correlated, the VIF will     be high, indicating that these variables provide redundant information. By identifying this, we can adjust our model to improve its accuracy.

   Observed VIF values:
   1. Age - 1.001
   2. Gender - 1.001
   3. East - 1.507
   4. South - 1.505
   5. West - 1.508
   6. Clothing - 1.610
   7. Electronics - 1.602
   8. Home & Kitchen - 1.598
   9. Sports & Outdoors - 1.611
   10. Log_Product Price - 1.475
   11. Log_Discount - 1.475
  
   So, in our case all VIF values were less than 5, indicating that mutilcolinearity was not a matter of concern for these independent variables. Hence, including all these 
   variables in our regression model was appropriate.
