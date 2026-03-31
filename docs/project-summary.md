# Project Summary

## Healthcare Data Warehouse – CMS Hospital Cost Report

### Overview
This project develops a healthcare analytics data warehouse using publicly available CMS Medicare Cost Report data. The goal is to transform raw hospital financial and operational data into a structured format that supports analysis of profitability, resource utilization, and uncompensated care across the United States.

### Business Problem
Hospitals must balance financial sustainability with operational demands while managing rising labor costs and uncompensated care. However, raw healthcare datasets are complex, unstructured, and difficult to analyze directly. This project addresses the challenge by building a data warehouse that enables consistent, scalable analysis across hospitals, regions, and time.

### Data Source
- CMS Medicare Cost Report  
- Contains hospital-level financial, operational, and geographic data  
- Includes metrics such as revenue, costs, staffing, beds, and charity care  

### Technical Approach

#### Data Preparation
- Selected relevant fields from raw CMS data  
- Standardized column names and data types  
- Cleaned and validated data for consistency and accuracy  

#### Data Modeling
- Designed a **star schema** for analytical queries  
- Dimension tables:
  - Hospital (ownership, type)
  - Location (state, region)
  - Calendar (time-based analysis)  
- Fact tables:
  - Financials (costs, revenue, income)
  - Operations (beds, staffing, uncompensated care)  

#### ETL Process
- Loaded raw data into a staging table  
- Transformed and populated dimension tables using business keys  
- Inserted cleaned and structured data into fact tables  
- Ensured data quality through validation and consistency checks  

### Key Analytics
- Compared profitability across ownership types and states  
- Ranked hospitals by financial performance within regions  
- Grouped hospitals into profitability quartiles  
- Analyzed year-over-year changes in operating margin  

### Key Insights
- Hospital margins are generally low, indicating financial pressure  
- Government and safety-net hospitals show the highest financial strain  
- Uncompensated care significantly impacts cost efficiency  
- Larger hospitals are not always more profitable  

### Skills Demonstrated
- ETL pipeline development  
- Data cleaning and validation  
- Dimensional data modeling  
- SQL analytics (ROLLUP, RANK, NTILE, LAG)  
- Healthcare data analysis  

### Relevance
This project demonstrates experience working with real-world healthcare datasets, building structured data systems, and generating actionable insights. These skills are directly applicable to roles involving healthcare analytics, data integration, and database management.