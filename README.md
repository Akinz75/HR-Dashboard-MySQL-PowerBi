# HR-Dashboard-MySQL-PowerBi

## Project Overview

Data - HR Data with over 22000 rows from the year 2000 to 2020.

Data Cleaning & Analysis - MySQL Workbench

Data Visualization - PowerBI


## Business Questions
1. What is the gender breakdown of employees in the company?
2. What is the company's race/ethnicity breakdown of employees?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

## Summary of Findings
- There are more male employees
- White race is the most dominant while Native Hawaiian and American Indians are the least dominant.
- The youngest employee is 21 years old and the oldest is 58 years old
- 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
- A large number of employees work at the headquarters versus remotely.
- The average length of employment for terminated employees is around 8 years.
- The gender distribution across departments is fairly balanced but there are generally more male than female employees.
- The Marketing department has the highest turnover rate followed by Training. The Research and Development, Support, and Legal departments have the lowest turnover rates.
- A large number of employees come from the state of Ohio.
- The net change in employees has increased over the years.
- The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales, and Marketing having the lowest.

## Recommendations
1. Data Validation Procedures: Implement stricter data validation rules to prevent future occurrences of negative ages or erroneous termination dates. Consider adding automated checks during data entry or regular audits of the data to catch such issues early.

2. Missing Data Analysis: Analyze the excluded records with negative ages and future term dates to understand potential patterns or data entry errors. This could help refine the data collection process and minimize the loss of valuable information.

3. Demographic Analysis Enhancement: Consider expanding the demographic analysis by including factors like education level, years of experience, or other relevant variables. This could provide deeper insights into employee trends and turnover rates.

4. Remote Work Trends: Investigate the reasons behind the higher concentration of employees at the headquarters compared to remote work. With the growing trend towards remote work, understanding these dynamics can inform future workforce planning.

5. Turnover Rate Strategies: Focus on addressing the high turnover rates in the Marketing and Training departments. Conduct exit interviews or surveys to identify underlying causes and implement targeted retention strategies.

6. Employee Engagement: Given the varying tenure lengths across departments, consider developing department-specific engagement programs to enhance employee satisfaction and retention, especially in departments with shorter average tenures.

7. Further Geographic Analysis: Explore why a significant number of employees are from Ohio. Understanding regional hiring patterns could help in diversifying the geographic distribution of employees and tapping into talent from other regions.


## Limitations
- Some records had negative ages and these were excluded during querying(967 records). The ages used were 18 years and above.
- Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.





