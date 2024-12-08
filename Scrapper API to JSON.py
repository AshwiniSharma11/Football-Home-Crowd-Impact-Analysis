import json
import requests

def json_scraper(url, file_name):
    print("Scraping data from: " + url)
    response = requests.request("GET", url)
    json_data = response.json()
    
    with open(file_name, 'w',  encoding='utf-8') as json_file:
        json.dump(json_data, json_file, ensure_ascii=False, indent=4)
        
    print("Data saved to: " + file_name)
    
    
json_scraper('https://api.sofascore.com/api/v1/unique-tournament/8/season/8578/team-events/home', 'dummy.json')