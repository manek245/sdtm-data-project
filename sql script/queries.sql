-- queries on the dm and ex

USE clindata;
--1
-- patient count
SELECT COUNT(*) AS total_patients FROM dm;

--2
-- how many patients are there per country?
SELECT COUNTRY, COUNT(*) AS patients
FROM dm
GROUP BY COUNTRY
ORDER BY patients DESC;

--3
-- how many patients were enrolled per month?
SELECT
SUBSTRING(RFICDTC, 1, 7)  AS enrollment_month,
COUNT(*)                   AS patients_enrolled
FROM dm
WHERE RFICDTC IS NOT NULL
GROUP BY SUBSTRING(RFICDTC, 1, 7)
ORDER BY enrollment_month;



--4
-- how many patients per treatment arm?
SELECT ARM, COUNT(*) AS patients
FROM dm
GROUP BY ARM;

--5
-- what is the gender ratio?
SELECT SEX, COUNT(*) AS count
FROM dm
GROUP BY SEX
ORDER BY count DESC;

--6
-- what is the race ratio?
SELECT RACE, COUNT(*) AS count
FROM dm
GROUP BY RACE
ORDER BY count DESC;

--7
-- which patients withdrew from the study?
SELECT USUBJID, COUNTRY, RFPENDTC AS withdrawal_date
FROM dm
WHERE RFPENDTC IS NOT NULL;

--8
-- age summary of all patients
SELECT
MIN(AGE) AS min_age,
MAX(AGE) AS max_age,
ROUND(AVG(AGE),1) AS avg_age
FROM dm
WHERE AGE IS NOT NULL;

--9
-- which patients are older than the average age?
SELECT USUBJID, COUNTRY, AGE, ( SELECT AVG(AGE)
                                FROM DM
                                ) as average_age
FROM dm
WHERE AGE > (SELECT AVG(AGE) 
                FROM dm 
                WHERE AGE IS NOT NULL)
ORDER BY AGE DESC;

--10
-- which patients had more visits than the average patient 
SELECT USUBJID, COUNT(*) AS visits, ((SELECT AVG(visit_count) FROM (
    SELECT COUNT(*) AS visit_count
    FROM ex
    GROUP BY USUBJID
  ))) AS avg_visits
FROM ex
GROUP BY USUBJID
HAVING COUNT(*) > (
  SELECT AVG(visit_count)
  FROM ( SELECT COUNT(*) AS visit_count
    FROM ex
    GROUP BY USUBJID)
)
ORDER BY visits DESC;


--11
-- what doses were given and how often?
SELECT EXDOSE, EXDOSEU, COUNT(*) AS times_given
FROM ex
GROUP BY EXDOSE, EXDOSEU
ORDER BY times_given desc;

--12
-- CTE s
-- average age and patient count per country
WITH country_stats AS (
  SELECT
    COUNTRY,
    COUNT(*) AS patients,
    AVG(AGE) AS avg_age
  FROM dm
  WHERE AGE IS NOT NULL
  GROUP BY COUNTRY
)
SELECT COUNTRY, patients, avg_age
FROM country_stats
ORDER BY patients DESC;

--13
-- which patients received a dose adjustment at any point?
WITH adjusted AS (
  SELECT DISTINCT USUBJID
  FROM ex
  WHERE EXADJ IS NOT NULL
)
SELECT d.USUBJID, d.COUNTRY, d.ARM, d.AGE
FROM dm d
JOIN adjusted a ON a.USUBJID = d.USUBJID
ORDER BY d.COUNTRY;

--14
-- visit breakdown per treatment arm , total and average visits per patient
WITH visits_per_patient AS (
  SELECT e.USUBJID, d.ARM, COUNT(*) AS visit_count
  FROM ex e
  JOIN dm d ON d.USUBJID = e.USUBJID
  GROUP BY e.USUBJID, d.ARM
)
SELECT
ARM,
COUNT(*) AS patients,
SUM(visit_count) AS total_visits,
ROUND(AVG(visit_count), 1 ) AS avg_visits_per_patient
FROM visits_per_patient
GROUP BY ARM;


--joins
--15
-- patient with their first and last infusion date
SELECT
d.USUBJID,
d.COUNTRY,
d.ARM,
MIN(e.EXSTDTC) AS first_infusion,
MAX(e.EXSTDTC) AS last_infusion
FROM dm d
LEFT JOIN ex e ON e.USUBJID = d.USUBJID
GROUP BY d.USUBJID, d.COUNTRY, d.ARM
ORDER BY d.COUNTRY;

--16
-- placebo patients who had at least one dose adjustment
SELECT DISTINCT
d.USUBJID,
d.COUNTRY,
d.AGE,
e.EXADJ AS adjustment_reason
FROM dm d
JOIN ex e ON e.USUBJID = d.USUBJID
WHERE d.ARM = 'PLACEBO'
AND e.EXADJ IS NOT NULL
ORDER BY d.COUNTRY;


-- WINDOW FUNCTIONS
--17
-- rank patients by age and each country
SELECT
USUBJID,
COUNTRY,
AGE,
RANK() OVER (PARTITION BY COUNTRY ORDER BY AGE DESC) AS age_rank_in_country
FROM dm
WHERE AGE IS NOT NULL;

--18
-- the running total of visits per patient for each infusion visit,  
SELECT
USUBJID,
EXSEQ,
EXSTDTC,
EXDOSE,
SUM(1) OVER (PARTITION BY USUBJID ORDER BY EXSEQ) AS cumulative_visits
FROM ex
ORDER BY USUBJID, EXSEQ;

--19
-- Ccmpare each patient's visit count to the average 
SELECT DISTINCT
USUBJID,
COUNT(*) OVER (PARTITION BY USUBJID) AS patient_visits,
ROUND(AVG(CAST(1 AS FLOAT)) OVER (), 1) AS overall_avg_visits
FROM ex
ORDER BY patient_visits DESC;

