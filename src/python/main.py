import os
from hospital_etl import process_hospital_data
from db_manager import run_database_scripts

def main():
    """Main function to run the hospital data management system"""
    try:
        # First, set up the database structure
        print("Setting up database structure...")
        run_database_scripts()
        
        # Then process the data file
        config = load_config()
        input_dir = os.path.join(os.path.dirname(__file__), config['PATHS']['input_dir'])
        data_file = os.path.join(input_dir, 'hospital_data.txt')
        
        if os.path.exists(data_file):
            print(f"Processing data file: {data_file}")
            process_hospital_data(data_file)
        else:
            print(f"Data file not found: {data_file}")
            
    except Exception as e:
        print(f"Error in main process: {str(e)}")

if __name__ == "__main__":
    main()