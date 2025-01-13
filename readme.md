# Hospital Data Management System

A robust PostgreSQL-based solution for managing global hospital patient records with automated distribution into country-specific tables.

## Overview

This system is designed for a multi-specialty hospital chain with locations worldwide, focusing on vaccination records and patient management. It provides an efficient way to:
- Handle patient data across multiple countries
- Manage customer records with unique user cards
- Distribute data into country-specific tables
- Track vaccination records
- Monitor patient consultations

## Features

- **Global Data Management**: Efficiently handles billions of daily records
- **Smart Data Distribution**: Automatically sorts patients into country-specific tables
- **Data Validation**: Comprehensive checks for data integrity
- **Age Calculation**: Automatic patient age computation
- **Follow-up Tracking**: Identifies patients needing follow-up (>30 days since last consultation)
- **Active Record Management**: Tracks active/inactive patient status

## Technical Stack

- PostgreSQL Database
- PL/pgSQL for stored procedures
- Database Schema: hospital_info

## Installation

1. Ensure PostgreSQL is installed on your system
2. Clone this repository:
   ```bash
   git clone https://github.com/ankitayadav167/hospital-data-management-system.git
   ```

## Database Structure

### Tables
- **Customer_Staging**: Temporary holding area for all patient data
- **Table_India**: Specific table for Indian patients
- Additional country-specific tables created dynamically

### Views
- **Customer_Staging_View**: Enhanced view with calculated fields
- **Table_India_View**: Country-specific view with additional metrics

### Functions
- `validate_customer_staging()`: Ensures data quality
- `move_to_india()`: Transfers records to India-specific table
- `cleanup_staging()`: Maintains database efficiency
- `create_country_table()`: Dynamically creates new country tables

## Usage

### Creating a New Country Table
```sql
SELECT hospital_info.create_country_table('USA');
```

### Adding New Patients
```sql
INSERT INTO hospital_info.Customer_Staging 
VALUES ('John', '123458', '2010-10-12', '2012-10-13', 'MVD', 'Paul', 'TN', 'IND', '600001', '1987-03-06', 'A');
```

### Moving Records to Country Tables
```sql
SELECT hospital_info.move_to_india();
```

## Data Dictionary

| Column Name | Data Type | Description |
|------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Patient's full name |
| Customer_ID | VARCHAR(18) | Unique identifier |
| Open_Date | DATE | First visit date |
| Last_Consulted_Date | DATE | Most recent consultation |
| Vaccination_Type | CHAR(5) | Type of vaccination |
| Doctor_Consulted | CHAR(255) | Treating physician |
| State | CHAR(5) | Patient's state |
| Country | CHAR(5) | Patient's country |
| Postcode | INT | Postal code |
| Date_of_Birth | DATE | Patient's birth date |
| Is_Active | CHAR(1) | Active status (A/I) |

## Maintenance

Regular maintenance tasks:
```sql
-- Clean up staging table (run weekly)
SELECT hospital_info.cleanup_staging();
```
