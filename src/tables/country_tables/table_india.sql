REATE TABLE hospital_info.Table_India (
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
);

-- Create index
CREATE INDEX idx_india_consult_date ON hospital_info.Table_India(Last_Consulted_Date);
