import csv
import json
import pandas as pd

def standings_to_csv(standing_json_file,standing_csv_file):

    with open(standing_json_file, "r") as file:
        json_data = json.load(file)

    
    for k,v in json_data.items():
        for k2, v2 in enumerate(v, start=1):
            team_data = v2
                
                
    home_stats = {}
    for k,v in enumerate(team_data['rows']):
        home_stats[k] = v



    csv_file_path = standing_csv_file

    # Open the CSV file in append mode
    with open(csv_file_path, 'a', newline='', encoding='utf-8') as csv_file:
        # Create a CSV writer object
        csv_writer = csv.writer(csv_file)

        # Check if the file is empty (write header if needed)
        if csv_file.tell() == 0:
            csv_writer.writerow(['Team', 'Matches', 'Wins', 'Loses', 'Draws', 'Points', 'GF', 'GA'])

        # Write the data rows
        for team_id, data in home_stats.items():
            csv_writer.writerow([data['team']['name'], data['matches'], data['wins'], data['losses'],
                                data['draws'], data['points'], data['scoresFor'], data['scoresAgainst']])
            
    print(f'Data has been successfully appended to {csv_file_path} from {standing_json_file}')

standings_to_csv('Standings Json/22-23 Eredivisie.json','Standings CSV/Eredivisie.csv')