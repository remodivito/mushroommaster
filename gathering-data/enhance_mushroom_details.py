import sqlite3
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

def fetch_species_data(species_record):
    id, label = species_record
    print(f"Processing {label}")
    
    url_match = 'https://api.gbif.org/v1/species/match'
    params = {'name': label}
    try:
        resp_match = requests.get(url_match, params=params)
        resp_match.raise_for_status()
        data_match = resp_match.json()
    except Exception as e:
        print(f"Error matching {label}: {e}")
        return id, label, None

    taxon_key = data_match.get('usageKey')
    if not taxon_key:
        print(f"GBIF taxon key not found for {label}")
        return id, label, None

    # Get the species classification data
    url_species = f'https://api.gbif.org/v1/species/{taxon_key}'
    try:
        resp_species = requests.get(url_species)
        resp_species.raise_for_status()
        data_species = resp_species.json()
    except Exception as e:
        print(f"Error fetching species data for {label}: {e}")
        return id, label, None

    classification = {
        "class": data_species.get('class'),
        "phylum": data_species.get('phylum'),
        "order": data_species.get('order'),
        "family": data_species.get('family'),
        "genus": data_species.get('genus')
    }

    habitat_value = None
    url_occurrence = f'https://api.gbif.org/v1/occurrence/search?taxonKey={taxon_key}&limit=10'
    try:
        resp_occ = requests.get(url_occurrence)
        resp_occ.raise_for_status()
        occ_data = resp_occ.json()
        for occurrence in occ_data.get("results", []):
            habitat = occurrence.get("habitat")
            if habitat:
                habitat_value = habitat
                break
    except Exception as e:
        print(f"Error fetching occurrence data for {label}: {e}")
        habitat_value = None

    # Add habitat to the classification dictionary.
    classification["habitat"] = habitat_value

    print(
        f"Species: {label}\n"
        f"Class: {classification['class']}\n"
        f"Phylum: {classification['phylum']}\n"
        f"Order: {classification['order']}\n"
        f"Family: {classification['family']}\n"
        f"Genus: {classification['genus']}\n"
        f"Habitat: {classification['habitat']}\n--------------------------"
    )
    return id, label, classification

# Set up the SQLite database connection and ensure the table has the right columns.
conn = sqlite3.connect('mushrooms.db')
c = conn.cursor()
c.execute("PRAGMA table_info(fungi_species)")
columns = [col_info[1] for col_info in c.fetchall()]

if 'class' not in columns:
    c.execute('ALTER TABLE fungi_species ADD COLUMN "class" TEXT')
if 'phylum' not in columns:
    c.execute("ALTER TABLE fungi_species ADD COLUMN phylum TEXT")
if 'order' not in columns:
    c.execute('ALTER TABLE fungi_species ADD COLUMN "order" TEXT')
if 'family' not in columns:
    c.execute("ALTER TABLE fungi_species ADD COLUMN family TEXT")
if 'genus' not in columns:
    c.execute("ALTER TABLE fungi_species ADD COLUMN genus TEXT")
if 'habitat' not in columns:
    c.execute("ALTER TABLE fungi_species ADD COLUMN habitat TEXT")
conn.commit()

# Retrieve species list from the database.
c.execute("SELECT id, label FROM fungi_species")
species_list = c.fetchall()

results = []
with ThreadPoolExecutor(max_workers=80) as executor:
    future_to_species = {executor.submit(fetch_species_data, record): record for record in species_list}
    for future in as_completed(future_to_species):
        result = future.result()
        if result is not None:
            results.append(result)

for id, label, classification in results:
    if classification is None:
        continue  
    c.execute(
        'UPDATE fungi_species SET "class" = ?, phylum = ?, "order" = ?, family = ?, genus = ?, habitat = ? WHERE id = ?',
        (classification["class"],
         classification["phylum"],
         classification["order"],
         classification["family"],
         classification["genus"],
         classification["habitat"],
         id)
    )
conn.commit()
conn.close()
