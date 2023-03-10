/* COVID 19 data exploration

Skill Used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM [CovidProject].[dbo].[CovidDeaths]

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths


--Total  Cases vs Total Deaths

Select location,  total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From CovidProject..CovidDeaths
Where location like '%desh%' and continent is not null
Order by 3DESC, 4 



-- Total Cases vs Population

Select location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentages
From CovidProject..CovidDeaths
Where location like '%desh%' and continent is not null
Order by 5 




-- Conturies with highest infection rate compare to population

Select location, population, max(total_cases) as HighestCases, max((total_cases/population)*100) as HighestInfectionRate
From [CovidProject].[dbo].[CovidDeaths]
Where location is not null
Group by location, population
Order by 4 DESC


-- Countries with most death count per population

Select Location, max(total_deaths) as highestDeathCount
From [CovidProject].[dbo].[CovidDeaths]
Where location is not null
Group by Location
Order by 1 DESC




-- BREAKING THINGS DOWN BY CONTINENT


-- Showing contintents with the highest death count per population

SELECT continent, Max(cast(total_deaths as bigint)) as highestDeathCount
FROM [CovidProject].[dbo].[CovidDeaths]
Where continent is not null
Group by Continent
Order by highestDeathCount DESC



--GLOBAL NUMBERS

Select  Sum(new_cases) as TotalCase, sum(cast(new_deaths as bigint)) as TotalDeaths, sum(cast(new_deaths as bigint))/Sum(new_cases)*100 as TotalDeathPercentage
FROM [CovidProject].[dbo].[CovidDeaths]
Where continent is not null
Order by 1, 2



---- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT death.continent, death.location, death.date, death.population, Vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by death.location Order by  death.location, death.date) as RollingPPLVacinated
FROM CovidProject..CovidDeaths death
join CovidProject..CovidVaccinations Vac
	on death.location = Vac.location 
	and death.date = vac.date 
Where death.location is not null 
Order by 2, 3


-- Using CTE to perform Calculation on Partition By in previous query

WITH PopulationVSVac (Continent, location, date, population, new_vaccinations, RollingPPLVacinated)
as (
SELECT death.continent, death.location, death.date, death.population, Vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by death.location Order by  death.location, death.date) as RollingPPLVacinated
FROM CovidProject..CovidDeaths death
join CovidProject..CovidVaccinations Vac
	on death.location = Vac.location 
	and death.date = vac.date 
Where death.continent is not null 

)

Select *, (RollingPPLVacinated/population)*100 as pop_Vac_rate
From PopulationVSVac



--TEMP TABLE

DROP TABLE if exists  #PercentPopVaccinated
CREATE TABLE #PercentPopVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingPPLVacinated numeric 
)

INSERT INTO #PercentPopVaccinated
SELECT death.continent, death.location, death.date, death.population, Vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by death.location Order by  death.location, death.date) as RollingPPLVacinated
FROM CovidProject..CovidDeaths death
join CovidProject..CovidVaccinations Vac
	on death.location = Vac.location 
	and death.date = vac.date 
Where death.continent is not null 

Select *, (RollingPPLVacinated/population)*100 as pop_Vac_rate
From #PercentPopVaccinated




-- Create view for late visualization and store data

CREATE VIEW PercentPopVaccinated
as
SELECT death.continent, death.location, death.date, death.population, Vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by death.location Order by  death.location, death.date) as RollingPPLVacinated
FROM CovidProject..CovidDeaths death
join CovidProject..CovidVaccinations Vac
	on death.location = Vac.location 
	and death.date = vac.date 
Where death.continent is not null 
--Order by 2, 3

Select *
FROM PercentPopVaccinated