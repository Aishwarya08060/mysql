**ZOMATO customer data analysis**

ZOMATO DATASET QUESTION SOLVED

1.'what is the total price of each customer spend on zomato?'

select sales.userid,sum(product.price) total_amount_spend from sales
inner join product
on sales.product_id = product.product_id
group by sales.userid

2. 'How many days customer visited zomato?'

select userid,count(distinct created_date) no_of_vist from sales group by userid

3. 'what was the first product purchased by each customer?'

select * from
(select *,rank() over(partition by userid order by created_date) rnk from sales) sales where rnk = 1

4.'what is the most purchased item in the menu and how mant times it is been purchased?'

select product_id,count(product_id) from sales group by product_id order by product_id asc limit 1

5.'which item is most popular for each customer?'

SELECT *,
       RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
FROM (
    SELECT a.userid, a.product_id, COUNT(a.product_id) AS product_count, MAX(a.created_date) AS created_date
    FROM sales a  
    GROUP BY a.userid, a.product_id
) AS subquery;

6. 'which item was purchased first by customer after they became member?'

select * from
(select *,rank() over(partition by userid order by created_date) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b
on a.userid=b.userid and created_date>= gold_signup_date)c) d where rnk =1

7. 'which item was purchased first by customer before they became member?'

select * from
(select *,rank() over(partition by userid order by created_date) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b
on a.userid=b.userid and created_date<= gold_signup_date)c) d where rnk =1

**Diabetes prediction dataset**

1.'Retrieve the Patient_id and calculate the age of each patient'
SELECT Patient_id, TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS Age
FROM diabetics.diabetes_prediction_csv;

'count no of rows'
SELECT COUNT(*) AS total_rows FROM diabetics.diabetes_prediction_csv;

2.'Select all female patients whose age exceeds 30'
SELECT Patient_id, gender, TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS Age
FROM diabetics.diabetes_prediction_csv
WHERE Gender = 'Female' AND TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) > 30;

3.'Determine the average BMI among all patients'
SELECT AVG(bmi) AS average_BMI 
FROM diabetics.diabetes_prediction_csv;

4.'Sort and list patients in decreasing order of blood glucose levels'
SELECT Patient_id, blood_glucose_level FROM diabetics.diabetes_prediction_csv
ORDER BY blood_glucose_level DESC;

5.'Find out how many patients have been diagnosed with heart disease'
SELECT COUNT(*) AS total_patients 
FROM diabetics.diabetes_prediction_csv
WHERE heart_disease = 1 

6.'Group patients based on their smoking history and count the number of smokers and non-smokers'
SELECT smoking_history, COUNT(*) AS total_patients 
FROM diabetics.diabetes_prediction_csv
WHERE smoking_history IN ('never', 'ever')
GROUP BY smoking_history;
7.'Find the patients with the highest and lowest HbA1c values'
(SELECT Patient_id, HbA1c_level, 'Highest' AS Type  
 FROM diabetics.diabetes_prediction_csv  
 ORDER BY HbA1c_level DESC  
 LIMIT 1)  
 
UNION  

(SELECT Patient_id, HbA1c_level, 'Lowest' AS Type  
 FROM diabetics.diabetes_prediction_csv  
 ORDER BY HbA1c_level ASC  
 LIMIT 1);

8.'Assign rankings to patients based on blood glucose levels, separately for each gender'
SELECT 
    Patient_id,  
    gender,  
    blood_glucose_level,  
    RANK() OVER (PARTITION BY gender ORDER BY blood_glucose_level DESC) AS `Rank`  
FROM diabetics.diabetes_prediction_csv;

9.'Insert a new record into the patient database with sample details'
INSERT INTO diabetics.diabetes_prediction_csv 
(EmployeeName, Patient_id, gender, hypertension, smoking_history, bmi, HbA1c_level, blood_glucose_level, diabetes, DateOfBirth)  
VALUES 
('Nazi', 'PT201', 'Female', 0, 'never', 15.1, 6.6, 85, 0, '1979-05-10');
