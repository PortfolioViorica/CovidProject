--Select *
--from [PortfolioProj].[dbo].[CovidDeaths$full]
--order by 3,4 

Select *
from [PortfolioProj].[dbo].[CovidVaccinations]
Where continent is not null
order by 3,4 

Select Location,date, total_cases, new_cases, 
        total_deaths, population
from [PortfolioProj].[dbo].[CovidDeaths$full]
order by 1,2

--- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid
Select Location,date, total_cases, 
        total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [PortfolioProj].[dbo].[CovidDeaths$full]
where location like '%states%'
order by 1,2

--- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location,date, total_cases, population, 
        total_deaths, (total_cases/population)*100 as PercentPopulationInfected
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population

Select Location,population,  MAX(total_cases) as HighestInfectionCount, 
		Max((total_cases/population))*100 as PercentPopulationInfected
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
Group by Location,population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population 
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
Group by Location
order by TotalDeathCount desc

Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Let's Break Things Down By continent

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
Where continent is  null
Group by continent
order by TotalDeathCount desc

-- Showing the continents with the highest death count per population

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select Date,
SUM(New_cases) as total_cases, 
SUM(cast(New_deaths as int)) as total_deaths, 
SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
WHERE continent is not null
group by date
order by 1,2

--Let's exclude date to obtain a different view

Select 
SUM(New_cases) as total_cases, 
SUM(cast(New_deaths as int)) as total_deaths, 
SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from [PortfolioProj].[dbo].[CovidDeaths$full]
--where location like '%states%'
WHERE continent is not null
--group by date
order by 1,2

---- Looking at Total Population vs Vaccination by using CTE table view

With #PercentPopulationVaccinated
  (Continent, Location, Date, Population
, New_Vaccination, RollingPeopleVaccinated)
as
(
select dea.continent, 
dea.location, dea.date, 
dea.population, dea.new_vaccinations_smoothed
, SUM(CONVERT(int, dea.new_vaccinations_smoothed )) OVER (Partition by dea.Location Order by dea.location
  , dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProj..CovidDeaths$full dea
Join PortfolioProj..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



---Temp Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, 
dea.population, dea.new_vaccinations_smoothed
, SUM(CONVERT(int, dea.new_vaccinations_smoothed )) OVER (Partition by dea.Location Order by dea.location
  , dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProj..CovidDeaths$full dea
Join PortfolioProj..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3 

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--Creating View to store data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, 
dea.population, dea.new_vaccinations_smoothed
, SUM(CONVERT(int, dea.new_vaccinations_smoothed )) OVER (Partition by dea.Location Order by dea.location
  , dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProj..CovidDeaths$full dea
Join PortfolioProj..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
--order by 2,3 

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



