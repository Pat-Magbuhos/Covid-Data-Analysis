Select * from [Covid Analysis Portfolio] ..CovidDeaths
Where continent is not null
order by 1,2

--Covid Fatality Percentage
Select location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 as DeathPercentage
From [Covid Analysis Portfolio]..CovidDeaths
Where location like '%Philippines'
order by 1,2

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

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Covid Analysis Portfolio]..CovidDeaths dea
Join [Covid Analysis Portfolio]..CovidVaccinations vac
	on dea.location =vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by new_vaccinations desc