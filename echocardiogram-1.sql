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
FROM admit a
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


--5a. 
DROP PROCEDURE IF EXISTS echocardiogram;

CREATE PROCEDURE echocardiogram
AS
BEGIN

    DROP TABLE IF EXISTS cardiac_murmur;
    CREATE TABLE cardiac_murmur (dx_code VARCHAR(15));
    

    DECLARE @cardiacId INT = 34;
    WHILE @cardiacId <= 37
    BEGIN
        DECLARE @dxCode VARCHAR(15) = 'I' + CAST(@cardiacId AS VARCHAR(2)) + '.%';
        INSERT INTO cardiac_murmur (dx_code)
        SELECT DISTINCT @dxCode
        FROM ICD10
        WHERE @dxCode LIKE @dxCode;
        SET @cardiacId = @cardiacId + 1;
    END;
END;
--5b
DROP TABLE IF EXISTS PVD;
CREATE TABLE PVD (dx_code VARCHAR(15));

DECLARE @pvd_id INT = 70;

WHILE @pvd_id <= 79
BEGIN
    DECLARE @insert_pvd NVARCHAR(MAX) = 'INSERT INTO PVD
                                        SELECT DISTINCT CODE FROM ICD
                                        WHERE CODE LIKE ''I' + CAST(@pvd_id as NVARCHAR(3)) + '.%''';
    EXEC sp_executesql @insert_pvd;
    SET @pvd_id = @pvd_id + 1;
END;

DECLARE @pvd_id2 INT = 790;
WHILE @pvd_id2 <= 799
BEGIN
    DECLARE @insert_pvd2 NVARCHAR(MAX) = 'INSERT INTO PVD
                                         SELECT DISTINCT CODE FROM ICD
                                         WHERE CODE LIKE ''I' + CAST(@pvd_id2 as NVARCHAR(3)) + '%''';
    EXEC sp_executesql @insert_pvd2;
    SET @pvd_id2 = @pvd_id2 + 1;
END;

DROP TABLE ICD10




		DROP TABLE if exists hypertension;
		CREATE TABLE hypertension (dx_code varchar(18)
		);
		DECLARE @hypertensionId INT = 10; 
		WHILE @hypertensionId <= 16
BEGIN
    DECLARE @insertHypertension NVARCHAR(MAX) = 'INSERT INTO hypertension
                                                 SELECT DISTINCT CODE FROM ICD
                                                 WHERE CODE LIKE ''I' + CAST(@hypertensionId AS NVARCHAR(3)) + '%''';

    EXECUTE sp_executesql @insertHypertension;

    SET @hypertensionId = @hypertensionId + 1;
END;
		
--6. 
EXEC echocardi







		







end --end of main program