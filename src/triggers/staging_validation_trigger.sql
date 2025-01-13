CREATE TRIGGER validate_customer_staging_trigger
    BEFORE INSERT OR UPDATE ON hospital_info.Customer_Staging
    FOR EACH ROW EXECUTE FUNCTION hospital_info.validate_customer_staging();

COMMENT ON TRIGGER validate_customer_staging_trigger ON hospital_info.Customer_Staging 
IS 'Validates customer data before insert or update operations';