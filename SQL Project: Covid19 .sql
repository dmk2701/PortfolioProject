Data Source: https://ourworldindata.org/covid-deaths


SELECT * FROM dbo.[Covid 19 Data] ORDER BY 1,2

--Tổng số ca mắc 
SELECT continent,location, MAX(population) AS population, sum(new_cases) AS TotalCases
FROM dbo.[Covid 19 Data] 
WHERE continent IS NOT null
GROUP BY continent,location
ORDER BY TotalCases DESC

--Tỷ lệ ca mắc/dân số
SELECT continent,location, MAX(population) AS population, max(total_cases) AS TotalCases, max(total_cases)/MAX(population)*100 AS PositiveCovidPercentage
FROM dbo.[Covid 19 Data] 
WHERE continent IS NOT null
GROUP BY continent,location
ORDER BY PositiveCovidPercentage DESC

--Tổng số ca tử vong 
SELECT continent,location, MAX(population) AS population, SUM(new_deaths) AS TotalDeaths
FROM dbo.[Covid 19 Data] 
WHERE continent IS NOT null
GROUP BY continent,location
ORDER BY TotalDeaths DESC

--Tỷ lệ tử vong /dân số
SELECT continent,location, MAX(population) AS population, MAX(total_deaths) AS TotalDeaths,  max(total_deaths)/MAX(population)*100 AS DeathPercentage
FROM dbo.[Covid 19 Data] 
WHERE continent IS NOT null
GROUP BY continent,location
ORDER BY DeathPercentage DESC


--Số ca nhiễm trong ngày
SELECT date, SUM(new_cases) as NewCases FROM dbo.[Covid 19 Data] GROUP BY date ORDER BY NewCases  DESC

--Tổng số Vaccin
SELECT cov.continent,cov.location, Max(cov.population) AS population, SUM(vac.new_vaccinations) AS NewVaccin 
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.continent IS NOT null
 GROUP BY cov.continent,cov.location
 ORDER BY NewVaccin desc 

 --Số lượng vaccin/dân số
 SELECT cov.continent,cov.location, MAX(cov.population) AS population, SUM(vac.new_vaccinations) AS totalVaccin,  SUM(vac.new_vaccinations)/max(cov.population) AS VaccinPerpeople
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.continent IS NOT null
 GROUP BY cov.continent,cov.location
 ORDER BY VaccinPerpeople desc 

 --Việt Nam
 SELECT cov.continent,cov.location, MAX(cov.population) AS population, MAX(cov.total_cases) AS TotalCases, MAX(cov.total_deaths) AS TotalDeaths,
 MAX(cov.total_cases)/MAX(cov.population) *100 AS PositivePercentage, MAX(cov.total_deaths)/MAX(cov.population)*100 DeathPercentage,
 SUM(vac.new_vaccinations) AS totalVaccin,
 SUM(vac.new_vaccinations)/max(cov.population) AS VaccinPerpeople
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.location = 'Vietnam'
 GROUP BY cov.continent,cov.location


 --CTE
 WITH PopVsVac (continent, location, population, TotalVaccin, VaccinPerpeople) 
 AS 
 ( SELECT cov.continent,cov.location, MAX(cov.population) AS population, SUM(vac.new_vaccinations) AS totalVaccin, 
 SUM(vac.new_vaccinations)/max(cov.population) AS VaccinPerpeople
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.continent IS NOT null
 GROUP BY cov.continent,cov.location)

 SELECT *  FROM PopVsVac ORDER BY PopVsVac.VaccinPerpeople DESC
 
 --Bảng tạm
select
 cov.continent,cov.location, MAX(cov.population) AS population, SUM(vac.new_vaccinations) AS totalVaccin, 
 SUM(vac.new_vaccinations)/max(cov.population) AS VaccinPerpeople
  INTO #Vaccinated --Bảng tạm
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.continent IS NOT null
 GROUP BY cov.continent,cov.location
 ORDER BY VaccinPerpeople desc 

--View
CREATE VIEW Vaccinated_View AS
SELECT cov.continent,cov.location, MAX(cov.population) AS population, SUM(vac.new_vaccinations) AS totalVaccin,  SUM(vac.new_vaccinations)/max(cov.population) AS VaccinPerpeople
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.continent IS NOT null
 GROUP BY cov.continent,cov.location
 
--Lấy dữ liệu phục vụ trực quan hóa dữ liệu
 SELECT cov.continent,cov.location, cov.date, MAX(cov.population) AS population, MAX(cov.total_cases) AS TotalCases, MAX(cov.total_deaths) AS TotalDeaths,
 SUM(vac.new_vaccinations) AS totalVaccin,
 SUM(vac.new_vaccinations)/max(cov.population) AS VaccinPerPeople
FROM dbo.[Covid 19 Data] AS cov JOIN dbo.[Vaccin Covid 19 Data] AS vac
ON vac.location = cov.location
 AND vac.date = cov.date 
 AND vac.continent = cov.continent
 WHERE cov.continent IS NOT null
 GROUP BY cov.continent,cov.location,cov.date
 ORDER BY VaccinPerpeople desc








 








 
