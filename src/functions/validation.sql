CREATE OR REPLACE FUNCTION hospital_info.validate_customer_staging()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Customer_Name IS NULL OR TRIM(NEW.Customer_Name) = '' THEN
        RAISE EXCEPTION 'Customer Name cannot be empty';
    END IF;

    IF NEW.Last_Consulted_Date IS NOT NULL AND NEW.Last_Consulted_Date < NEW.Open_Date THEN
        RAISE EXCEPTION 'Last Consulted Date cannot be before Open Date';
    END IF;

    IF NEW.Is_Active IS NOT NULL AND NEW.Is_Active NOT IN ('A', 'I') THEN
        RAISE EXCEPTION 'Is_Active must be either A or I';
    END IF;

    IF NEW.Customer_ID IS NULL OR TRIM(NEW.Customer_ID) = '' THEN
        RAISE EXCEPTION 'Customer ID cannot be empty';
    END IF;

    IF NEW.Open_Date > CURRENT_DATE THEN
        RAISE EXCEPTION 'Open Date cannot be in the future';
    END IF;
    
    IF NEW.Last_Consulted_Date > CURRENT_DATE THEN
        RAISE EXCEPTION 'Last Consulted Date cannot be in the future';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;