USE HealthInsuranceDB;

SELECT * FROM insurance;

-- 1. GENERAL OVERVIEW
SELECT COUNT(*) AS total_records FROM insurance;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'insurance';

-- 2. MISSING VALUE CHECK
SELECT 
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_null,
    SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS sex_null,
    SUM(CASE WHEN bmi IS NULL THEN 1 ELSE 0 END) AS bmi_null,
    SUM(CASE WHEN children IS NULL THEN 1 ELSE 0 END) AS children_null,
    SUM(CASE WHEN smoker IS NULL THEN 1 ELSE 0 END) AS smoker_null,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_null,
    SUM(CASE WHEN charges IS NULL THEN 1 ELSE 0 END) AS charges_null
FROM insurance;

-- 3. DUPLICATE CHECK & REMOVAL
SELECT COUNT(*) AS total_before FROM insurance;

WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY age, sex, bmi, children, smoker, region, charges
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM insurance
)
DELETE FROM CTE WHERE row_num > 1;

SELECT COUNT(*) AS total_after FROM insurance;

-- 4. BASIC STATISTICS
SELECT
    MIN(age)        AS min_age,
    MAX(age)        AS max_age,
    AVG(age)        AS avg_age,

    MIN(bmi)        AS min_bmi,
    MAX(bmi)        AS max_bmi,
    AVG(bmi)        AS avg_bmi,

    MIN(children)   AS min_children,
    MAX(children)   AS max_children,
    AVG(children)   AS avg_children,

    MIN(charges)    AS min_charges,
    MAX(charges)    AS max_charges,
    AVG(charges)    AS avg_charges
FROM insurance;

-- 5. CATEGORICAL DISTRIBUTIONS
SELECT sex, COUNT(*) AS count FROM insurance GROUP BY sex;

SELECT smoker, COUNT(*) AS count FROM insurance GROUP BY smoker;

SELECT region, COUNT(*) AS count FROM insurance GROUP BY region;

SELECT children, COUNT(*) AS count FROM insurance GROUP BY children ORDER BY children;

-- 6. OUTLIER CHECK
SELECT 
    COUNT(*) AS total,
    SUM(CASE WHEN charges > 50000 THEN 1 ELSE 0 END) AS very_high_charges,
    SUM(CASE WHEN bmi > 45 THEN 1 ELSE 0 END) AS very_high_bmi,
    SUM(CASE WHEN age < 18 THEN 1 ELSE 0 END) AS under_age
FROM insurance;

-- 7. ANALYSIS QUERIES
SELECT 
    smoker,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges,
    MIN(charges) AS min_charges,
    MAX(charges) AS max_charges
FROM insurance
GROUP BY smoker;

SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 64 THEN '46-64'
    END AS age_group,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 64 THEN '46-64'
    END
ORDER BY avg_charges;

SELECT 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        WHEN bmi >= 30 THEN 'Obese'
    END AS bmi_group,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        WHEN bmi >= 30 THEN 'Obese'
    END
ORDER BY avg_charges;

SELECT 
    sex,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY sex
ORDER BY avg_charges;

SELECT 
    region,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY region
ORDER BY avg_charges;

SELECT 
    children,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY children
ORDER BY children;

SELECT 
    CASE 
        WHEN smoker = 'yes' THEN 'High Risk'
        WHEN bmi >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_group,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges,
    MIN(charges) AS min_charges,
    MAX(charges) AS max_charges
FROM insurance
GROUP BY 
    CASE 
        WHEN smoker = 'yes' THEN 'High Risk'
        WHEN bmi >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
ORDER BY avg_charges;

-- 8. CREATE VIEWS
CREATE VIEW vw_smoker_analysis AS
SELECT 
    smoker,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges,
    MIN(charges) AS min_charges,
    MAX(charges) AS max_charges
FROM insurance
GROUP BY smoker;
GO

CREATE VIEW vw_age_analysis AS
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 64 THEN '46-64'
    END AS age_group,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 64 THEN '46-64'
    END;
GO

CREATE VIEW vw_bmi_analysis AS
SELECT 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        WHEN bmi >= 30 THEN 'Obese'
    END AS bmi_group,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        WHEN bmi >= 30 THEN 'Obese'
    END;
GO

CREATE VIEW vw_gender_analysis AS
SELECT 
    sex,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY sex;
GO

CREATE VIEW vw_region_analysis AS
SELECT 
    region,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges
FROM insurance
GROUP BY region;
GO

CREATE VIEW vw_risk_segmentation AS
SELECT 
    CASE 
        WHEN smoker = 'yes' THEN 'High Risk'
        WHEN bmi >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_group,
    COUNT(*) AS customer_count,
    AVG(charges) AS avg_charges,
    MIN(charges) AS min_charges,
    MAX(charges) AS max_charges
FROM insurance
GROUP BY 
    CASE 
        WHEN smoker = 'yes' THEN 'High Risk'
        WHEN bmi >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END;
GO

-- 9. VIEW QUERIES
SELECT * FROM vw_smoker_analysis;
SELECT * FROM vw_age_analysis;
SELECT * FROM vw_bmi_analysis;
SELECT * FROM vw_gender_analysis;
SELECT * FROM vw_region_analysis;
SELECT * FROM vw_risk_segmentation;


SELECT TOP 5 * FROM insurance_predictions;