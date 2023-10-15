--1a. Load the final_exam_rx into a new table called RX_new.
CREATE TABLE RX_new (
  accountno varchar(30) primary key,
  drugname varchar(30),
  cost integer,
  dosage real,
  dosage_instruct varchar (30)
);

BULK INSERT RX_new 
FROM 'C:\Users\student\Downloads\RX_new.TXT'
WITH (FIELDTERMINATOR = '\t', ROWTERMINATOR = '0x0a');
--1b.Run a SELECT TOP 10 * against the newly created table and include a screenshot.
SELECT TOP 10 * FROM RX_new;

--2. Before we get started applying calculations to figure out the MME, we need to see which drugs are in our table. (So that we can apply the correct conversion factor to itsrespective drug).
--2a. Write one query to return DISTINCT drugs and dosage instructions Prior to going any further make sure you note which drugs are taken multiple times a day.
SELECT DISTINCT drugname, dosage_instruct
FROM RX_new;
--2b.Add a new column to your table called fcreq_per_day
ALTER TABLE RX_new
ADD freq_per_day INT;
--2c.Write an update statement utilizing a CASE statement to set freq_per_day equal to the amount the drug needs to be take per day. Use the query from part a., to figure out all the different “take instructions” variations.
UPDATE RX_new
SET freq_per_day = 
    CASE 
           WHEN dosage_instruct LIKE '%Once daily%' THEN 1
           WHEN dosage_instruct LIKE '%Every 6 hours%' THEN 4
           WHEN dosage_instruct LIKE '%Every 8 hours%' THEN 3
           WHEN dosage_instruct LIKE '%Every 4 hours%' THEN 6
           WHEN dosage_instruct LIKE '%Every hour%' THEN 24
           WHEN dosage_instruct LIKE '%Twice Daily%' THEN 2
           ELSE 0 -- Default assumption of once per dayc
    END;

select * from RX_new

--2d.Using the conversion chart in this week’s module. Write a query to figure out MME/day for each patients MME for ('OxyContin','Oxymorphone','Hydrocodone','Codeine')HINT: You will be writing one big CASE statement as part of yourccc query
SELECT drugname, 
CASE 
    WHEN drugname LIKE '%OxyContin%' THEN dosage * freq_per_day * 1.5
    WHEN drugname LIKE '%Oxymorphone%' THEN dosage * freq_per_day * 3
    WHEN drugname LIKE '%Hydrocodone%' THEN dosage * freq_per_day * 1
    WHEN drugname LIKE '%Codeine%' THEN dosage * freq_per_day * 0.15
    ELSE 0
END AS MME_day
FROM RX_new
WHERE drugname IN ('OxyContin','Oxymorphone','Hydrocodone','Codeine'); 


--2e.Write the same query as part d above, but sum MME by drugname. Show a screenshot of the output with your code.
UPDATE RX_new
SET freq_per_day = 
    CASE 
        WHEN dosage_instruct LIKE '%Once dailyc%' THEN 1
        WHEN dosage_instruct LIKE '%Every 6 hours%' THEN 4
        WHEN dosage_instruct LIKE '%Every 8 hours%' THEN 3
        WHEN dosage_instruct LIKE '%Every 4 hours%' THEN 6
        WHEN dosage_instruct LIKE '%Every hour%' THEN 24
        WHEN dosage_instruct LIKE '%Twice Daily%' THEN 2
        ELSE 1 -- Default assumption of once per day
    END;

SELECT drugname, 
SUM(
	CASE 
                        WHEN drugname LIKE '%Codeine%' THEN dosage * freq_per_day * 0.15 
                        WHEN drugname LIKE '%Hydrocodone%' THEN dosage * freq_per_day * 1 
                        WHEN drugname LIKE '%Oxymorphone%' THEN dosage * freq_per_day * 3 
                        WHEN drugname LIKE '%OxyContin%' THEN dosage * freq_per_day * 1.5 
						ELSE 0 
                    END) AS MME_sum
FROM RX_new
WHERE drugname IN ('Codeine', 'Hydrocodone', 'Oxymorphone', 'OxyContin')
GROUP BY drugname;

--2f What is the total drug cost by drugname by admit_year (sort descending by total cost)?
SELECT RX_new.drugname, SUM(RX_new.dosage * RX_new.dosage_instruct * RX_new.cost) AS total_cost
FROM RX_new
INNER JOIN readmission ON RX_new.accountno = readmission.patient_no
WHERE RX_new.drugname IN ('Codeine', 'Hydrocodone', 'Oxymorphone', 'OxyContin')
GROUP BY RX_new.drugname, readmission.readmit_date
ORDER BY total_cost DESC;
--2g What is the frequency distribution of patients taking drugs (drugname)?
SELECT RX_new.drugname, COUNT(*) AS frequency 
FROM RX_new
INNER JOIN medical_history ON RX_new.accountno = medical_history.MRN
WHERE RX_new.drugname IN ('Codeine', 'Hydrocodone', 'Oxymorphone', 'OxyContin')
GROUP BY RX_new.drugname
ORDER BY frequency DESC;
--2h Using your substance abuse table from a few weeks ago. Are there any patients on OxyContin that have a prior history of overdose? (Write the code)c
SELECT COUNT(*) AS accountno
FROM RX_new rx
INNER JOIN medical_history mh
ON rx.accountno = mh.MRN
WHERE rx.drugname = 'OxyContin' AND mh.prior_hist_overdose = 'YES';









     
	 

