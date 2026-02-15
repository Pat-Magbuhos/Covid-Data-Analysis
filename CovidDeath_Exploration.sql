Select * from [Covid Analysis Portfolio] ..CovidDeaths
Where continent is not null
order by 1,2

--Covid Fatality Percentage
CREATE VIEW PhilippinesDeathPercentage AS
Select location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 as DeathPercentage
From [Covid Analysis Portfolio]..CovidDeaths
Where location like '%Philippines'
--order by 1,2

-- Total Cases vs Population
Select location, date, total_cases, population, (CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 as InfectedPercentage
From [Covid Analysis Portfolio]..CovidDeaths
Where location like '%Philippines'
order by 1,2

-- Highest Infection Rate
Select location, population, max(total_cases) as HighestInfectionRate, max(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 as InfectedPercentage
From [Covid Analysis Portfolio]..CovidDeaths
--Where location like '%Philippines'
Group by location, population
order by InfectedPercentage desc

-- Highest Death Rate per Country
Select location, sum(total_deaths) as TotalDeathCount, (sum(cast(total_deaths as FLOAT))/SUM(CAST(total_cases as FLOAT)))*100 as DeathRate
From [Covid Analysis Portfolio]..CovidDeaths
where continent is not null
Group by location
order by DeathRate desc

-- Highest Death Rate per Continent
SELECT continent, SUM(total_deaths) AS TotalDeathCount,(SUM(CAST(total_deaths AS FLOAT)) / SUM(CAST(total_cases AS FLOAT))) * 100 AS DeathRate
FROM [Covid Analysis Portfolio]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathRate DESC

-- Global Death Rate due to Covid
Select sum(cast(total_cases as BIGINT)) as GlobalCases, SUM(cast(total_deaths as BIGINT)) as GlobalDeath, (SUM(CAST(total_deaths as float)) / SUM(CAST(total_cases as float))) * 100 as GlobalDeathRate
FROM [Covid Analysis Portfolio]..CovidDeaths
where continent is not null
order by 1,2

--Total Population vs Vaccination
WITH PopvsVac (continent, location, date, population, New_Vaccinations, CurrentTotalVaccination) AS
(SELECT dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CurrentTotalVaccination
    FROM [Covid Analysis Portfolio]..CovidDeaths dea
    JOIN [Covid Analysis Portfolio]..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, CAST(CurrentTotalVaccination as float)/ cast(population as float)*100 as  VaccinationPercent
FROM PopvsVac
Order by New_Vaccinations asc

--Creating Temp Table
CREATE TABLE #VaccinatedPercent
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
CurrentTotalVaccination numeric
)
INSERT INTO #VaccinatedPercent
SELECT dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CurrentTotalVaccination
    FROM [Covid Analysis Portfolio]..CovidDeaths dea
    JOIN [Covid Analysis Portfolio]..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL

SELECT *, CAST(CurrentTotalVaccination as float)/ cast(population as float)*100 as  VaccinationPercent
FROM #VaccinatedPercent
Order by 2,3
