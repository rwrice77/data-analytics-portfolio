# 🧹 SQL Data Cleaning Project – Global Layoffs Dataset  

## 📌 Project Overview  
This project demonstrates my ability to **clean and prepare raw data for analysis using SQL**. The dataset contains information on global layoffs, including company name, industry, location, number of employees laid off, and funding information.  

**Goal:** Transform messy, inconsistent raw data into a clean, analysis-ready dataset.  

---

## 🗂️ Dataset  
- Source: [Layoffs dataset from Kaggle / Alex the Analyst GitHub]  
- Raw file: `layoffs.csv`  
- Size: ~X rows, Y columns (update with actual)  
- Key fields:  
  - `company`, `industry`, `location`, `country`  
  - `total_laid_off`, `percentage_laid_off`  
  - `date`, `stage`, `funds_raised_millions`  

---

## 🔧 Cleaning Steps  

### 1. Remove Duplicates  
- Used `ROW_NUMBER()` with a CTE to flag duplicates.  
- Deleted rows where `row_num > 1`.  

### 2. Standardize Data  
- Fixed inconsistent casing and extra spaces with `TRIM()`.  
- Corrected country names (`United States.` → `United States`).  
- Converted date field from text to proper `DATE` type.  

### 3. Handle Nulls & Blanks  
- Identified missing values in `industry`.  
- Filled blanks by cross-referencing other records of the same company using a self-join.  
- Left irrecoverable nulls intact for transparency.  

### 4. Remove Unnecessary Rows & Columns  
- Dropped irrelevant fields (e.g., helper column `row_num`).  
- Filtered out rows with no layoff data.  

---

## 📊 Results  
- Cleaned dataset stored in `layoffs_staging2`.  
- Dataset is now consistent, duplicate-free, and ready for analysis.  
- Example queries you can now run:  
  - Top 10 companies by total layoffs.  
  - Layoffs by industry or country.  
  - Trends in layoffs over time.  

---

## 🛠️ Tools & Skills Used  
- **SQL (MySQL Workbench)** – window functions, CTEs, aggregate functions, joins.  
- **Data Cleaning Techniques** – deduplication, standardization, null handling.  
- **Version Control** – project organized into step-by-step SQL scripts.  

---

## 🚀 Next Steps  
- Perform **exploratory data analysis (EDA)** on the cleaned dataset.  
- Visualize insights in **Excel** or **Power BI**.  
- Add storytelling (Markdown/Notebook) version with charts and commentary.  

---

💡 *This project highlights my SQL data cleaning workflow — a core skill for any Data Analyst role. The cleaned dataset will serve as the foundation for exploratory analysis and visualization projects.*  
