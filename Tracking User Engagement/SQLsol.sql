-- Data Preparation------------------------------------------------------------------------------------------------------
USE data_scientist_project;

-- Creating a VIEW-------------------------------------------------------------------------------------------------------
SELECT * FROM student_purchases;

-- Calculating a Subscription’s End Date
SELECT 
    purchase_id, 
    student_id, 
    plan_id, 
    date_purchased AS date_start, 
    CASE 
		WHEN plan_id=0 THEN DATE_ADD(date_purchased,INTERVAL 1 MONTH)
        WHEN plan_id=1 THEN DATE_ADD(date_purchased,INTERVAL 3 MONTH)
        WHEN plan_id=2 THEN DATE_ADD(date_purchased,INTERVAL 12 MONTH)
        WHEN plan_id=3 THEN 0
	END AS date_end, 
    date_refunded 
FROM 
  student_purchases;
  
-- Re-Calculating a Subscription’s End Date  
SELECT 
	purchase_id,
    student_id,
    plan_id,
    date_start,
	CASE
		WHEN date_refunded <> NULL THEN date_refunded
        ELSE date_end
	END AS date_end
FROM (
		SELECT 
			purchase_id, 
			student_id, 
			plan_id, 
			date_purchased AS date_start, 
			CASE 
				WHEN plan_id=0 THEN DATE_ADD(date_purchased,INTERVAL 1 MONTH)
				WHEN plan_id=1 THEN DATE_ADD(date_purchased,INTERVAL 13 MONTH)
				WHEN plan_id=2 THEN DATE_ADD(date_purchased,INTERVAL 12 MONTH)
				WHEN plan_id=3 THEN 0
			END AS date_end, 
			date_refunded 
		FROM 
		student_purchases
) a;

-- Creating Two ‘paid’ Columns and a MySQL View
DROP VIEW IF EXISTS purchases_info;

CREATE VIEW purchases_info AS
SELECT
    purchase_id,
	student_id,
	plan_id,
	date_start,
	date_end,
    CASE 
        WHEN date_end< '2021-04-01' THEN 0 
        WHEN date_start> '2021-06-30' THEN 0 
        ELSE 1 
    END AS paid_q2_2021,
    CASE 
        WHEN date_end< '2022-04-01' THEN 0 
        WHEN date_start> '2022-06-30' THEN 0 
        ELSE 1 
    END AS paid_q2_2022
FROM
(
    SELECT 
	purchase_id,
    student_id,
    plan_id,
    date_start,
	CASE
		WHEN date_refunded <> NULL THEN date_refunded
        ELSE date_end
	END AS date_end
FROM (
		SELECT 
			purchase_id, 
			student_id, 
			plan_id, 
			date_purchased AS date_start, 
			CASE 
				WHEN plan_id=0 THEN DATE_ADD(date_purchased,INTERVAL 1 MONTH)
				WHEN plan_id=1 THEN DATE_ADD(date_purchased,INTERVAL 13 MONTH)
				WHEN plan_id=2 THEN DATE_ADD(date_purchased,INTERVAL 12 MONTH)
				WHEN plan_id=3 THEN 0
			END AS date_end, 
			date_refunded 
		FROM 
		student_purchases
	) a
) b;

select distinct paid_q2_2022 from purchases_info;
-- ----------------------------------------------------------------------------------------------------------------------

-- Splitting into periods---------------------------------------------------------------------
-- Calculating Total Minutes Watched in Q2 2021 and Q2 2022
-- Q2 2021
SELECT COUNT(DISTINCT student_id) -- , ROUND(SUM(seconds_watched)/60,2) as minutes_watched
FROM student_video_watched
WHERE YEAR(date_watched)=2021
GROUP BY student_id;

-- Q2 2022
SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
FROM student_video_watched
WHERE YEAR(date_watched)=2022
GROUP BY student_id;

-- Q2 2021 & Q2 2022
SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
FROM student_video_watched
WHERE YEAR(date_watched)=2021 OR 2022
GROUP BY student_id;

-- Creating a ‘paid’ Column
WITH b as (
	SELECT 
	  a.student_id as student_id, 
	  a.minutes_watched as minutes_watched,
	  if(i.date_start is null,0,i.paid_q2_2021) as date1
	  
	FROM 
	  (
		SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
		FROM student_video_watched
		WHERE YEAR(date_watched)=2021
		GROUP BY student_id
	  ) a 
	  LEFT JOIN purchases_info i ON a.student_id=i.student_id
)
SELECT  student_id,minutes_watched,MAX(date1) AS paid_in_q2
FROM b
GROUP BY student_id
;
 
-- Retrieving 4 datasets
-- Students engaged in Q2 2021 who haven’t had a paid subscription in Q2 2021 (minutes_watched_2021_paid_0.csv)
WITH Q21 as (
	SELECT 
	  a.student_id as student_id, 
	  a.minutes_watched as minutes_watched,
	  if(i.date_start is null,0,i.paid_q2_2021) as date1
	  
	FROM 
	  (
		SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
		FROM student_video_watched
		WHERE YEAR(date_watched)=2021
		GROUP BY student_id
	  ) a 
	  LEFT JOIN purchases_info i ON a.student_id=i.student_id
)
SELECT  student_id,minutes_watched,MAX(date1) AS paid_in_q2
FROM Q21
GROUP BY student_id
HAVING paid_in_q2=0;

-- Students engaged in Q2 2022 who haven’t had a paid subscription in Q2 2022 (minutes_watched_2022_paid_0.csv)
WITH Q22 as (
	SELECT 
	  a.student_id as student_id, 
	  a.minutes_watched as minutes_watched,
	  if(i.date_start is null,0,i.paid_q2_2022) as date1
	  
	FROM 
	  (
		SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
		FROM student_video_watched
		WHERE YEAR(date_watched)=2022
		GROUP BY student_id
	  ) a 
	  LEFT JOIN purchases_info i ON a.student_id=i.student_id
)
SELECT  student_id,minutes_watched,MAX(date1) AS paid_in_q2
FROM Q22
GROUP BY student_id
HAVING paid_in_q2=0;

-- Students engaged in Q2 2021 who have been paid subscribers in Q2 2021 (minutes_watched_2021_paid_1.csv)
WITH Q211 as (
	SELECT 
	  a.student_id as student_id, 
	  a.minutes_watched as minutes_watched,
	  if(i.date_start is null,0,i.paid_q2_2021) as date1
	  
	FROM 
	  (
		SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
		FROM student_video_watched
		WHERE YEAR(date_watched)=2021
		GROUP BY student_id
	  ) a 
	  LEFT JOIN purchases_info i ON a.student_id=i.student_id
)
SELECT  student_id,minutes_watched,MAX(date1) AS paid_in_q2
FROM Q211
GROUP BY student_id
HAVING paid_in_q2=1;


-- Students engaged in Q2 2022 who have been paid subscribers in Q2 2022 (minutes_watched_2022_paid_1.csv)
WITH Q221 as (
	SELECT 
	  a.student_id as student_id, 
	  a.minutes_watched as minutes_watched,
	  if(i.date_start is null,0,i.paid_q2_2022) as date1
	  
	FROM 
	  (
		SELECT student_id, ROUND(SUM(seconds_watched)/60,2) as minutes_watched
		FROM student_video_watched
		WHERE YEAR(date_watched)=2022
		GROUP BY student_id
	  ) a 
	  LEFT JOIN purchases_info i ON a.student_id=i.student_id
)
SELECT  student_id,minutes_watched,MAX(date1) AS paid_in_q2
FROM Q221
GROUP BY student_id
HAVING paid_in_q2=1;

-- ----------------------------------------------------------------------------------------------------------------------
-- Certificates Issued-----------------------------------------------------------------------
-- Studying Minutes Watched and Certificates Issued
SELECT student_id,
	COUNT(certificate_id) as certificates_issued
FROM student_certificates
GROUP BY student_id;

WITH c as(
	SELECT c.student_id, 
		IF(seconds_watched IS NULL,
        0,
        seconds_watched/60) AS minutes_watched, c.certificates_issued
	FROM (
		SELECT student_id,
		COUNT(certificate_id) as certificates_issued
		FROM student_certificates
		GROUP BY student_id) c 
	 LEFT JOIN student_video_watched v ON c.student_id=v.student_id
 )

SELECT student_id,
  SUM(minutes_watched) as minutes_watched,
  certificates_issued
FROM c
GROUP BY student_id;

-- Queries to calculate dependencies and probabilities
-- Event A: A student watched a lecture in Q2 2021= 7639
SELECT COUNT(DISTINCT student_id)
FROM student_video_watched
WHERE YEAR(date_watched)=2021;

-- Event B: A student watched a lecture in Q2 2022= 8841
SELECT COUNT(DISTINCT student_id)
FROM student_video_watched
WHERE YEAR(date_watched)=2022;

-- A student watched a lecture in Q2 2022 and Q2 2022=640
SELECT COUNT(DISTINCT student_id)
FROM (
	SELECT DISTINCT student_id
    FROM student_video_watched
    WHERE YEAR(date_watched)=2021) Q20 JOIN 
    (
    SELECT DISTINCT student_id
    FROM student_video_watched
    WHERE YEAR(date_watched)=2022) Q21 USING (student_id);


-- Total students who watched a lecture= 15840
SELECT COUNT(DISTINCT student_id)
FROM student_video_watched;






 








