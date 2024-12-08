import pandas as pd
from sqlalchemy import create_engine


HOST = 'localhost'           
USER = 'root'       
PASSWORD = 'your_password'  
DATABASE = 'football_analysis'   


CSV_FILE = 'path_to_your_csv_file.csv'  
TABLE_NAME = 'Laliga_home'         


try:
    engine = create_engine(f'mysql+mysqlconnector://{USER}:{PASSWORD}@{HOST}/{DATABASE}')
    print("Successfully connected to the database.")
except Exception as e:
    print("Error connecting to the database:", e)
    exit()


try:
    df = pd.read_csv(CSV_FILE)
    print("CSV file loaded into DataFrame successfully.")
except Exception as e:
    print("Error loading CSV file:", e)
    exit()


print("Preview of the DataFrame:")
print(df.head())


try:
    df.to_sql(TABLE_NAME, con=engine, if_exists='replace', index=False)
    print(f"Data successfully imported into table `{TABLE_NAME}`.")
except Exception as e:
    print("Error importing data to MySQL:", e)
