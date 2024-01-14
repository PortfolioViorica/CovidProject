/*

Queries used for Tableau Project

*/


--1.

Select 
SUM(New_cases) as total_cases, 
SUM(cast(New_deaths as int)) as total_deaths, 
SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
WHERE continent is not null
--group by date
order by 1,2

-- Just a double check based off the table provided
-- numbers are extremely close so we will keep them - The Second includes "International" location

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2

--2
-- Take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProj..CovidDeaths$full
--Where location like %states%
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3. 
-- Showing the continents with the highest death count per population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProj..CovidDeaths$full
Group by Location, Population
order by PercentPopulationInfected desc


--4.

Select Location, Population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
Group by Location,population, date
order by PercentPopulationInfected desc

