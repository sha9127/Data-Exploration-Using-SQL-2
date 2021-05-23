use PortfolioProject

--when First COVID Case Reported in India

select top (1)location as Country, total_cases as First_Case,date
from COVID_Deaths$
where total_cases=1 
	and location like '%India%'

--when First COVID Death  Reported in India

select top (1) location as Country,new_deaths as First_Death,date
from COVID_Deaths$
where new_deaths=1 
	and location like '%India%'

--Highest No of COVID-19 Cases per Day in India in Year 2020

select top (1) Location as Country,new_cases as Max_Case_in_a_Day_2020 , date 
from COVID_Deaths$
where location like '%India%' and date like'%2020%'
order by new_cases desc

--Total No of Cases Vs Deaths Reported in Year 2020

select location as Country,sum(cast(new_cases as int )) as Total_Cases_2020,sum(cast(new_deaths as int )) as Total_Death_2020
from COVID_Deaths$
where location like '%India%' and date like'%2020%'
group by location

--Highest No of COVID-19 Cases per Day in India in Year 2021

select top (1) Location as Country,new_cases as Max_Case_in_a_Day_2021 , date 
from COVID_Deaths$
where location like '%India%' and date like'%2021%'
order by new_cases desc



--Total No of Cases Vs Deaths Reported in Year 2021

select location as Country,sum(cast(new_cases as int )) as Total_Cases_2021,sum(cast(new_deaths as int )) as Total_Death_2021
from COVID_Deaths$
where location like '%India%' and date like'%2021%'
group by location

--Total No of Cases Vs Deaths Reported in India till Now i.e May 21,2021

select location as Country,sum(cast(new_cases as int )) as Total_Cases,sum(cast(new_deaths as int )) as Total_Death
from COVID_Deaths$
where location like '%India%' 
group by location

--Total No of Patient Recoverd in  India till Now i.e May 21,2021

select location as Country,sum(cast(new_cases_smoothed as int )) as Total_Recovered
from COVID_Deaths$
where location like '%India%' 
group by location

--Recovery Rate of COVID Patient In India


select location as Country,sum(cast(new_cases as int )) as Total_Cases,sum(cast(new_cases_smoothed as int )) as Total_Recovered 
,(cast(25495310 as float)/cast(26289290 as float))*100 as Recovery_Rate
from COVID_Deaths$
where location like '%India%' 
group by location


-- Total Case VS Total_Death of  COVID Patient In India

Select Location, date, sum(cast(total_cases as int )) as Total_cases,sum(cast(total_deaths as int )) as Toatal_Death
From PortfolioProject..COVID_Deaths$
Where location like '%India%'
group by Location, date
order by 1,2


--Day by Day analysis of Death Rate of COVID Patient In India

Select Location, date, total_cases,population as Population ,((total_cases/population)*100) as Percentage_of_Population_Infected,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..COVID_Deaths$
Where location like '%India%'
and continent is not null 
order by 1, 2


-- Total Population vs Vaccinations in India

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..COVID_Deaths$ dea
Join PortfolioProject..COVID_Vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like'%India%'
order by 2,3

-- Shows Percentage of Population that has recieved at least one dose of  Covid Vaccine 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From PortfolioProject..COVID_Deaths$ dea
Join PortfolioProject..COVID_Vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null  and dea.location like '%India%'
)

Select *, ((PeopleVaccinated/Population)*100 )as Percentage_of_Population_Vaccinated
From PopvsVac




