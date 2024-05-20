SQL PROJEKT - Andrea Šimůnková (DISCORD:andysi1)


ZADÁNÍ

2 tabulky - 1. Pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky. 2. Pro dodatečná data s HDP, GINI koeficientem 
a populací dalších evropských států ve stejném období jako primární přehled pro ČR.

Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?


ANALÝZA A POSTUP

 Na základě vytyčených výzkumných otázek k datům o mzdách v různých odvětví v ČR, cenách potravin v ČR rozdělených do jednotlivých kategorií a HDP v dalších evropských zemí byla provedena analýza těchto dat. Za pomoci aplikace DBEAVER byla data poskytnutých tabulek s potřebnými daty sjednocena do nově vytvořených tabulek "t_simunkova_andrea_project_SQL_primary_final" a "t_simunkova_andrea_project_SQL_secondary_final" a dále data potřebná k zodpovězení jednotlivých otázek vybrána díky selectům, které jsou k dispozici v příloze "Projekt_SQL_Andrea_Simunkova".

 "t_simunkova_andrea_project_SQL_primary_final" - data o mzdách v jednotlivých odvětví byla očištěna o data, kde chybělo uvedeno odvětví a sledované období tvoří průnik dat o mzdách a cenách potravin = 2006-2018. Jelikož data ke mzdách se vztahovala k celé ČR a nebyla rozdělena po jednotlivých krajích/okresech, nebyla data o cenách omezena pouze na jeden kraj/okres a tedy odpovědi na výzkumné otázky jsou zodpovězeny pro celou ČR (nebyly tedy využity tabulky czechia_region a czechia_district). Samozřejmě je zde pak velké zkreslení výsledných hodnot, protože např. mzdy v Hlavním městě Praha jsou odlišné od jiných menších krajů, to samé platí pro ceny. Abychom měli co nejpřesnější výpočty, bylo by vhodné počítat průměrnou mzdu a příslušné ceny dle krajů/okresů. 


VÝSLEDKY


Otázka 1

 Mzdy ve všech odvětvích v ČR v průběhu let pouze nerostou, ale v některých odvětvích dochází k jejich poklesu - sledované období je od roku 2006 do roku 2018, viz níže detailní informace o tom, ve kterých odvětvích a mezi jakými lety dochází k poklesu mezd:
    1x pokles - odvětví A Zemědělství, lesnictví, rybářství - 2008 a 2009;
                odvětví C Zpracovatelský průmysl - 2019 a 2020;
                odvětví E Zásobování vodou; činnosti související s odpady a sanacemi - 2012 a 2013;
                odvětví F Stavebnictví- 2012 a 2013;
                odvětví J Informační a komunikační činnosti - 2012 a 2013; 
                odvětví K Peněžnictví a pojišťovnictví - 2012 a 2013;
                odvětví P Vzdělávání - 2009 a 2010;
    2x pokles - odvětví D Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu - 2012 a 2013, 2014 a 2015; 
                odvětví G Velkoobchod a maloobchod; opravy a údržba motorových vozidel - 2008 a 2009, 2012 a 2013; 
                odvětví L Činnosti v oblasti nemovitostí - 2012 a 2013, 2019 a 2020; 
                odvětví M Profesní, vědecké a technické činnosti - 2009 a 2010, 2012 a 2013;
                odvětví O Veřejná správa a obrana; povinné sociální zabezpečení - 2009 - 2011; 
                odvětví R Kulturní, zábavní a rekreační činnosti- 2010 a 2011, 2012 a 2013;
    3x pokles - odvětví I Ubytování, stravování a pohostinství - 2008 a 2009, 2010 a 2011, 2019 a 2020; 
    4x pokles - odvětví B Těžba a dobývání - 2008 a 2009, 2012 až 2014, 2015 a 2016

Otázka 2

Jelikož zde není upřesněno zda má být uvedeno pro všechna odvětví dohromady nebo zvlášť, bylo počítáno pro všechna odvětví dohromady. V prvním sledovaném roce 2006 je možné s průměrnou mzdou ze všech odvětví, která činé 20342,38 Kč, zakoupit 895 kg chleba a 999 l mléka. V posledním sledovaném roce 2018 je to pak 1036 kg chleba a 1267 l mléka (prům. mzda 31980.26 Kč).


Otázka 3

Nejpomaleji zdražovala kategorie potravin 115201 = Rostlinný roztíratelný tuk mezi lety 2008 a 2009.

Pokud bychom porovnávali průměrnou meziroční změnu za celé sledované období, nejmenší meziroční zdražení je u kategorie 116103 = Banány žluté s hodnotou 0.81 % (select také přikládám).

Otázka 4

 Ne, v žádném sledovaném roce nebyl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %). Největší meziroční rozdíl 6,66 % byl mezi lety 2012 a 2013.

Otázka 5

 Jako hranici výrazné změny jsem si zvolila 3% meziroční změnu HDP (to samé platí pro cenu i mzdu). Při této hodnotě se z výsledných dat dá odvodit, že při nárůstu HDP o 3 % nedochází k výraznému zvýšení mezd či cen potravin ve stejném či následujícím roce. Za sledované období došlo k výraznému ovlivnění a růst mezd ve třech letech a u cen pouze ve dvou letech (mezi lety 2008 a 2009 došlo naopak k výraznému snížení). Pozn.: Samozřejmě jsou tedy výsledky ovlivněny výší zvolené procentuální hodnoty určující co pro nás znamená výrazné zvýšení HDP.
Pozn. Oprava: Pro lepší orientaci by měl být v selectu zobrazen ještě předchozí rok = pr2.czechia_payroll_year AS prev_year - omlouvám se za opomenutí


