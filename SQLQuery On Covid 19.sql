Select *
From portfolioproject..CovidDeaths
Order by 3,4

Select *
From portfolioproject..CovidVaccinations
Order by 3,4

--Now we will be looking at some questions about these tables drawing insight from them.

--Q1: Show the highest number of confirmed coronavirus cases the world has recorded daily.
--Return a table with a record of 10 highest number of confirmed coronavirus cases in the 
--world to date and do not display the affected countries.

Select DISTINCT TOP 10 date, new_cases
From portfolioproject..CovidDeaths
Where continent is not null
Order by 2 DESC

--Q2:We would like to know if a death toll of over 1000 has been recorded on any day as a 
--result of the coronavirus to date. Do not mention the affected countries.

Select Top 10 date, new_deaths
From portfolioproject..CovidDeaths
Where new_deaths >=1000
Order by 2 DESC

--Q3: Return a record of all coronavirus affected countries with the keyword ‘United’.

Select Distinct location
From portfolioproject..CovidDeaths
Where location like '%united%'
Order by 1


--Q4: Return a record of all confirmed coronavirus cases contained on the 11th and 
--15th of April, 2020.

Select date, new_cases
From portfolioproject..CovidDeaths
Where new_cases is not null and date between '2020-04-11' and  '2020-04-15'

--Q5:Return a record of all coronavirus affected countries with names outside the 
--United Kingdom, Canada, and the United States.

Select Distinct location
From portfolioproject..CovidDeaths
Where location not in ('United Kingdom', 'Canada', 'United States') and continent is not null
Order by 1;

--Q6:Return a record of all coronavirus affected countries without the keyword ‘United’.

Select Distinct location
From portfolioproject..CovidDeaths
Where location not like '%united%' and continent is not null
Order by 1;

--Q7:Return a record of all coronavirus affected countries with names within the 
--United Kingdom, United Arab Emirates, United Republic of Tanzania, United States 
--Virgin Islands and the United States of America and select only countries with ids 
--between 193 and 196.

Select *
From portfolioproject..CovidDeaths
Where location in ('united kingdom', 'united arab emirates', 'united republic of tanzana', 'united state virgin island',
'united states of america')

--Q8: Return a record of all the death toll associated with the United States of 
--America to date.

Select location, date, new_deaths, convert(int, total_deaths) as TotalDeaths
From portfolioproject..CovidDeaths
Where location in ('United States') and total_deaths is not null --and new_deaths is not null
Order by 2,3 DESC;

--Q9:Return the record of coronavirus confirmed cases and deaths with countries 
--starting with the letter ‘C’ in ascending order to date.

Select location, date, convert(int, total_cases) as TotalCases, convert(int, total_deaths) as TotalDeaths
From portfolioproject..CovidDeaths
Where location like 'C%'
Order by 1,2

--Q10:Return the total number of coronavirus confirmed cases and deaths since the 
--inception of the disease in the world.

Select MAX(cast(total_cases as int)) as TotalCases, MAX(cast(total_deaths as int)) as TotalDeaths
From portfolioproject..CovidDeaths
--Where total_cases is not null and total_deaths is not null

--Q11:Return an average of the coronavirus death toll for France.

Select location, AVG(convert(int, total_deaths)) as TotalDeath
From portfolioproject..CovidDeaths
Where location like '%France%'
Group By location

--Q12:Return a record of 10 countries with the highest average number of the 
--coronavirus death toll.

Select Top 10 location, AVG(convert(int, total_deaths)) as TotalDeath
From portfolioproject..CovidDeaths
Where continent is not null
Group By location
Order By TotalDeath DESC;

--Q13:Return the highest number of coronavirus cases ever in China

Select location, Max(convert(int,total_cases)) HighestCase
from portfolioproject..CovidDeaths
Where location like '%china%'
Group By location


--Q14:Return the lowest number of coronavirus cases ever in the United States of America(USA)

Select location, MIN(convert(int, new_cases)) LeastCases
From portfolioproject..CovidDeaths
Where location in ('united states')
Group By location

--Q15:Return a record of all coronavirus affected countries with their highest 
--number of cases in descending order.

Select location, MAX(convert(int, total_cases)) as TotalCases
From portfolioproject..CovidDeaths
Where continent is not null
Group by location
Order by TotalCases DESC

--Q16:Return a record of coronavirus affected countries and their population 
--in descending order.

Select location, MAX(convert(int, total_deaths)) as TotalDeaths
From portfolioproject..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeaths DESC

--Q17:Return a record of coronavirus affected countries with a population of 
--above 200,000,000.

Select Distinct location, population
From portfolioproject..CovidDeaths
Where continent is not null and population > '200000000'
Order by population DESC

