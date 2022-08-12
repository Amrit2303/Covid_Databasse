SELECT * 
FROM project_covid.covid_deaths
order by 3,4;

SELECT * FROM project_covid.covid_vaccinations
order by 2,4;

select location,date,population
from project_covid.covid_deaths
order by 1,2;

select location,date,population ,new_tests,total_tests_per_thousand, (new_tests/total_tests_per_thousand)
from project_covid.covid_deaths
order by 1,2;

select location,date,population ,new_tests, (new_tests/population) as Covidpopulation
from project_covid.covid_deaths;

Select Location, Population, MAX(new_tests) as HighestInfectionCount,  Max((new_tests/population))*100 as PercentPopulationInfected
From project_covid.covid_deaths
Group by Location, Population
order by PercentPopulationInfected desc;

Select Location, MAX((new_tests )) as Totaltestcount
from project_covid.covid_deaths
Where continent is not null 
Group by Location
order by Totaltestcount desc;

Select continent, MAX((new_tests)) as Totaltestcount
from project_covid.covid_deaths
Where continent is not null 
Group by continent
order by Totaltestcount desc;

Select SUM(new_tests) as total_cases, SUM((new_deaths)) as total_deaths, SUM(new_deaths )/SUM(new_tests)*100 as DeathPercentage
from project_covid.covid_deaths
where continent is not null 
Group By date
order by 1,2;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from project_covid.covid_deaths dea
join project_covid.covid_vaccinations vac
On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from project_covid.covid_deaths dea
join project_covid.covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;



