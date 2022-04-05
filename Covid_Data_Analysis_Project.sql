select *
From datanalysisportf..Coviddeaths
order by 2,4



--select *
--From datanalysisportf..CovidVaccinations

--order by 3,4

--Selecting data to be used 

select location,date,total_cases,new_cases,total_deaths, population
From datanalysisportf..Coviddeaths
order by 1,2

--total cases vs total deaths 
--show the percentage of death vs total cases

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPersentage
From datanalysisportf..Coviddeaths
Where location like '%kenya%'
order by 1,2


-- Shows percentage of those who got covid in kenya
select location,date,total_cases,population,(total_cases/population)*100 as Infection_Persentage
From datanalysisportf..Coviddeaths
Where location like '%kenya%'
order by 1,2

-- Showing country with high infection rates
select location,Max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as PersentagePopulationInfected
From datanalysisportf..Coviddeaths
Group by location, population 
order by PersentagePopulationInfected desc

-- show countries with hiehest death count per population


select location,Max(cast(total_deaths as int) ) as TotalDeathCount
From datanalysisportf..Coviddeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

-- Death counts by continents

select continent,Max(cast(total_deaths as int) ) as TotalDeathCount
From datanalysisportf..Coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- total population vs vaccination 
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From datanalysisportf..Coviddeaths dea
Join datanalysisportf..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

Where dea.continent is not null

order by 2,3

with  PopVsVac (Continent, location, date, population,new_Vaccinations, RollingPeopleVaccinated) as(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From datanalysisportf..Coviddeaths dea
Join datanalysisportf..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

Where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population) *100
From PopVsVac

--Creating views for later visualization

create view PersentagePopulationVaccinated  as
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From datanalysisportf..Coviddeaths dea
Join datanalysisportf..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

Where dea.continent is not null
--order by 2,3


select *
From PersentagePopulationVaccinated

