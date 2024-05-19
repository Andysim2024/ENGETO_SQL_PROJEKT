/*Andrea Šimůnková - DISCORD: andysi1


tabulka 1*/

CREATE TABLE t_simunkova_andrea_project_SQL_primary_final AS
WITH 
avg_yearly_value AS (
SELECT
	cp.payroll_year AS czechia_payroll_year,
	cp.industry_branch_code AS czechia_payroll_industry_branch_code,
	cpib.name AS czechia_payroll_industry_branch_name,
	cp.calculation_code AS czechia_payroll_calculation_code,
	cpu.name AS czechia_payroll_calculation_name,
	cp.value_type_code AS czechia_payroll_value_type_code,
	cpvt.name AS czechia_payroll_value_type_name,
	cp.unit_code AS czechia_payroll_unit_code,
	cpu.name AS czechia_payroll_unit_name,
	avg(cp.value) AS czechia_payroll_avg_year_value
FROM
	czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib ON
	cp.industry_branch_code = cpib.code
JOIN czechia_payroll_calculation cpc ON
	cp.calculation_code = cpc.code
JOIN czechia_payroll_unit cpu ON
	cp.unit_code = cpu.code
JOIN czechia_payroll_value_type cpvt ON
	cp.value_type_code = cpvt.code
WHERE
	cp.value_type_code = 5958
	AND cp.calculation_code = 100
	AND cp.industry_branch_code IS NOT NULL
GROUP BY
	cp.industry_branch_code,
	cp.payroll_year),
avg_yearly_price AS (
SELECT
	cp.category_code AS czechia_price_category_code,
	cpc.name AS czechia_price_category_name,
	cpc.price_value AS czechia_price_product_value,
	cpc.price_unit AS czechia_price_product_unit,
	YEAR(cp.date_to) AS czechia_price_year_value,
	round (avg(cp.value),
	2) AS czechia_price_avg_year_price
FROM
	czechia_price cp
JOIN czechia_price_category cpc ON
	cp.category_code = cpc.code
GROUP BY
	cp.category_code,
	czechia_price_year_value)
SELECT
	*
FROM
	avg_yearly_value ayv
JOIN avg_yearly_price ayp ON
	ayv.czechia_payroll_year = ayp.czechia_price_year_value
ORDER BY
	ayv.czechia_payroll_year,
	ayv.czechia_payroll_industry_branch_code;

/*tabulka 2*/

CREATE TABLE t_simunkova_andrea_project_SQL_secondary_final WITH 
 countries_information AS (
SELECT
	e.country,
	c.region_in_world AS region,
	e.`year`,
	e.GDP,
	e.gini,
	e.population
FROM
	economies e
JOIN countries c ON
	e.country = c.country
WHERE
	e.`year` IN (
	SELECT
		e.`year`
	FROM
		economies e
	JOIN t_simunkova_andrea_project_SQL_primary_final ts ON
		e.`year` = ts.czechia_payroll_year)
	AND c.continent = 'Europe')
 SELECT
	*
FROM
	countries_information ci
ORDER BY
	ci.country,
	ci.`year`;

/*otázka 1*/

WITH avg_yearly_value AS (
SELECT
	pr.czechia_payroll_industry_branch_code,
	pr.czechia_payroll_year,
	pr.czechia_payroll_avg_year_value
FROM
	t_simunkova_andrea_project_SQL_primary_final pr
GROUP BY
	pr.czechia_payroll_industry_branch_code,
	pr.czechia_payroll_year)
SELECT
	pr1.czechia_payroll_industry_branch_code AS industry_branch_code,
	ib.name AS industry_branch_name,
	pr1.czechia_payroll_year AS current_year,
	pr1.czechia_payroll_avg_year_value AS avg_yearly_value_current_year,
	pr2.czechia_payroll_year AS previous_year,
	pr2.czechia_payroll_avg_year_value AS avg_yearly_value_previous_year,
	round (((pr1.czechia_payroll_avg_year_value - pr2.czechia_payroll_avg_year_value) / pr2.czechia_payroll_avg_year_value) * 100,
	2) AS year_on_year_change_value_percent,
	CASE
		WHEN ((pr1.czechia_payroll_avg_year_value - pr2.czechia_payroll_avg_year_value) / pr2.czechia_payroll_avg_year_value) * 100 < 0 THEN 'decrease'
		WHEN ((pr1.czechia_payroll_avg_year_value - pr2.czechia_payroll_avg_year_value) / pr2.czechia_payroll_avg_year_value) * 100 > 0 THEN 'increase'
		ELSE 'without change'
	END AS year_on_year_change
FROM
	avg_yearly_value pr1
JOIN
    avg_yearly_value pr2 ON
	pr1.czechia_payroll_year = pr2.czechia_payroll_year + 1
	AND pr1.czechia_payroll_industry_branch_code = pr2.czechia_payroll_industry_branch_code
JOIN czechia_payroll_industry_branch ib ON
	pr1.czechia_payroll_industry_branch_code = ib.code
ORDER BY
	pr1.czechia_payroll_industry_branch_code,
	pr1.czechia_payroll_year;

/*otázka 2*/

SELECT
	pr.czechia_payroll_year,
	round (avg(pr.czechia_payroll_avg_year_value),2) AS czechia_payroll_avg_year_value,
	pr.czechia_price_category_code,
	pr.czechia_price_category_name,
	pr.czechia_price_product_value,
	pr.czechia_price_product_unit,
	pr.czechia_price_year_value,
	pr.czechia_price_avg_year_price,
	round((pr.czechia_payroll_avg_year_value / pr.czechia_price_avg_year_price), 0) AS how_many_product_can_buy_by_year_salary
FROM
	t_simunkova_andrea_project_SQL_primary_final pr
WHERE
	(pr.czechia_payroll_industry_branch_code,
	pr.czechia_payroll_year) IN 
(
	SELECT
		pr.czechia_payroll_industry_branch_code,
		min(pr.czechia_payroll_year) AS min_year
	FROM
		t_simunkova_andrea_project_SQL_primary_final pr
	GROUP BY
		pr.czechia_payroll_industry_branch_code
UNION ALL
	SELECT
		pr.czechia_payroll_industry_branch_code ,
		max(pr.czechia_payroll_year) AS max_year
	FROM
		t_simunkova_andrea_project_SQL_primary_final pr
	GROUP BY
		pr.czechia_payroll_industry_branch_code )
	AND pr.czechia_price_category_code IN (114201, 111301)
GROUP BY pr.czechia_payroll_year, pr.czechia_price_category_code ;

/*otázka 3*/

WITH avg_yearly_price AS (
SELECT
	cp.czechia_price_category_code,
	cp.czechia_price_year_value,
	cp.czechia_price_avg_year_price,
	cp.czechia_price_category_name
FROM
	t_simunkova_andrea_project_SQL_primary_final cp
GROUP BY
	cp.czechia_price_category_code,
	cp.czechia_price_year_value)
SELECT
	cp1.czechia_price_category_code,
	cp1.czechia_price_category_name,
	cp1.czechia_price_year_value,
	cp1.czechia_price_avg_year_price AS avg_yearly_price_current_year,
	cp2.czechia_price_year_value,
	cp2.czechia_price_avg_year_price AS avg_yearly_price_previous_year,
	((cp1.czechia_price_avg_year_price - cp2.czechia_price_avg_year_price) / cp2.czechia_price_avg_year_price) * 100 AS year_on_year_change_price_percent
FROM
	t_simunkova_andrea_project_SQL_primary_final cp1
JOIN avg_yearly_price cp2 ON
	cp1.czechia_price_year_value = cp2.czechia_price_year_value + 1
	AND cp1.czechia_price_category_code = cp2.czechia_price_category_code
WHERE
	((cp1.czechia_price_avg_year_price - cp2.czechia_price_avg_year_price) / cp2.czechia_price_avg_year_price) * 100 > 0
GROUP BY
	cp1.czechia_price_category_code,
	cp1.czechia_price_year_value
ORDER BY
	year_on_year_change_price_percent
LIMIT 1;

/*otázka 3 - případné porovnání průměrné meziroční změny

 WITH avg_yearly_price AS (
SELECT
	cp.czechia_price_category_code,
	cp.czechia_price_year_value,
	cp.czechia_price_avg_year_price,
	cp.czechia_price_category_name
FROM
	t_simunkova_andrea_project_SQL_primary_final cp
GROUP BY
	cp.czechia_price_category_code,
	cp.czechia_price_year_value)
SELECT
	cp1.czechia_price_category_code,
	cp1.czechia_price_category_name,
	round (sum(((cp1.czechia_price_avg_year_price - cp2.czechia_price_avg_year_price) / cp2.czechia_price_avg_year_price) * 100) / count (cp1.czechia_price_avg_year_price),
	2) AS avg_year_on_year_change_price_percent
FROM
	t_simunkova_andrea_project_SQL_primary_final cp1
JOIN avg_yearly_price cp2 ON
	cp1.czechia_price_year_value = cp2.czechia_price_year_value + 1
	AND cp1.czechia_price_category_code = cp2.czechia_price_category_code
GROUP BY
	cp1.czechia_price_category_code
ORDER BY 
	avg_year_on_year_change_price_percent;


/*otázka 4*/

WITH avg_yearly_value AS (
SELECT
	pr.czechia_payroll_year,
	avg(pr.czechia_payroll_avg_year_value) AS avg_payroll
FROM
	t_simunkova_andrea_project_SQL_primary_final pr
GROUP BY
	pr.czechia_payroll_year),
avg_yearly_price AS (
SELECT
	cp.czechia_price_year_value,
	avg(cp.czechia_price_avg_year_price) AS avg_price
FROM
	t_simunkova_andrea_project_SQL_primary_final cp
GROUP BY
	cp.czechia_price_year_value)   
SELECT
	pr1.czechia_payroll_year AS current_year,
	pr2.czechia_payroll_year AS previous_year,
	round (((pr1.avg_payroll - pr2.avg_payroll) / pr2.avg_payroll) * 100,
	2) AS year_on_year_change_percent_value,
	round (((cp1.avg_price - cp2.avg_price) / cp2.avg_price) * 100,
	2) AS year_on_year_change_percent_price,
	round((((cp1.avg_price - cp2.avg_price) / cp2.avg_price) * 100) - (((pr1.avg_payroll - pr2.avg_payroll) / pr2.avg_payroll) * 100),2) AS year_on_year_change_percent_between_price_and_value
FROM
	avg_yearly_value pr1
JOIN
    avg_yearly_value pr2 ON
	pr1.czechia_payroll_year = pr2.czechia_payroll_year + 1
JOIN avg_yearly_price cp1 ON
	pr1.czechia_payroll_year = cp1.czechia_price_year_value
JOIN avg_yearly_price cp2 ON
	cp1.czechia_price_year_value = cp2.czechia_price_year_value + 1
WHERE
 (((cp1.avg_price - cp2.avg_price) / cp2.avg_price) * 100) - (((pr1.avg_payroll - pr2.avg_payroll) / pr2.avg_payroll) * 100) > 10
ORDER BY
	current_year;
	
/*otázka 5*/

WITH avg_yearly_value AS (
SELECT
	pr.czechia_payroll_year,
	avg(pr.czechia_payroll_avg_year_value) AS avg_payroll,
	lead(avg(pr.czechia_payroll_avg_year_value)) OVER (
	ORDER BY pr.czechia_payroll_year) AS avg_next_payroll
FROM
	t_simunkova_andrea_project_SQL_primary_final pr
GROUP BY
	pr.czechia_payroll_year),
avg_yearly_price AS (
SELECT
	cp.czechia_price_year_value,
	avg(cp.czechia_price_avg_year_price) AS avg_price,
	lead(avg(cp.czechia_price_avg_year_price)) OVER (
	ORDER BY cp.czechia_price_year_value) AS avg_next_price
FROM
	t_simunkova_andrea_project_SQL_primary_final cp
GROUP BY
	cp.czechia_price_year_value),   
countries_information AS (
SELECT
	e.country,
	e.region,
	e.`year`,
	e.GDP,
	e.gini,
	e.population
FROM
	t_simunkova_andrea_project_SQL_secondary_final e
WHERE
	e.country LIKE 'Czech Republic')
SELECT
	ci1.country,
	pr1.czechia_payroll_year AS current_year,
	round (((pr1.avg_payroll - pr2.avg_payroll) / pr2.avg_payroll) * 100,
	2) AS year_on_year_change_salary_percent,
	round (((cp1.avg_price - cp2.avg_price) / cp2.avg_price) * 100,
	2) AS year_on_year_change_price_percent,
	round (((ci1.GDP - ci2.GDP) / ci2.GDP) * 100,
	2) AS year_on_year_change_GDP_percent,
	pr3.czechia_payroll_year AS next_year,
	round (((pr1.avg_next_payroll - pr2.avg_next_payroll) / pr2.avg_next_payroll) * 100,
	2) AS next_year_on_year_change_salary_percent,
	round (((cp1.avg_next_price - cp2.avg_next_price) / cp2.avg_next_price) * 100,
	2) AS next_year_on_year_change_salary_percent,
	CASE
		WHEN ((ci1.GDP - ci2.GDP) / ci2.GDP) * 100 > 3
		AND (((pr1.avg_payroll - pr2.avg_payroll) / pr2.avg_payroll) * 100 > 3
			OR ((pr1.avg_next_payroll - pr2.avg_next_payroll) / pr2.avg_next_payroll) * 100 >3 )THEN 'GDP_and_salary_significant_increase'
		WHEN ((ci1.GDP - ci2.GDP) / ci2.GDP) * 100 < -3
		AND (((pr1.avg_payroll - pr2.avg_payroll) / pr2.avg_payroll) * 100 < -3
			OR ((pr1.avg_next_payroll - pr2.avg_next_payroll) / pr2.avg_next_payroll) * 100 < -3) THEN 'GDP_and_salary_significant_decrease'
		ELSE 'without_strong_influence_between_GDP_and_salary'
	END AS effect_of_gdp_on_salary,
	CASE
		WHEN ((ci1.GDP - ci2.GDP) / ci2.GDP) * 100 > 3
		AND (((cp1.avg_price - cp2.avg_price) / cp2.avg_price) * 100 > 3
			OR ((cp1.avg_next_price - cp2.avg_next_price) / cp2.avg_next_price) * 100 > 3) THEN 'GDP_and_price_significant_increase'
		WHEN ((ci1.GDP - ci2.GDP) / ci2.GDP) * 100 < -3
		AND (((cp1.avg_price - cp2.avg_price) / cp2.avg_price) * 100 < -3
			OR ((cp1.avg_next_price - cp2.avg_next_price) / cp2.avg_next_price) * 100 < -3)THEN 'GDP_and_price_significant_decrease'
		ELSE 'without_strong_influence_between_GDP_and_price'
	END AS effect_of_gdp_on_price
FROM
	avg_yearly_value pr1
JOIN avg_yearly_value pr2 ON
	pr1.czechia_payroll_year = pr2.czechia_payroll_year + 1
JOIN avg_yearly_price cp1 ON
	pr1.czechia_payroll_year = cp1.czechia_price_year_value
JOIN avg_yearly_price cp2 ON
	cp1.czechia_price_year_value = cp2.czechia_price_year_value + 1
JOIN avg_yearly_value pr3 ON
	pr1.czechia_payroll_year = pr3.czechia_payroll_year - 1
JOIN countries_information ci1 ON
	pr1.czechia_payroll_year = ci1.`year`
JOIN countries_information ci2 ON
	ci1.`year` = ci2.`year` + 1
GROUP BY
	pr1.czechia_payroll_year