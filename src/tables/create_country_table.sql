CREATE OR REPLACE FUNCTION hospital_info.create_country_table(country_code TEXT)
RETURNS void AS $$
BEGIN
    EXECUTE format('
        CREATE TABLE IF NOT EXISTS hospital_info.Table_%I (
            Customer_Name VARCHAR(255) NOT NULL,
            Customer_ID VARCHAR(18) NOT NULL,
            Open_Date DATE NOT NULL,
            Last_Consulted_Date DATE,
            Vaccination_Type CHAR(5),
            Doctor_Consulted CHAR(255),
            State CHAR(5),
            Postcode INT,
            Date_of_Birth DATE,
            Is_Active CHAR(1),
            PRIMARY KEY (Customer_Name, Customer_ID)
        )', lower(country_code));
        
    -- Create index for the new table
    EXECUTE format('
        CREATE INDEX idx_%I_consult_date ON hospital_info.Table_%I(Last_Consulted_Date)
    ', lower(country_code), lower(country_code));
    
    -- Create view for the new table
    EXECUTE format('
        CREATE OR REPLACE VIEW hospital_info.Table_%I_View AS
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
                THEN ''Y''
                ELSE ''N''
            END AS Needs_Followup
        FROM hospital_info.Table_%I', lower(country_code), lower(country_code));
END;
$$ LANGUAGE plpgsql;