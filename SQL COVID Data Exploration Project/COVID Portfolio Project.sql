
-- Verifies that data from Excel files imported correctly 

SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY location, date


-- Fields that will be analyzed

SELECT location, date, population, total_cases, new_cases, total_deaths, new_deaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date


-- Compares total_cases and total_deaths to show death percentage in the United States

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%States%' AND continent IS NOT NULL
ORDER BY location, date


-- Compares total_cases and population
-- Shows the percentage of the United States population that contracted Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%States%' AND continent IS NOT NULL
ORDER BY location, date


-- Compares highest infection rates by country

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- Reflects countries with highest death counts

SELECT location, population, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY TotalDeathCount DESC


-- Returns continents with highest death counts

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


---


-- Uses global numbers
-- Shows Covid cases and deaths by day globally

SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths as int)) AS TotalDeaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS GlobalDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date


-- Shows overall international death percentage

SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths as int)) AS TotalDeaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS GlobalDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL


-- Returns total vaccinations by date and location

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location
ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date


-- Uses CTE to find percentage of vaccinated population by date and location

WITH CTE_PopVac (Continent, Location, Date, Population, NewVaccinations, RollingPopulationVaccinated) 
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPopulationVaccinated/Population)*100 AS PercentPopulationVaccinated
FROM CTE_PopVac

-- Uses Temporary Table to find percentage of vaccinated population by date and location 

DROP TABLE IF EXISTS #Temp_PopulationVaccinated
CREATE TABLE #Temp_PopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
NewVaccinations numeric,
RollingPopulationVaccinated numeric
)

INSERT INTO #Temp_PopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPopulationVaccinated/Population)*100 AS PercentPopulationVaccinated
FROM #Temp_PopulationVaccinated
ORDER BY Location, Date


-- Creates view to store data for visualization tools

CREATE VIEW PopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PopulationVaccinated