-- =============================
-- STEP 1: Content from SQL_Scripts.sql
-- =============================

-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove unnecessary Columns and Rows

-- Create a staging data set to protect the raw data.

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Duplicates
-- Use ROW_NUMBER() to flag duplicates.
-- PARTITION BY defines what makes a row duplicate

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- Use CTE for simplicity and clarity

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;


-- Creat new table using the Copy/Create path, change table name by adding 2 to the name

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- Insert data into new table

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- See results of duplicates

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Delete duplicates then verify deletion

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- =============================
-- STEP 2: Content from SQL_Script2.sql
-- =============================

-- Standardizing Data

-- Clear white space from rows by using the TRIM function
-- First look at the fields with the TRIM function applied, no actual change to the table

SELECT company, TRIM(company)
FROM layoffs_staging2;

-- Update rows with trimmed data using the UPDATE statement, using SET to make the change to the rows under the company column

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Several rows have similar data but different industry names. (Crypto, Crypto Currency, CryptoCurrency, and United States vs United States.) Use UPDATE statements to correct

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Using the UPDATE statement, use the SET clause to change the three cypto options. As below, WHERE Crypto% would include any row that starts with Crypto and then SET the industry to just Crypto.

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Verify the changes were updated

SELECT DISTINCT industry
FROM layoffs_staging2;

-- Check location column

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Now look at the country column

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- United States has two entries, one with a . following States. Use the TRIM function in a SELECT statement to view the change prior to performing the update.

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- Now use the UPDATE statement to trim to trailing . Use the % wild card to select the entry with the .

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Verify the result with a SELECT DISTINCT statement

SELECT DISTINCT country
FROM layoffs_staging2
ORder by 1;

-- Changing data type from DATE column from STRING to DATE. Using the '%x/%x/%x' sets the format in the fields
-- Using back ticks for the date column because it is a reserved word. Using reserved words such as DATE, TIME, and many others as a column name require the backticks to tell SQL to differentiate between the two.

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- Set the column to a Date column. Use caution: modifying a column requires an ALTER statement on the whole table, as seen in the code syntax below.

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Basic SELECT statement to view the table

SELECT *
FROM layoffs_staging2;


-- =============================
-- STEP 3: Content from SQL_Script3.sql
-- =============================

-- Null and Blank Values

-- Look att the two key columns that appear to have many nulls and blanks by using a SELECT statement including with WHERE ... IS NULL and AND ... IS NULL.

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- The query returns both columns with NULL fields.
-- Checking the industry column for NULL or blank fields as follows

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Of the rows that pop up, we check Airbnb for example.

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Airbnb%';

-- Query returns results with a blank field under the industry column. These fields should be populated with data to make queries cleaner and results more accurate. 
-- Data pulled by industry will not return any results even though there is relevant data in other columns.
-- Use a self join on two columns, company and location. There could be Airbnbs in other locations, so join on the column in SF to ensure other locations are not returned in the results.
-- In the WHERE clause, we use an OR operator to allow SQL to check for NULL or blank ('') fields.

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- The query returned both columns from table t1 and t2. t1 returned all blank fields in the industry column, whereas t2 returned some blank, some with data. 
-- Now we ask SQL to populate the blank fields with the appropriate data. Use an UPDATE statement with the SET clause, then WHERE/AND to combine the data in the two columns
-- In so doing, we find we must change the blank fields in t1 to NULL with a simple UPDATE statement as follows:

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
        AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Check results to ensure field has populated with the correct data, and we find we were successful.

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';



-- =============================
-- STEP 4: Content from SQLScript4.sql
-- =============================

-- Delete rows and columns

-- First look at the columns with NULL values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Once verified that there is no data in the columns, use the DELETE statement to delete rows (not the columns) as follows:

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Look again at the table

SELECT *
FROM layoffs_staging2;

-- Drop the column row_num created earlier, as it is no longer needed. Instead of deleting data from the column, we are deleted the column altogether, meaning we are altering the table.

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;






















