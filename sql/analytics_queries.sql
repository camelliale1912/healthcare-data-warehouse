-- ============================================
-- Advanced Analytics Queries
-- Healthcare Data Warehouse Project
-- Dataset: CMS Hospital Cost Report
-- ============================================


-- ============================================
-- 1. Profitability by Ownership and State (ROLLUP)
-- ============================================

-- Compares operating margin and hospital size across ownership types and states

SELECT 
    CASE  
        WHEN GROUPING(h.type_of_control) = 1 THEN 'ALL OWNERSHIP TYPES' 
        ELSE h.type_of_control 
    END AS type_of_control,

    CASE  
        WHEN GROUPING(h.state_code) = 1 THEN 'ALL STATES' 
        ELSE h.state_code 
    END AS state_code,

    ROUND(
        (SUM(ff.net_patient_revenue) - SUM(ff.total_operating_expense)) 
        / NULLIF(SUM(ff.net_patient_revenue), 0),
        4
    ) AS operating_margin,

    ROUND(AVG(fo.number_of_beds), 2) AS avg_beds,
    ROUND(AVG(fo.fte_employees_on_payroll), 2) AS avg_fte

FROM fact_financials ff
JOIN fact_operations fo 
    ON ff.rpt_rec_num = fo.rpt_rec_num
JOIN dim_hospital h 
    ON ff.dim_hospital_id = h.dim_hospital_id

GROUP BY ROLLUP (h.type_of_control, h.state_code)
ORDER BY type_of_control, state_code;


-- ============================================
-- 2. Rank Hospitals by Margin Within Each State
-- ============================================

-- Ranks hospitals by profitability within each state

WITH hospital_margin AS (
    SELECT 
        h.state_code,
        h.hospital_name,
        h.type_of_control,

        CASE 
            WHEN SUM(ff.net_patient_revenue) > 0 THEN
                (SUM(ff.net_patient_revenue) - SUM(ff.total_operating_expense))
                / SUM(ff.net_patient_revenue)
        END AS operating_margin

    FROM fact_financials ff
    JOIN dim_hospital h 
        ON ff.dim_hospital_id = h.dim_hospital_id

    GROUP BY 
        h.state_code,
        h.hospital_name,
        h.type_of_control
)

SELECT 
    state_code,
    hospital_name,
    type_of_control,
    ROUND(operating_margin, 4) AS operating_margin,

    RANK() OVER (
        PARTITION BY state_code
        ORDER BY operating_margin DESC
    ) AS state_margin_rank

FROM hospital_margin
WHERE operating_margin IS NOT NULL
ORDER BY state_code, state_margin_rank;


-- ============================================
-- 3. Profitability Quartiles (NTILE)
-- ============================================

-- Assigns hospitals into 4 profitability groups

SELECT 
    h.hospital_name,
    h.state_code,
    h.type_of_control,

    ROUND(
        (SUM(ff.net_patient_revenue) - SUM(ff.total_operating_expense))
        / NULLIF(SUM(ff.net_patient_revenue), 0),
        4
    ) AS operating_margin,

    NTILE(4) OVER (
        ORDER BY
            (SUM(ff.net_patient_revenue) - SUM(ff.total_operating_expense))
            / NULLIF(SUM(ff.net_patient_revenue), 0)
    ) AS margin_quartile

FROM fact_financials ff
JOIN dim_hospital h 
    ON ff.dim_hospital_id = h.dim_hospital_id

GROUP BY
    h.hospital_name,
    h.state_code,
    h.type_of_control;


-- ============================================
-- 4. Year-over-Year Margin Change (LAG)
-- ============================================

-- Tracks changes in hospital profitability over time

WITH hospital_year_margin AS (
    SELECT 
        h.provider_ccn,
        h.hospital_name,
        c.year,

        CASE 
            WHEN SUM(ff.net_patient_revenue) > 0 THEN
                (SUM(ff.net_patient_revenue) - SUM(ff.total_operating_expense))
                / SUM(ff.net_patient_revenue)
        END AS operating_margin

    FROM fact_financials ff
    JOIN dim_hospital h 
        ON ff.dim_hospital_id = h.dim_hospital_id
    JOIN dim_calendar c 
        ON ff.dim_calendar_id = c.dim_calendar_id

    GROUP BY
        h.provider_ccn,
        h.hospital_name,
        c.year
),

margin_with_lag AS (
    SELECT 
        provider_ccn,
        hospital_name,
        year,
        operating_margin,

        LAG(operating_margin) OVER (
            PARTITION BY provider_ccn
            ORDER BY year
        ) AS prev_year_margin

    FROM hospital_year_margin
    WHERE operating_margin IS NOT NULL
)

SELECT 
    provider_ccn,
    hospital_name,
    year,
    ROUND(operating_margin, 4) AS operating_margin,
    ROUND(prev_year_margin, 4) AS prev_year_margin,

    ROUND(
        operating_margin - prev_year_margin,
        4
    ) AS yoy_change

FROM margin_with_lag
WHERE prev_year_margin IS NOT NULL
ORDER BY hospital_name, year;


-- ============================================
-- End of Advanced Analytics Queries
-- ============================================