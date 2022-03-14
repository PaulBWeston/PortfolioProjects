#COVID-19 Portfolio Project
#Data Exploration
#by Paul Weston

#Table of Contents:
#Overview of U.S. Covid Deaths and Vaccinations - begins line 13
#Overview of Global Covid Deaths and Vaccinations - begins line 41
#Case Fatality Rate - begins line 72
#Data Visualizations - begins line 132

Use `PortfolioProject`;

#Overview of U.S. Covid Deaths and Vaccinations
#Create temp table of US Covid to simplify future queries
DROP TABLE IF EXISTS OverviewUSCovid;
CREATE TEMPORARY TABLE OverviewUSCovid
SELECT USCD.state, USCD.newsubmit_date AS Date, USCD.new_death AS new_deaths, USCD.tot_death AS total_deaths,
	USVac.people_vaccinatedINT AS people_vaccinated, USVac.total_vaccinationsINT AS total_vaccinations
FROM USCovidDeaths AS USCD
JOIN USCovidVaccinations AS USVac
	ON USCD.NewSubmit_date = USVac.NewDate #Note: date is constrained to USCovidVaccinations
    AND USCD.state = USVac.state
WHERE USVac.State is not null #This will exclude territories, although is not necessary
ORDER BY 2 ASC;

SELECT *
FROM OverviewUSCovid;

#Daily total deaths and total vaccinations
SELECT Date, Sum(total_deaths), Sum(total_vaccinations)
FROM OverviewUSCovid
GROUP BY Date
ORDER BY 2 DESC;

#Most recent numbers by state
SELECT State, max(total_deaths), max(total_vaccinations) #max function works because total_deaths and total_vaccinations is only increasing
FROM OverviewUSCovid
GROUP BY State
ORDER BY 3 DESC;

#Overview of Global Covid Deaths and Vaccinations
#Again, create temp table to simplify future queries
DROP TABLE IF EXISTS OverviewGlobalCovid;
CREATE TEMPORARY TABLE OverviewGlobalCovid
Select GDea.NewDate AS Date, GDea.Location, GDea.continent, GDea.population, GDea.total_cases, GDea.total_deathsINT AS total_deaths,
	GVacs.total_vaccinationsINT as total_vaccinations, GVacs.people_vaccinatedINT, GVacs.people_fully_vaccinatedINT
FROM GlobalCovidDeaths AS GDea
JOIN GlobalCovidVaccinations AS GVacs
	ON GDea.location = GVacs.location
    AND GDea.NewDate = GVacs.NewDate;

#Global total deaths and total vaccinations
SELECT Date, Sum(total_deaths), Sum(total_vaccinations)
FROM OverviewGlobalCovid
WHERE continent IS NOT NULL #Global numbers include continental sums which will cause double counting
GROUP BY Date
ORDER BY 1 DESC;

#Most recent numbers by country
SELECT Location, max(total_deaths), max(total_vaccinations)
FROM OverviewGlobalCovid
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY 2 DESC;

#looking at continents
SELECT date, location, total_deaths, total_vaccinations
FROM OverviewGlobalCovid
WHERE Continent IS NULL
ORDER BY 3 DESC;

#Case fatality rate, looking at likelihood of dying from covid
#First, by country
Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathRate
FROM OverviewGlobalCovid
ORDER BY 1,2;

#Case fatality rate totals by country
Select location, sum(total_cases), sum(total_deaths), (sum(total_deaths)/sum(total_cases))*100 AS DeathRate
FROM OverviewGlobalCovid
GROUP BY location
ORDER BY DeathRate DESC;

#Case fatality rate in the united states
Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathRate
FROM OverviewGlobalCovid
WHERE location like "%state%"
order by 2 DESC;

#Case fatality rate by state in the United States
SELECT  state, sum(tot_cases), sum(tot_death), (sum(tot_death)/sum(tot_cases))*100 AS DeathRate
FROM USCovidDeaths
WHERE state <> 'NYC'
	AND state <> 'NYS'
GROUP BY state
ORDER BY DeathRate DESC;

#Query below is to determine recent fatality rate 
#number of deaths in the last 30 days divided by number of cases in the last 30 days
#query continues to time out, but perhaps could be accomplished by creating temp tables or restricting date range?
SELECT a.NewSubmit_date, sum(b.new_cases),sum(b.new_death), (sum(b.new_death)/sum(b.new_cases))*100
FROM USCovidDeaths AS a, USCovidDeaths AS b
WHERE b.NewSubmit_date <= a.NewSubmit_date AND b.NewSubmit_date > a.NewSubmit_date - 30
GROUP BY a.NewSubmit_date;

#global population and vaccinated people
Select location, date, population, people_vaccinatedINT, people_fully_vaccinatedINT
FROM OverviewGlobalCovid;

#Vaccination rate by date and country
Select location, date, population, (people_vaccinatedINT/population) * 100 AS PercentVaccinated, (people_fully_vaccinatedINT/population)*100 AS PercentFullyVaccinated
FROM OverviewGlobalCovid;

#Global vaccination rates
Select location, date, population, (people_vaccinatedINT/population) * 100 AS PercentVaccinated, (people_fully_vaccinatedINT/population)*100 AS PercentFullyVaccinated
FROM OverviewGlobalCovid;

#Global vaccination rate by date
Select date, sum(population), (sum(people_vaccinatedINT)/sum(population)) * 100 AS PercentVaccinated, (sum(people_fully_vaccinatedINT)/sum(population))*100 AS PercentFullyVaccinated
FROM OverviewGlobalCovid
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 3 DESC;

#United States Percent Vaccinated
Select location, date, population, (people_vaccinatedINT/population) * 100 AS PercentVaccinated, (people_fully_vaccinatedINT/population)*100 AS PercentFullyVaccinated
FROM OverviewGlobalCovid
WHERE location Like '%State%'
ORDER BY 4 DESC;


#Data Visualizations for U.S. Covid Dashboard

#Viz #1) Totals for cases, deaths, % people with at least 1 vaccinations
SELECT NewSubmit_date AS Date, sum(tot_cases) AS TotalCases, sum(tot_death) AS TotalDeaths
FROM USCovidDeaths
WHERE STATE <> "NYC"
GROUP BY NewSubmit_Date
ORDER BY 1 DESC
LIMIT 1 OFFSET 1;

SELECT NewDate AS Date, Sum(people_vaccinatedINT) AS People_Vaccinated
FROM USCovidVaccinations
WHERE State <> 'NYC'
GROUP BY NewDate
ORDER BY 1 DESC
LIMIT 1;


#Viz #2) Likelihood of Dying V.S. Vaccination Rate
#First we need to find the population of U.S. and see if it changes at all
SELECT NewDate, population
FROM GlobalCovidDeaths
WHERE location like '%State%'
	AND NewDate = '2022-01-15';  #1/15/22 is our last date of data for US Covid
#332915074 is population of U.S. and it remains stagnant in our data (although of course is not)

SELECT Dea.NewSubmit_Date AS Date, sum(tot_cases) AS TotalCases, sum(tot_death) AS TotalDeaths, (sum(tot_death)/sum(tot_cases))*100 AS DeathRate, (sum(people_vaccinatedINT) / 332915074) * 100 AS PercentVaccinated
FROM USCovidDeaths Dea
JOIN USCovidVaccinations Vac
	ON Dea.NewSubmit_Date = Vac.NewDate
    AND Dea.State = Vac.State
WHERE Dea.State <> "NYC"
GROUP BY Dea.NewSubmit_date
ORDER BY Date DESC;


#Viz #3) Likelihood of dying by state, map with date slider
Select NewSubmit_Date AS Date, State, tot_cases, tot_death, (tot_death/tot_cases) * 100 AS DeathRate
FROM USCovidDeaths
WHERE State <> 'NYC'
ORDER BY 2,1 DESC;


#Viz #4) Percent of Cases V.S. Percent of Global Deaths
WITH CTE AS 
(Select NewDate, sum(total_cases) AS GlobalCases, sum(total_deaths) AS GlobalDeaths
FROM GlobalCovidDeaths
WHERE Continent is not null
GROUP BY NewDate
ORDER BY 2 DESC)
SELECT location, GCD.NewDate, total_cases AS USCases, total_deathsINT AS USDeaths, cte.GlobalCases,
		cte.GlobalDeaths, (total_cases/cte.GlobalCases) * 100, (total_deathsINT/cte.GlobalDeaths)*100
FROM GlobalCovidDeaths as GCD
JOIN CTE
	ON GCD.NewDate = CTE.NewDate
WHERE location = 'United States'
ORDER BY 2 DESC;



Select date, sum(total_cases)
FROM GlobalCovidDeaths
WHERE Continent is not null
GROUP BY date
ORDER BY 2 DESC;

