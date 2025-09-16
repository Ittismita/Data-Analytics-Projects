## Tracking User Engagement

Objective: To analyze whether the new additions to a platform (new courses, exams, and career tracks) have increased student engagement.

The first half of 2022 was expected to be profitable for the company. The reason was the hypothesized increased student engagement after the release of several new features on the company’s website at end-2021. These included enrolling in career tracks and testing knowledge through practice, course, and career track exams. Also expanding the course library to increase user engagement and the platform’s audience as more topics were covered. By comparing different metrics, the effectiveness of these new features can be measured and the overall engagement of the users.

### 1. DATA PREPARATION USING SQL
File: SQLsol.sql
1. Created a View: purchases_info
   - Created new columns. 
3. Splitted into periods:
   - Calculated Total Minutes Watched in Q2 2021 and Q2 2022.
   - Created 4 data sources, used purchases_info view to classify students as 
     free-plan or paying on a given date.
4. Retrieved information on the minutes watched and the certificates issued to 
   a student.

### 2. DATA PREPROCESSING WITH PYTHON
File: trackinguserengagement.ipynb
1. Studied data with the help of distribution plots like seaborn's kdeplots.
2. Examined skewness of the datasets and hence, removed outliers.

Observations:

1.

![plot](https://github.com/Ittismita/Data.Analytics/blob/main/Tracking%20User%20Engagement/plot.png)

As the plots revealed, all distributions of the minutes students watched are skewed to the right. This suggested some outliers in the data who have watched much more than most of the students on the platform. Their presence in the data skewed all metrics analyzed later, such as the mean, median, and standard deviation.

After removing outliers:
![plot](https://github.com/Ittismita/Data.Analytics/blob/main/Tracking%20User%20Engagement/plot1.png)

### 3. DATA ANALYSIS WITH EXCEL - HYPOTHESIS TESTING
File: ExcelSol.xlsx

1. Calculated
   
   a. Mean
   
   b. Median
   
   c. Confidence Intervals
   
2. Performed hypothesis testing.
   
   Null Hypothesis:
   The engagement (minutes watched) in Q2 2021 is higher than or equal to the      one in Q2 2022 (μ1 ≥ μ2). Free-plan and paying students were tested     
   separately.

   Alternative Hypothesis:
   The engagement (minutes watched) in Q2 2021 is lower than the one in Q2 
   2022 (μ1 < μ2). Free-plan and paying students were tested separately.

   Additionally, the following assumptions were made:

   a. Assumed a normal distribution.
   
   b. For free-plan students, performed a two-sample t-test assuming equal 
      variances.
   
   c. For paying students, performed a two-sample t-test assuming unequal 
      variances.

5. Calculated correlation coefficients.


Observations:

1. For free-plan students who watched in Q2 2021, the mean minutes watched are significantly higher than the median. This suggested a right-skewed distribution, indicating that a few students watched much more than others.

A similar situation was observed for free-plan students who watched in Q2 2022, with the mean being higher than the median, indicating right skewness.

The same applied to paying students who watched in Q2 2021 and those who watched in Q2 2022, where the mean is higher than the median, indicating right skewness.

The results met expectations because they aligned with the shapes of the data distribution. The right skewness observed in the distributions led us to expect a higher mean than median due to the influence of high-value outliers, which these statistics confirmed. The difference in these metrics between free-plan and paying subscribers also made sense because it was expected from paying students to generally watch more content than free-plan ones, leading to higher means and medians.

2. For free-plan students, there’s an increase in engagement from Q2 2021 to Q2 2022, as the confidence interval for the later period (15.41 – 16.66 minutes) was slightly higher than for the earlier one (13.55 – 14.87 minutes).
   
Students with paid memberships watched substantially more than those without. This was evident by comparing the confidence intervals of the two groups in Q2 2021: 13.55 – 14.87 minutes for non-subscribers and 339.60 – 380.61 minutes for subscribers.

Among the paid subscribers, there’s a decrease in engagement from Q2 2021 to Q2 2022, as the confidence interval for the later period (276.54 – 307.90 minutes) was lower than for the earlier one (339.60 – 380.61 minutes).

** Please note that these are just interpretations based on the confidence intervals, and actual cause-effect relationships need further investigation. For instance, the fact that paid subscribers watch more didn’t necessarily meant that having a paid subscription caused them to watch more. Those who watched more are more likely to get a paid subscription. Similarly, the decrease in engagement among paid subscribers from Q2 2021 to Q2 2022 could have been due to various factors that needed to be explored separately. **

3. Free-plan students:
t-Test: Two-Sample Assuming Equal Variances:

With a t-statistic of -3.951 (less than the critical value of 1.645), the null hypothesis was rejected. This was because the negative t-statistic indicated that μ1 (the mean minutes watched by students in Q2 2021) is significantly smaller than μ2 (the mean minutes watched by students in Q2 2022), which was contrary to the null, so was rejected. Of course, rejecting the null hypothesis did'nt not confirm the alternative hypothesis. It suggested that the data provide enough evidence against the null hypothesis.

4. Paid plan students:
t-Test: Two-Sample Assuming Unequal Variances:

With a t-statistic of 5.161 (greater than the critical value of 1.645), failed to reject null hypothesis. This meant there’s not enough evidence to conclude that μ1 is smaller than μ2. So, the data supported the null hypothesis that μ1 is larger than or equal to μ2.

5. Results of committing a Type I or a Type II error in this study. Which one would have resulted in higher costs to the company?
   A Type I error (false positive) occured when the null hypothesis was rejected, which was true. In this case, this would have meant concluding that engagement in 2022 is higher when it’s not.

A Type II error (false negative) occured when we failed to reject the null hypothesis, but it was false. In this case, this would have meant concluding that the engagement in 2022 was not higher when it was.

The cost to the company of each type of error would have depended on the implications of incorrectly concluding that engagement has increased—potentially leading to over-investment in certain features or complacency about needing to improve features—versus incorrectly concluding that engagement had not increased—potentially missing out on recognizing successful features or identifying areas that need improvement.

6. Interpreted the correlation between the minutes watched on the platform and the certificates issued.

The correlation between Certificates and Minutes was approaximately 0.513—a strong positive correlation. It suggested that students who watched more content tend to earn more certificates.


### 4. ASSESSING DEPENDENCIES & PROBABILITIES

Defined two events:

Event A: A student watched a lecture in Q2 2021.

Event B: A student watched a lecture in Q2 2022.

Two events are said to be independent if the occurrence of one does not affect the occurrence of the other. In probability terms, this is expressed as:

P(A∩B) = P(A)×P(B)

Where:

P(A∩B) = 640/15840, is the probability of both A and B occurring

P(A) = 7639/15840,is the probability of A occurring

P(B) = 8841/15840, is the probability of B occurring

So, 

P(A)×P(B) ≈ 0.269

P(A∩B) ≈ 0.0404

Hence, P(A∩B) ≠ P(A)×P(B), the two events are dependent.

Since P(A)×P(B) is larger than P(A∩B), it suggested that those who watched a lecture in Q2 2021 were less likely to watch a lecture in Q2 2022 than anticipated if the two events had been independent. This was to be expected. A student who had benefitted from the program in 2021 and had completed their goal was not as likely to return in 2022 and study as much. This is what we refer to as ‘good churn.’

What was the probability that a student had watched a lecture in Q2 2021, given that they’ve had watched a lecture in Q2 2022?

Using Bayes’ Rule to solve:

P(A|B) = P(B|A)×P(A)/P(B)

P(B|A) = 640/7639

P(A|B) = 640/8841 ≈ 7%

So,
Among the students who watched a lecture in Q2 2022, 7% had also watched a lecture in Q2 2021.

### 5. DATA PREDICTION WITH PYTHON
1. Implemented Linear Regression
   
   Predictor: minutes_watched
   
   Target Variable: certificates_issued
   
2. Evaluated using R-squared metric, using the score method.

Observations:
1. About 12.37% of the variance in the dependent variable is explained by the independent variables, implying that other factors also played a role in the number of certificates issued. 

One such factor, for example, includes different courses with different lengths. Therefore, a student passing three short courses will be issued three certificates, while a student passing one long course—roughly the length of three short ones—will be given only one certificate. Another factor could be that some students pass exams without watching the courses. The reason could be that they are familiar with the subject and only aim for a document proving their proficiency.

The model, therefore, provided some insight into the relationship between these two quantities, but there’s still a large portion of the variance that remains unexplained. The number of minutes watched is reasonable to include when predicting the number of certificates issued but should not be the sole factor considered.

2. Visualizing model's performance:
   
![plot](https://github.com/Ittismita/Data.Analytics/blob/main/Tracking%20User%20Engagement/plot2.png)

The points are scattered, indicating the model's predictions are not very accurate.

Most of the points are concentrated where the target values (y_test) are between 0 and 5. This suggested that the dataset had many lower target values, and the model might be overfitting or underfitting in this range.

There are some outliers, particularly where y_test exceeds 10







   





