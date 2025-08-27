Select * from Portfolio_Project.covidvaccinations;

#changing datatypes of columns
update Portfolio_Project.covidvaccinations
set date= str_to_date(date,'%Y-%m-%d');

alter table Portfolio_Project.covidvaccinations
modify column new_tests int,
modify column total_tests int,
modify column total_tests_per_thousand int,
modify column new_tests_per_thousand int,
modify column new_tests_smoothed_per_thousand int,
modify column positive_rate int,
modify column tests_per_case int,
modify column tests_units varchar(40),
modify column total_vaccinations int,
modify column people_vaccinated int,
modify column people_fully_vaccinated int,
modify column new_vaccinations int,
modify column new_vaccinations_smoothed int,
modify column total_vaccinations_per_hundred int,
modify column people_vaccinated_per_hundred int,
modify column people_fully_vaccinated_per_hundred int,
modify column new_vaccinations_smoothed_per_million int,
modify column stringency_index int,
modify column population_density int,
modify column median_age int,
modify column aged_65_older int,
modify column aged_70_older int,
modify column gdp_per_capita int,
modify column extreme_poverty int,
modify column cardiovasc_death_rate int,
modify column diabetes_prevalence int,
modify column female_smokers int,
modify column male_smokers int,
modify column handwashing_facilities int,
modify column hospital_beds_per_thousand int,
modify column life_expectancy int,
modify column human_development_index int;




SELECT * 
FROM Portfolio_Project.coviddeaths
where continent <> 'NA'
;

#changing datatype
update Portfolio_Project.coviddeaths
set date= str_to_date(date,'%d-%m-%Y');


SELECT * FROM Portfolio_Project.coviddeaths
order by 3,4;

#data to be used
select location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project.coviddeaths
order by 1,2;

-- checking case rate over the days
select location,date, total_cases,population, (total_cases/population)*100 as percentage_population_infected
FROM Portfolio_Project.coviddeaths
where location="India"
order by 1,2;

#checking percentage of deaths per total cases over the days
select location,date,total_deaths, total_cases, (total_deaths/total_cases)*100 as death_percentage
FROM Portfolio_Project.coviddeaths
where location="India";

#checking for each country with highest cases or infection rate
select location,population,MAX(total_cases) as Highest_infection_rate, MAX((total_cases/population))*100 as 
	percentage_population_infected
FROM Portfolio_Project.coviddeaths
where location= "India"
group by location ,population
-- order by percentage_population_infected desc
;


#checking for each country , total death count
select location,MAX(total_deaths) as total_death_count
FROM Portfolio_Project.coviddeaths
-- where location= "India"
where continent <> 'NA' # because where continent is 'NA', location field contains the continent
group by location
order by total_death_count desc
;

#breaking the above by continents
select location,MAX(total_deaths) as total_death_count
FROM Portfolio_Project.coviddeaths
where continent= 'NA' 
group by location
order by total_death_count desc
;

#looking at world 
select date, sum(new_cases) as totalCases,sum(new_deaths) as totalDeaths,
	(sum(new_deaths)/sum(new_cases))*100 as death_percentage_date
FROM Portfolio_Project.coviddeaths
where continent <> 'NA' 
group by date
order by date;

select  sum(new_cases) as totalCases,sum(new_deaths) as totalDeaths,
	(sum(new_deaths)/sum(new_cases))*100 as death_percentage
FROM Portfolio_Project.coviddeaths
where continent <> 'NA' ;


#joining coviddeaths and covidvaccinations
select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
from Portfolio_Project.coviddeaths death
	join Portfolio_Project.covidvaccinations vacc
    on death.location=vacc.location and
       death.date = vacc.date
where death.continent <> 'NA'
order by 2,3;

select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	sum(vacc.new_vaccinations) over (partition by death.location order by death.date, death.location)
    as people_vaccinated
from Portfolio_Project.coviddeaths death
	join Portfolio_Project.covidvaccinations vacc
    on death.location=vacc.location and
       death.date = vacc.date
where death.continent <> 'NA'
order by 2,3;

#creating cte(common table expression)
with Population_vs_Vaccination (Continent, Location, Date, Population, NewVaccinations,PeopleVaccinated)
as
(
select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	sum(vacc.new_vaccinations) over (partition by death.location order by death.date, death.location)
    as people_vaccinated
from Portfolio_Project.coviddeaths death
	join Portfolio_Project.covidvaccinations vacc
    on death.location=vacc.location and
       death.date = vacc.date
where death.continent <> 'NA'
-- order by 2,3
)
select *, (PeopleVaccinated/Population)*100 as vaccinated_population_percentage
from Population_vs_Vaccination;


-- using temp table
Create table PercentagePopulationVaccinated
(
	Continent varchar(255),
    Location varchar(255),
    Date datetime,
    Population numeric,
    NewVaccinations numeric,
    PeopleVaccinated numeric);
    
Insert into PercentagePopulationVaccinated
select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	sum(vacc.new_vaccinations) over (partition by death.location order by death.date, death.location)
    as people_vaccinated
from Portfolio_Project.coviddeaths death
	join Portfolio_Project.covidvaccinations vacc
    on death.location=vacc.location and
       death.date = vacc.date
where death.continent <> 'NA';
-- order by 2,3

select *, (PeopleVaccinated/Population)*100 as vaccinated_population_percentage
from PercentagePopulationVaccinated
where continent <> 'NA';
;
    
    
#creating views
DROP view if exists world_death_percentage;
create view world_death_percentage as
select date, sum(new_cases) as totalCases,sum(new_deaths) as totalDeaths,
	(sum(new_deaths)/sum(new_cases))*100 as death_percentage_date
FROM Portfolio_Project.coviddeaths
where continent <> 'NA' 
group by date
order by date;
    











