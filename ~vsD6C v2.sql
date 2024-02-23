--select*
--from data..[covid vacination]


select*
from data..[covid vacination]
where continent is not null
order by 3,4

--Selecting the data we are going to be using 

Select location, date, total_cases, new_cases, total_deaths, population
from data..[covid death]
where continent is not null
order by 1,2


--Checking out total_case vs total_death
--And also shows the likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths,
       CAST(total_deaths AS DECIMAL(18, 2)) / total_cases *100 AS deathPercentage
FROM data..[covid death]
--where location like '%states%'
where continent is not null
ORDER BY 1, 2

--total cases vs population
--shows what percentage of people got covid

SELECT location, date, population,total_cases,
       CAST(total_cases AS DECIMAL(18, 2)) / population *100 AS infectedPercentage
FROM data..[covid death]
--where location like '%states%'#
where continent is not null
ORDER BY 1,2

--countries with the highest infectious rate

SELECT location, population, MAX(CAST(total_cases AS DECIMAL(18, 2))) AS highestInfectionCount,
       MAX(CAST(total_cases AS DECIMAL(18, 2)) / population) *100 AS infectedPercentage
FROM data..[covid death]
--where location like '%italy%'
where continent is not null
Group by location, population 
ORDER BY infectedPercentage desc


SELECT location, population,
       MAX(CAST(total_cases AS DECIMAL(18, 2))) AS highestInfectionCount,
       MAX(CAST(total_cases AS DECIMAL(18, 2)) / population) * 100 AS infectedPercentage
FROM data..[covid death] -- Assuming this is the correct table name
--WHERE location LIKE '%states%'
where continent is not null
GROUP BY location, population
ORDER BY infectedPercentage DESC;

--Showing country with the highest death count per population


SELECT location, MAX(cast(total_deaths as int)) as totalDeathCount
FROM data..[covid death] 
--WHERE location LIKE '%states%'
where continent is not null
GROUP BY location
ORDER BY totalDeathCount DESC


--showing the continent with the highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as totalDeathCount
FROM data..[covid death] 
--WHERE location LIKE '%states%'
where continent is null
GROUP BY location
ORDER BY totalDeathCount DESC



--Total population vs vacination

With PopvsVac (continent, location, date, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population,
       SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM data..[covid death] AS dea
JOIN data..[covid vacination] AS vac
ON dea.location = vac.location
AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL
)
select *
from PopvsVac

 
 
