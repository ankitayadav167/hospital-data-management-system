CREATE OR REPLACE FUNCTION hospital_info.move_to_india()
RETURNS void AS $$
BEGIN
    INSERT INTO hospital_info.Table_India (
        Customer_Name, Customer_ID, Open_Date, Last_Consulted_Date,
        Vaccination_Type, Doctor_Consulted, State, Postcode,
        Date_of_Birth, Is_Active
    )
    SELECT 
        Customer_Name, Customer_ID, Open_Date, Last_Consulted_Date,
        Vaccination_Type, Doctor_Consulted, State, Postcode,
        Date_of_Birth, Is_Active
    FROM hospital_info.Customer_Staging
    WHERE Country = 'IND'
    ON CONFLICT (Customer_Name, Customer_ID) 
    DO UPDATE SET
        Last_Consulted_Date = 
            CASE
                WHEN EXCLUDED.Last_Consulted_Date > hospital_info.Table_India.Last_Consulted_Date
                THEN EXCLUDED.Last_Consulted_Date
                ELSE hospital_info.Table_India.Last_Consulted_Date
            END,
        Vaccination_Type = EXCLUDED.Vaccination_Type,
        Doctor_Consulted = EXCLUDED.Doctor_Consulted,
        State = EXCLUDED.State,
        Is_Active = EXCLUDED.Is_Active;
END;
$$ LANGUAGE plpgsql;