CREATE OR REPLACE VIEW hospital_info.Customer_Staging_View AS
SELECT 
    *,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, Date_of_Birth)) AS Age,
    CASE
        WHEN Last_Consulted_Date IS NOT NULL 
        THEN (CURRENT_DATE - Last_Consulted_Date)::INTEGER
        ELSE NULL
    END AS Days_Since_Last_Consulted,
    CASE
        WHEN Last_Consulted_Date IS NOT NULL AND
            (CURRENT_DATE - Last_Consulted_Date)::INTEGER > 30
        THEN 'Y'
        ELSE 'N'
    END AS Needs_Followup
FROM hospital_info.Customer_Staging;