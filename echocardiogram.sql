create proc echocardi

as begin

create table readmissions_table(
			patient_no VARCHAR (20) PRIMARY KEY,
			readmit_date DATE,
			hospital VARCHAR,
			);

BULK INSERT [HI_1451_KaitlynHuang].[dbo].[ADMISSIONS]
FROM 'C:\Users\student\Downloads\readmissions.txt'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');

--1.
SELECT a.patient_no
FROM admits a
INNER JOIN readmits r ON a.patient_no = r.patient_no
--2.
SELECT a.patient_no, r.patient_no
FROM admits a
LEFT JOIN readmits r ON a.patient_no = r.patient_no
--3.
SELECT a.hospital, COUNT(*) AS num_patients
FROM admits a
INNER JOIN readmits r ON a.patient_no = r.patient_no
GROUP BY a.hospital
--4. 
CREATE TABLE ICD10 (
	icd10 VARCHAR(100) PRIMARY KEY,
	explaination VARCHAR (200),
	);

BULK INSERT icd10
FROM 'C:\Users\student\Downloads\icd10cm_codes_2018.TXT'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');

DROP TABLE ICD10




		drop table if exists murmur;

		create table murmur (dx_code varchar(15));





		drop table if exists pvd;

		create table pvd(dx_code varchar(15));







		declare @cardiacId int = 34

		while @cardiacId 

			BEGIN

		   DECLARE @insertcardiac NVARCHAR(MAX) = 'INSERT INTO murmur

											          SELECT DISTINCT CODE FROM ICD 

														  WHERE CODE LIKE ''I' + CAST(@cardiacId as nvarchar(3)) + '%'''







		







end --end of main program