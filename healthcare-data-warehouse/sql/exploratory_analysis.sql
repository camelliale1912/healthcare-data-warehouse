-- ============================================
-- Exploratory Data Analysis (EDA)
-- Healthcare Data Warehouse Project
-- ============================================

-- 1. Hospital Composition
-- Distribution of hospitals by ownership type

SELECT  
    type_of_control, 
    COUNT(*) AS count_hospitals 
FROM dim_hospital 
GROUP BY type_of_control 
ORDER BY count_hospitals DESC;


-- ============================================

-- 2. Key Financial Summary
-- Average costs, revenue, and income across hospitals

SELECT  
    ROUND(AVG(total_costs), 2) AS avg_total_costs, 
    ROUND(AVG(net_patient_revenue), 2) AS avg_net_patient_revenue, 
    ROUND(AVG(net_income), 2) AS avg_net_income 
FROM fact_financials;


-- ============================================

-- 3. Efficiency / Cost-to-Charge Ratio
-- Measures how much hospitals spend relative to charges

SELECT  
    ROUND(AVG(cost_to_charge_ratio), 4) AS avg_cost_to_charge_ratio 
FROM fact_financials;


-- ============================================
-- End of Exploratory Analysis
-- ============================================