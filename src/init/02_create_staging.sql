CREATE TABLE hospital_info.Customer_Staging (
    Customer_Name VARCHAR(255) NOT NULL,
    Customer_ID VARCHAR(18) NOT NULL,
    Open_Date DATE NOT NULL,
    Last_Consulted_Date DATE,
    Vaccination_Type CHAR(5),
    Doctor_Consulted CHAR(255),
    State CHAR(5),
    Country CHAR(5),
    Postcode INT,
    Date_of_Birth DATE,
    Is_Active CHAR(1),
    PRIMARY KEY (Customer_Name, Customer_ID)
);

-- Create indexes
CREATE INDEX idx_country ON hospital_info.Customer_Staging(Country);
CREATE INDEX idx_consult_date ON hospital_info.Customer_Staging(Last_Consulted_Date);

COMMENT ON TABLE hospital_info.Customer_Staging IS 'Staging table for incoming patient data from all countries';