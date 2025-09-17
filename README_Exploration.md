# 📊 SQL Data Exploration Project – Global Layoffs Dataset  

## 📌 Project Overview  
This project explores the **Global Layoffs dataset** after the data was cleaned and prepared. Using SQL, I performed exploratory data analysis (EDA) to uncover insights about layoffs by company, industry, country, and over time.  

**Goal:** Answer key business questions and identify trends in layoffs globally.  

---

## 🗂️ Dataset  
- Source: [Layoffs dataset from Kaggle / Alex the Analyst GitHub]  
- Cleaned file: `layoffs_staging2` (prepared in the [Data Cleaning Project](../sql-layoffs-cleaning))  
- Size: ~X rows, Y columns (update with actual)  
- Key fields:  
  - `company`, `industry`, `location`, `country`  
  - `total_laid_off`, `percentage_laid_off`  
  - `date`, `stage`, `funds_raised_millions`  

---

## 🔧 Exploratory Steps  

### 1. General Statistics  
- Maximum and minimum layoffs across all events.  
- Identification of companies with 100% layoffs (full shutdowns).  

### 2. Layoffs by Category  
- Total layoffs by **company** (top firms most impacted).  
- Total layoffs by **industry** (which sectors were hit hardest).  
- Total layoffs by **country** (geographic concentration).  

### 3. Trends Over Time  
- Yearly layoffs to identify peak years.  
- Monthly layoffs using `SUBSTRING()` to group by `YYYY-MM`.  
- Rolling totals using CTEs + window functions to show cumulative impact.  

### 4. Company Rankings  
- Top 10 companies by total layoffs overall.  
- Top 5 companies each year using `DENSE_RANK()`.  

---

## 📌 Insights Summary  
- **Geography:** The United States and India reported the highest layoffs, followed by European hubs.  
- **Industry:** Consumer, Retail, Transportation, Finance, and Healthcare were heavily impacted, not just tech.  
- **Companies:** Major firms like Google, Amazon, and Meta had some of the largest layoffs, showing the scale of impact across even dominant players.  
- **Trends:** Layoffs peaked in **2022 and 2023**, reflecting global economic uncertainty and post-pandemic corrections.  

**Conclusion:** Layoffs were widespread across regions and industries, with the sharpest impact felt in global tech firms. The years 2022–2023 stand out as critical periods for further analysis and visualization.  

---

## 🛠️ Tools & Skills Used  
- **SQL (MySQL Workbench)** – aggregation, string functions, CTEs, window functions.  
- **Exploratory Data Analysis** – company, industry, country, and time-based breakdowns.  
- **Business Insights** – translating queries into meaningful conclusions.  

---

## 🚀 Next Steps  
- Create **Excel and Power BI dashboards** to visualize trends.  
- Combine with Data Cleaning project for an **end-to-end case study**.  
- Extend analysis to other workforce/economic datasets for deeper insights.  

---

💡 *This project highlights my ability to perform exploratory data analysis in SQL and translate raw queries into clear business insights.*  
