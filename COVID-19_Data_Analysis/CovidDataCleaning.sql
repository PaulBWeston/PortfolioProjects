#COVID-19 Portfolio Project 
#Data Cleaning
#by Paul Weston
#Below we clean the data of 4 tables from 3 separate datasets

#Table of contents:
#1) Fix datatype issues created while importing the data - begins line 17
#2) Standardize location/state names in US datasets - begins line 238
	#In USCovidVaccinations, use case statement to change state names to abbreviations
    #In USCovidDeaths, use temp table and joins to combine New York State and New York City - line 316
    

Use `PortfolioProject`;

SET SQL_SAFE_UPDATES = 0;

#1) Datatype issues
#Data was imported using MySQL Workbench's Data Import Wizard
#many of the field data types are incorrect and interpreted as strings
#to avoid losing data, we will create new columns with the appropriate data types
#and move casted data into them. 


#First, in GlobalCovidDeaths, we will convert the fields date, total_deaths, and new_deaths 
SELECT *
FROM GlobalCovidDeaths;

#In GlobalCovidDeaths, convert date field to date data type
SELECT date, str_to_date(date, '%m/%d/%Y')
FROM GlobalCovidDeaths;

ALTER TABLE GlobalCovidDeaths
ADD COLUMN NewDate date AFTER date;

UPDATE GlobalCovidDeaths
SET NewDate = str_to_date(date, '%m/%d/%Y');

#In GlobalCovidDeaths, convert total_deaths to INT
SELECT total_deaths, cast(total_deaths AS unsigned) AS total_deathsINT
FROM GlobalCovidDeaths
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidDeaths
ADD COLUMN total_deathsINT INT AFTER total_deaths;

UPDATE GlobalCovidDeaths
SET total_deathsINT = cast(total_deaths AS unsigned);

#In GlobalCovidDeaths, convert new_deaths to INT
SELECT new_deaths, cast(new_deaths AS signed) AS new_deathsINT
FROM GlobalCovidDeaths
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidDeaths
ADD COLUMN new_deathsINT INT AFTER new_deaths;

UPDATE GlobalCovidDeaths
SET new_deathsINT = cast(new_deaths AS signed);

#In GlobalCovidVaccinations we will convert the fields date, total_vaccinations, 
#people_vaccinated, people_fully_vaccinated, total_boosters, and new_vaccinations
SELECT *
FROM GlobalCovidVaccinations;

#In GlobalCovidVaccinations, convert date field to date data type
SELECT date, str_to_date(date, '%m/%d/%Y')
FROM GlobalCovidVaccinations;

ALTER TABLE GlobalCovidVaccinations
ADD COLUMN NewDate date AFTER date;

UPDATE GlobalCovidVaccinations
SET NewDate = str_to_date(date, '%m/%d/%Y');

#In GlobalCovidVaccinations, convert total_vaccinations to BIGINT
SELECT total_vaccinations, cast(total_vaccinations AS signed) AS total_vaccinationsINT
FROM GlobalCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidVaccinations
ADD COLUMN total_vaccinationsINT BIGINT AFTER total_vaccinations;

UPDATE GlobalCovidVaccinations
SET total_vaccinationsINT = cast(total_vaccinations AS signed);

#In GlobalCovidVaccinations, convert people_vaccinated to BIGINT
SELECT people_vaccinated, cast(people_vaccinated AS signed) AS people_vaccinatedINT
FROM GlobalCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidVaccinations
ADD COLUMN people_vaccinatedINT BIGINT AFTER people_vaccinated;

UPDATE GlobalCovidVaccinations
SET people_vaccinatedINT = cast(people_vaccinated AS signed);

#In GlobalCovidVaccinations, convert people_fully_vaccinated to BIGINT
SELECT people_fully_vaccinated, cast(people_fully_vaccinated AS signed) AS people_fully_vaccinatedINT
FROM GlobalCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidVaccinations
ADD COLUMN people_fully_vaccinatedINT BIGINT AFTER people_fully_vaccinated;

UPDATE GlobalCovidVaccinations
SET people_fully_vaccinatedINT = cast(people_fully_vaccinated AS signed);

#In GlobalCovidVaccinations, convert total_boosters to BIGINT
SELECT total_boosters, cast(total_boosters AS signed) AS total_boostersINT
FROM GlobalCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidVaccinations
ADD COLUMN total_boostersINT BIGINT AFTER total_boosters;

UPDATE GlobalCovidVaccinations
SET total_boostersINT = cast(total_boosters AS signed);

#In GlobalCovidVaccinations, convert new_vaccinations to BIGINT
SELECT new_vaccinations, cast(new_vaccinations AS signed) AS new_vaccinationsINT
FROM GlobalCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE GlobalCovidVaccinations
ADD COLUMN new_vaccinationsINT BIGINT AFTER new_vaccinations;

UPDATE GlobalCovidVaccinations
SET new_vaccinationsINT = cast(new_vaccinations AS signed);

#In USCovidDeaths we will convert the fields submission_date, prob_death, and pnew_death
SELECT *
FROM  USCovidDeaths;

#In USCovidDeaths, convert submission_date to date
SELECT submission_date, str_to_date(submission_date, '%m/%d/%Y')
FROM USCovidDeaths
Order by 2;

ALTER TABLE USCovidDeaths
ADD COLUMN NewSubmit_Date date AFTER submission_date;

UPDATE USCovidDeaths
SET NewSubmit_Date = str_to_date(submission_date, '%m/%d/%Y');

#In USCovidDeaths, convert prob_death to int
SELECT prob_death, cast(prob_death AS signed) AS prob_deathINT
FROM USCovidDeaths
ORDER BY 2 DESC;

ALTER TABLE USCovidDeaths
ADD COLUMN prob_deathINT INT AFTER prob_death;

UPDATE USCovidDeaths
SET prob_deathINT = cast(prob_death AS signed);

#In USCovidDeaths, convert pnew_death to int
SELECT pnew_death, cast(pnew_death AS signed) AS pnew_deathINT
FROM USCovidDeaths
ORDER BY 2 DESC;

ALTER TABLE USCovidDeaths
ADD COLUMN pnew_deathINT INT AFTER pnew_death;

UPDATE USCovidDeaths
SET pnew_deathINT = cast(pnew_death AS signed);

#In USCovidVaccinations, we will convert date, total_vaccinaton, people_vaccinated, 
#people_fully_vaccinated_per_hundred, people_fully_vaccinated, and people_vaccinated_per_hundred
SELECT *
FROM USCovidVaccinations;

#In USCovidVaccinations, convert date field to date data type
SELECT date, str_to_date(date, '%m/%d/%Y')
FROM USCovidVaccinations
Order by 2;

ALTER TABLE USCovidVaccinations
ADD COLUMN NewDate date AFTER date;

UPDATE USCovidVaccinations
SET NewDate = str_to_date(date, '%m/%d/%Y');

#In USCovidVaccinations, convert total_vaccinations to int
SELECT total_vaccinations, cast(total_vaccinations AS signed) AS total_vaccinationsINT
FROM USCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE USCovidVaccinations
ADD COLUMN total_vaccinationsINT BIGINT AFTER total_vaccinations;

UPDATE USCovidVaccinations
SET total_vaccinationsINT = cast(total_vaccinations AS signed);

#In USCovidVaccinations, convert people_vaccinated to int
SELECT people_vaccinated, cast(people_vaccinated AS signed) AS people_vaccinatedINT
FROM USCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE USCovidVaccinations
ADD COLUMN people_vaccinatedINT BIGINT AFTER people_vaccinated;

UPDATE USCovidVaccinations
SET people_vaccinatedINT = cast(people_vaccinated AS signed);

#In USCovidVaccinations, convert people_fully_vaccinated_per_hundred to double
SELECT people_fully_vaccinated_per_hundred, cast(people_fully_vaccinated_per_hundred AS double) AS people_fully_vaccinated_per_hundredNUM
FROM USCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE USCovidVaccinations
ADD COLUMN people_fully_vaccinated_per_hundredNUM double AFTER people_fully_vaccinated_per_hundred;

UPDATE USCovidVaccinations
SET people_fully_vaccinated_per_hundredNUM = cast(people_fully_vaccinated_per_hundred AS double);

#In USCovidVaccinations, convert people_fully_vaccinated to int
SELECT people_fully_vaccinated, cast(people_fully_vaccinated AS signed) AS people_fully_vaccinatedINT
FROM USCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE USCovidVaccinations
ADD COLUMN people_fully_vaccinatedINT BIGINT AFTER people_fully_vaccinated;

UPDATE USCovidVaccinations
SET people_fully_vaccinatedINT = cast(people_fully_vaccinated AS signed);

#In USCovidVaccinations, convert people_vaccinated_per_hundred to double
SELECT people_vaccinated_per_hundred, cast(people_vaccinated_per_hundred AS double) AS people_vaccinated_per_hundredNUM
FROM USCovidVaccinations
ORDER BY 2 DESC;

ALTER TABLE USCovidVaccinations
ADD COLUMN people_vaccinated_per_hundredNUM double AFTER people_vaccinated_per_hundred;

UPDATE USCovidVaccinations
SET people_vaccinated_per_hundredNUM = cast(people_vaccinated_per_hundred AS double);

#2) Standardize location/state names in US datasets

#Change location names in USCovidVaccinations to state abbreviations
SELECT DISTINCT Location
FROM USCovidVaccinations;

ALTER TABLE USCovidVaccinations
ADD COLUMN State varchar(10) AFTER Location;

UPDATE USCovidVaccinations
SET State =
	CASE location
		WHEN 'Alabama' THEN 'AL' 
		WHEN 'Alaska' THEN 'AK' 
		WHEN 'Arizona' THEN 'AZ' 
		WHEN 'Arkansas' THEN 'AR' 
		WHEN 'California' THEN 'CA' 
		WHEN 'Colorado' THEN 'CO' 
		WHEN 'Connecticut' THEN 'CT' 
		WHEN 'Delaware' THEN 'DE' 
		WHEN 'District of Columbia' THEN 'DC' 
		WHEN 'Florida' THEN 'FL' 
		WHEN 'Georgia' THEN 'GA' 
		WHEN 'Hawaii' THEN 'HI' 
		WHEN 'Idaho' THEN 'ID' 
		WHEN 'Illinois' THEN 'IL' 
		WHEN 'Indiana' THEN 'IN' 
		WHEN 'Iowa' THEN 'IA' 
		WHEN 'Kansas' THEN 'KS' 
		WHEN 'Kentucky' THEN 'KY' 
		WHEN 'Louisiana' THEN 'LA' 
		WHEN 'Maine' THEN 'ME' 
		WHEN 'Maryland' THEN 'MD' 
		WHEN 'Massachusetts' THEN 'MA' 
		WHEN 'Michigan' THEN 'MI' 
		WHEN 'Minnesota' THEN 'MN' 
		WHEN 'Mississippi' THEN 'MS' 
		WHEN 'Missouri' THEN 'MO' 
		WHEN 'Montana' THEN 'MT' 
		WHEN 'Nebraska' THEN 'NE' 
		WHEN 'Nevada' THEN 'NV' 
		WHEN 'New Hampshire' THEN 'NH' 
		WHEN 'New Jersey' THEN 'NJ' 
		WHEN 'New Mexico' THEN 'NM' 
		WHEN 'New York State' THEN 'NY' 
		WHEN 'North Carolina' THEN 'NC' 
		WHEN 'North Dakota' THEN 'ND' 
		WHEN 'Ohio' THEN 'OH' 
		WHEN 'Oklahoma' THEN 'OK' 
		WHEN 'Oregon' THEN 'OR' 
		WHEN 'Pennsylvania' THEN 'PA' 
		WHEN 'Rhode Island' THEN 'RI' 
		WHEN 'South Carolina' THEN 'SC' 
		WHEN 'South Dakota' THEN 'SD' 
		WHEN 'Tennessee' THEN 'TN' 
		WHEN 'Texas' THEN 'TX' 
		WHEN 'Utah' THEN 'UT' 
		WHEN 'Vermont' THEN 'VT' 
		WHEN 'Virginia' THEN 'VA' 
		WHEN 'Washington' THEN 'WA' 
		WHEN 'West Virginia' THEN 'WV' 
		WHEN 'Wisconsin' THEN 'WI' 
		WHEN 'Wyoming' THEN 'WY' 
		ELSE NULL
	END;
# Territories if we ant to include them
#        WHEN 'Puerto Rico' THEN 'PR'
#        WHEN 'Northern Mariana Islands' THEN 'MP'
#        WHEN 'Marshall Islands' THEN 'RMI'
#        WHEN 'VIrgin Islands' THEN 'VI'
#        WHEN 'American Samoa' THEN 'AS'
#        WHEN 'Guam' THEN 'GU'
#        WHEN 'Federated States of Micronesia' THEN 'FSM'


SELECT DISTINCT Location, state
FROM USCovidVaccinations;

#Next, for USCovidDeaths, the field "State" includes New York City as NYC and 
#does not include NYC's numbers in the counts of New York (NY)
#To solve this, we will first change NY to NYS (New York State)
#We will then insert a new NY entry for each date which will be empty other than the fields "submission_date" and "State"
#We will then update our new NY entries as a sum of NYS and NYC

SELECT DISTINCT State
FROM USCovidDeaths;

#Change all NY to NYS (New York State)
Select submission_date, NewSubmit_date, State
FROM USCovidDeaths
WHERE State = 'NY'
ORDER BY NewSubmit_date;

UPDATE USCovidDeaths
SET State = 'NYS'
WHERE State = 'NY';

#For a quick, although nonideal solution, we will use Excel to create our new NY entries
#Create a table, BlankNYCOVIDDeaths, in Excel that's like USCovidDeaths but only contains the date, state set to NY, but is otherwise null
#Import the new Table BlankNYCOVIDDeaths and then insert into USCovidVaccinations
#Import done via MySQL Workbench's Table DataImportWizard

INSERT INTO USCovidDeaths
SELECt * FROM BlankNYCOVIDDeaths;

#DataImportWizard did not import submission_date field as a date data type
#Correcting this:
SELECT submission_date, str_to_date(submission_date, '%m/%d/%Y')
FROM USCovidDeaths
WHERE State = 'NY'
Order by 2;

UPDATE USCovidDeaths
SET NewSubmit_Date = str_to_date(submission_date, '%m/%d/%Y')
WHERE State = 'NY';

#Create Temp Table of NYC and NYS fields combined 
DROP TEMPORARY TABLE IF EXISTS TempNYTotals;
CREATE TEMPORARY TABLE TempNYTotals
Select newsubmit_Date, 'NY' AS State, 
	sum(tot_cases) AS tot_cases, #These are the fields we will be working with in our exploration and analysis
	sum(tot_death) AS tot_death, 
    sum(prob_deathINT) AS prob_deathINT,
    sum(new_death) as new_death,
    sum(pnew_deathINT) as pnew_deathINT
FROM USCovidDeaths
WHERE State = 'NYC' or State = 'NYS'
GROUP BY NewSubmit_Date
ORDER BY newsubmit_Date DESC;

Select *
FROM TempNYTotals;

#Next we will join our temp table and USCovidDeaths
#But, before we do, there is no unique identifier column (and thus no primary key) for USCovidDeaths
#And so first, we will construct a composite key to use in our joins
ALTER TABLE USCovidDeaths
ADD CONSTRAINT NewPrimaryKey PRIMARY KEY (newsubmit_date, State);

Select *
FROM USCovidDeaths AS USCD 
JOIN TempNYTotals AS TEMP
 ON USCD.newsubmit_date = temp.newsubmit_date
 AND USCD.state = temp.state
ORDER BY USCD.newsubmit_date DESC;

Update USCovidDeaths AS USCD 
JOIN TempNYTotals as temp 
ON
	USCD.newsubmit_date = temp.newsubmit_date
    AND USCD.state = temp.state
SET 
	USCD.tot_cases = temp.tot_cases,
    USCD.tot_death = temp.tot_death,
    USCD.prob_deathINT = temp.prob_deathINT,
    USCD.new_death = temp.new_death,
    USCD.pnew_deathINT = temp.pnew_deathINT
Where USCD.State = 'NY';

Select *
FROM USCovidDeaths
WHERE State = 'NY' OR State = 'NYS' OR STATE = 'NYC'
ORDER BY NewSubmit_Date DESC; #It Worked!

