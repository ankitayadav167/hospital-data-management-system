import psycopg2
import configparser
import os

def load_config():
    """Load configuration from config.ini"""
    config = configparser.ConfigParser()
    config_path = os.path.join(os.path.dirname(__file__), 'config.ini')
    config.read(config_path)
    return config

def run_database_scripts():
    """Run all database scripts in the correct order"""
    config = load_config()
    
    conn = psycopg2.connect(
        dbname=config['DATABASE']['dbname'],
        user=config['DATABASE']['user'],
        password=config['DATABASE']['password'],
        host=config['DATABASE']['host'],
        port=config['DATABASE']['port']
    )
    cursor = conn.cursor()
    
    sql_base_dir = os.path.join(os.path.dirname(__file__), config['PATHS']['sql_dir'])
    
    # Dictionary of scripts in execution order
    scripts = {
        'Schema': os.path.join(sql_base_dir, 'init/01_create_schema.sql'),
        'Staging Table': os.path.join(sql_base_dir, 'init/02_create_staging.sql'),
        'Views': [
            os.path.join(sql_base_dir, 'views/staging_view.sql'),
            os.path.join(sql_base_dir, 'views/country_view.sql')
        ],
        'Tables': [
            os.path.join(sql_base_dir, 'tables/country_tables/table_india.sql'),
            os.path.join(sql_base_dir, 'tables/create_country_table.sql')
        ],
        'Functions': [
            os.path.join(sql_base_dir, 'functions/validation.sql'),
            os.path.join(sql_base_dir, 'functions/data_movement.sql'),
            os.path.join(sql_base_dir, 'functions/cleanup.sql')
        ],
        'Triggers': [os.path.join(sql_base_dir, 'triggers/staging_validation_trigger.sql')]
    }
    
    try:
        # Execute scripts in order
        for script_type, script_paths in scripts.items():
            print(f"\nExecuting {script_type} scripts...")
            
            if isinstance(script_paths, str):
                script_paths = [script_paths]
            
            for script_path in script_paths:
                try:
                    with open(script_path, 'r') as file:
                        sql = file.read()
                        cursor.execute(sql)
                        conn.commit()
                        print(f"Successfully executed: {script_path}")
                except Exception as e:
                    print(f"Error executing {script_path}: {str(e)}")
                    conn.rollback()
        
        print("\nDatabase setup completed!")
        
    except Exception as e:
        print(f"Error: {str(e)}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()