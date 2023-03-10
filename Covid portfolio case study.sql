
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
Where location = 'Serbia'
order by 1,2

--Looking at Total Cases vs Total Deaths in Serbia
-- Shows death percentage if you contract Covid19

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Serbia'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT Location, date, population, total_cases, (total_cases/population)*100 as InfectionRate
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Serbia'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionRate
FROM PortfolioProject..CovidDeaths$
--WHERE location = 'Serbia'
GROUP BY population, location
ORDER BY InfectionRate DESC

--Showing Countries with Highest Death count per Population
SELECT Location,continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is not null
GROUP BY location, continent
ORDER BY TotalDeathCount DESC


--Showing continents with Highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is not null and location not like '%income%'
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER by dea.location, dea.date)
  as TotalVaccinationbyDate
from PortfolioProject..CovidDeaths$ as dea
Join PortfolioProject..Covid19Vaccinations$ as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, TotalVaccinationbyDate)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER by dea.location, dea.date)
  as TotalVaccinationbyDate
from PortfolioProject..CovidDeaths$ as dea
Join PortfolioProject..Covid19Vaccinations$ as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)

Select *, (TotalVaccinationbyDate/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View ContinentsHighestDeathCount as
SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is not null and location not like '%income%'
GROUP BY continent


Select *
From ContinentsHighestDeathCount