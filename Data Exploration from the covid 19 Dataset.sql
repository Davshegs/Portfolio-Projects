/*

Exploring Data in SQL Queries

*/


Select *
From portfolioproject..CovidDeaths
Order by 3,4

--Select *
--From portfolioproject..CovidVaccinations
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

Select location, date, total_cases,  total_deaths, population, (cast(total_deaths as float)/total_cases)*100 as DeathPercentage
From portfolioproject..CovidDeaths
Where location like '%states%'
Order by 1,2

Select location, date, total_cases,  total_deaths, population, (total_cases/population)*100 as PercentagePopulationInfected
From portfolioproject..CovidDeaths
--Where location like '%Nigeria%'
Order by 1,2

Select location, population, MAX(total_cases) as HighestInfected, MAX(total_cases/population)*100 as PopulationInfectedPercentagePopulationInfected
From portfolioproject..CovidDeaths
Where continent is not null
Group by location, population
Order by 4 DESC



Select location, MAX(convert(int, total_deaths)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not null
Group by location 
Order by 2 DESC


Select continent, MAX(convert(int, total_deaths)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not  null
Group by continent 
Order by 2 DESC


Select date, SUM(new_cases) as TotalCases, SUM(convert(int, new_deaths)) as TotalDeath, SUM(convert(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage 
From portfolioproject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases) as TotalCases, SUM(convert(int, new_deaths)) as TotalDeath, SUM(convert(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage 
From portfolioproject..CovidDeaths
Where continent is not null
Order by 1,2

Select location, SUM(new_cases) as TotalCases, SUM(convert(int, new_deaths)) as TotalDeath, SUM(convert(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage 
From portfolioproject..CovidDeaths
Where continent is not null
Group by location
Order by 1,2


Select continent, SUM(new_cases) as TotalCases, SUM(convert(int, new_deaths)) as TotalDeath, SUM(convert(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage 
From portfolioproject..CovidDeaths
Where continent is not null
Group by continent
Order by 3 DESC


Select *
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	 and dea.date = vac.date
Order by 3,4


--- Looking at Total Population and Total Vaccination


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


---Using the partition by to do a roll count on new vaccinations on each loaction

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location
	order by dea.location,dea.date) As RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

---Let's look at the total population over the total vaccincation for each locaion.

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location
	order by dea.location,dea.date) As RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
)
Select location, population, (RollingPeopleVaccinated), max((RollingPeopleVaccinated/population)) * 100 As PopVacPercentage
From PopvsVac
Group by location, population, RollingPeopleVaccinated 


--Creating Views for future visualization

Create View RollingPeopleVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location
	order by dea.location,dea.date) As RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Create View DatafromNigeria as
Select location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths
Where location like '%Nigeria%'

Create View TotalDeathCount as 
Select location, MAX(convert(int, total_deaths)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not null
Group by location 