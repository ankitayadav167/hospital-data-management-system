CREATE OR REPLACE FUNCTION hospital_info.cleanup_staging()
RETURNS void AS $$
BEGIN
    DELETE FROM hospital_info.Customer_Staging
    WHERE Last_Consulted_Date < CURRENT_DATE - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql;
