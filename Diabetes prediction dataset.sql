SELECT *FROM diabetics.diabetes_prediction_csv;

SHOW TABLES FROM diabetics;

'change format from int to date'
ALTER TABLE diabetics.diabetes_prediction_csv 
CHANGE COLUMN `D.O.B` DateOfBirth DATE;

'add new column for DateOfBirth'
ALTER TABLE diabetics.diabetes_prediction_csv 
ADD COLUMN DateOfBirth DATE;

SET SQL_SAFE_UPDATES = 0;

'update the new DateOfBirth values'
UPDATE diabetics.diabetes_prediction_csv 
SET DateOfBirth = STR_TO_DATE(`D.O.B`, '%m/%d/%Y');

'remove old dob column'
ALTER TABLE diabetics.diabetes_prediction_csv 
DROP COLUMN `D.O.B`;

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

SELECT VERSION();

9.'Insert a new record into the patient database with sample details'
INSERT INTO diabetics.diabetes_prediction_csv 
(EmployeeName, Patient_id, gender, hypertension, smoking_history, bmi, HbA1c_level, blood_glucose_level, diabetes, DateOfBirth)  
VALUES 
('Nazi', 'PT201', 'Female', 0, 'never', 15.1, 6.6, 85, 0, '1979-05-10');













