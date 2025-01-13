import psycopg2
from datetime import datetime
import configparser
import os

def load_config():
    """Load configuration from config.ini"""
    config = configparser.ConfigParser()
    config_path = os.path.join(os.path.dirname(__file__), 'config.ini')
    config.read(config_path)
    return config

def process_hospital_data(file_path):
    """Process hospital data file and load into database"""
    config = load_config()
    
    # Connect to database
    conn = psycopg2.connect(
        dbname=config['DATABASE']['dbname'],
        user=config['DATABASE']['user'],
        password=config['DATABASE']['password'],
        host=config['DATABASE']['host'],
        port=config['DATABASE']['port']
    )
    cursor = conn.cursor()
    
    try:
        # Read and process the file
        with open(file_path, 'r') as file:
            header = None
            for line in file:
                if line.startswith('|H|'):
                    header = line.strip().split('|')[2:-1]
                elif line.startswith('|D|'):
                    values = line.strip().split('|')[2:-1]
                    if header:
                        record = dict(zip(header, values))
                        
                        # Insert into staging table
                        cursor.execute("""
                            INSERT INTO hospital_info.Customer_Staging 
                            (Customer_Name, Customer_ID, Open_Date, Last_Consulted_Date,
                             Vaccination_Type, Doctor_Consulted, State, Country, 
                             Date_of_Birth, Is_Active)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        """, (
                            record['Customer_Name'],
                            record['Customer_Id'],
                            datetime.strptime(record['Open_Date'], '%Y%m%d').date(),
                            datetime.strptime(record['Last_Consulted_Date'], '%Y%m%d').date() if record.get('Last_Consulted_Date') else None,
                            record.get('Vaccination_Id'),
                            record.get('Dr_Name'),
                            record.get('State'),
                            record.get('Country'),
                            datetime.strptime(record['DOB'], '%d%m%Y').date() if record.get('DOB') else None,
                            record.get('Is_Active')
                        ))
        
        # Commit staging table insertions
        conn.commit()
        
        # Move data to country tables
        cursor.execute("SELECT hospital_info.move_to_india()")
        conn.commit()
        
        print("Data processing completed successfully!")
        
    except Exception as e:
        conn.rollback()
        print(f"Error processing data: {str(e)}")
        raise
    finally:
        cursor.close()
        conn.close()
