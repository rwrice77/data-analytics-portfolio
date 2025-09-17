-- =======================================================
-- SQL Data Exploration Project – Global Layoffs Dataset
-- Author: Robert Rice
-- Goal: Explore layoff trends after cleaning the dataset
-- =======================================================

-- STEP 0: Inspect dataset
-- SELECT * FROM layoffs_staging2 LIMIT 10;

-- =======================================================
-- 1. General Statistics
-- =======================================================

-- Maximum and minimum layoffs in single events

SELECT MAX(total_laid_off) AS MaxLayoffs, MIN(total_laid_off) AS MinLayoffs
FROM layoffs_staging2;

-- Companies with 100% layoffs (shutdowns)

SELECT company, total_laid_off, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

-- =======================================================
-- 2. Layoffs by Company / Industry / Country
-- =======================================================

-- Total layoffs by company

SELECT company, SUM(total_laid_off) AS TotalLayoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY TotalLayoffs DESC;

-- Total layoffs by industry

SELECT industry, SUM(total_laid_off) AS TotalLayoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY TotalLayoffs DESC;

-- Total layoffs by country

SELECT country, SUM(total_laid_off) AS TotalLayoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY TotalLayoffs DESC;

-- =======================================================
-- 3. Trends Over Time
-- =======================================================

-- Layoffs by year

SELECT YEAR(`date`) AS LayoffYear, SUM(total_laid_off) AS TotalLayoffs
FROM layoffs_staging2
GROUP BY LayoffYear
ORDER BY LayoffYear;

-- Layoffs by month

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 2 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT  `Month`, total_off,
SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

-- =======================================================
-- 4. Company Rankings
-- =======================================================

-- Top companies with most layoffs overall

SELECT company, SUM(total_laid_off) AS TotalLayoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY TotalLayoffs DESC;

-- Top 5 companies by year (using CTE + window function)

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;

-- =======================================================
-- 📌 Insights Summary
-- =======================================================
--   Geography:
--   The United States and India reported the highest numbers of layoffs,
--   followed by several European countries, showing that layoffs were
--   concentrated in major tech and business hubs globally.
--
--   Industry:
--   Consumer, Retail, Transportation, Finance, and Healthcare were among
--   the most heavily impacted industries, highlighting broad sector-wide
--   effects beyond just technology.
--
--   Companies:
--   Large, well-known firms such as Google, Amazon, and Meta had some of
--   the highest layoffs, showing that even established companies were
--   forced into significant workforce reductions.
--
--   Time Trends:
--   Layoff activity peaked during 2022 and 2023, suggesting global
--   economic uncertainty and post-pandemic corrections played major roles.
--   Rolling totals clearly illustrate a steep rise in layoffs during this
--   period before beginning to level off.
--
--   Conclusion:
--   The analysis shows that layoffs were not isolated to a single region,
--   company, or industry. Instead, they were widespread, with particular
--   intensity in large global tech firms. The peak years of 2022–2023
--   will be important focal points for further exploratory analysis and
--   visualization.

-- =======================================================
