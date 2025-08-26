"""
This script fetches all species under the kingdom of fungi (Q764) and saves the results into a SQL database.

To run:
python3 -u fetching/fetch_with_rel_and_value.py --data_dir simple_wikidata_db/data/processed --db_file fungi_species.db --num_procs 6
"""

import argparse
import os
import pickle
from tqdm import tqdm
import sqlite3
import logging

from utils import jsonl_generator, get_batch_files

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('fetch_with_rel_and_value.log')
    ]
)

def get_arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--data_dir', type=str, required=True, help='Path to preprocessed data directory')
    parser.add_argument('--db_file', type=str, required=True, help='Output SQLite database file')
    parser.add_argument('--num_procs', type=int, default=1, help='Number of processes')
    return parser

def get_commons_image_url(filename):
    """
    Construct the direct URL to the image file on Wikimedia Commons.
    """
    if not filename:
        return None
    if filename.startswith('File:'):
        filename = filename[len('File:'):]  # Remove 'File:' prefix
    filename = filename.replace(' ', '_')   # Replace spaces with underscores
    import urllib.parse
    filename_encoded = urllib.parse.quote(filename)
    return f'https://commons.wikimedia.org/wiki/Special:FilePath/{filename_encoded}'

def load_species_qids(data_dir):
    """
    Load all QIDs where P105 (taxon rank) == Q7432 (species)
    """
    species_qids = set()
    entity_rels_dir = os.path.join(data_dir, 'entity_rels')
    files = get_batch_files(entity_rels_dir)
    for file in tqdm(files, desc='Loading species QIDs'):
        for item in jsonl_generator(file):
            if item['property_id'] == 'P105' and item['value'] == 'Q7432':
                species_qids.add(item['qid'])
    return species_qids

def load_parent_taxa(data_dir):
    """
    Load parent taxa relationships (P171 only)
    """
    parent_taxa = {}
    entity_rels_dir = os.path.join(data_dir, 'entity_rels')
    files = get_batch_files(entity_rels_dir)
    for file in tqdm(files, desc='Loading parent taxa'):
        for item in jsonl_generator(file):
            if item['property_id'] == 'P171':
                qid = item['qid']
                parent = item['value']
                if qid not in parent_taxa:
                    parent_taxa[qid] = []
                parent_taxa[qid].append(parent)
    return parent_taxa

def load_labels(data_dir, qid_filter):
    """
    Load labels for specified QIDs
    """
    labels = {}
    labels_dir = os.path.join(data_dir, 'labels')
    files = get_batch_files(labels_dir)
    for file in tqdm(files, desc='Loading labels'):
        for item in jsonl_generator(file):
            qid = item['qid']
            if qid in qid_filter:
                labels[qid] = item['label']
    return labels

def load_descriptions(data_dir, qid_filter):
    """
    Load descriptions for specified QIDs
    """
    descriptions = {}
    descriptions_dir = os.path.join(data_dir, 'descriptions')
    files = get_batch_files(descriptions_dir)
    for file in tqdm(files, desc='Loading descriptions'):
        for item in jsonl_generator(file):
            qid = item['qid']
            if qid in qid_filter:
                descriptions[qid] = item['description']
    return descriptions

def load_property_values(data_dir, property_id, qid_filter):
    """
    Load values for a given property ID, filtering by a set of QIDs.
    """
    property_values = {}
    entity_values_dir = os.path.join(data_dir, 'entity_values')
    entity_rels_dir = os.path.join(data_dir, 'entity_rels')
    files = get_batch_files(entity_values_dir) + get_batch_files(entity_rels_dir)
    for file in tqdm(files, desc=f'Loading property {property_id} values'):
        for item in jsonl_generator(file):
            qid = item['qid']
            if qid in qid_filter and item['property_id'] == property_id:
                property_values[qid] = item['value']
    return property_values

def is_descendant_of_iterative(qid, ancestor_qid, parent_taxa, cache):
    """
    Iteratively check if the species is a descendant of the given ancestor_qid
    """
    stack = [qid]
    visited = set()

    while stack:
        current = stack.pop()
        if current in cache:
            if cache[current]:
                cache[qid] = True
                return True
            continue
        if current == ancestor_qid:
            cache[qid] = True
            return True
        if current in visited:
            continue
        visited.add(current)
        parents = parent_taxa.get(current, [])
        stack.extend(parents)

    cache[qid] = False
    return False

def main():
    args = get_arg_parser().parse_args()
    data_dir = args.data_dir
    db_file = args.db_file

    # Step 1: Load all species QIDs fresh (no caching)
    logging.info("Loading species QIDs...")
    species_qids = load_species_qids(data_dir)
    logging.info(f"Found {len(species_qids)} total species.")

    # Step 2: Load parent taxa
    logging.info("Loading parent taxa...")
    parent_taxa = load_parent_taxa(data_dir)
    logging.info("Parent taxa loaded.")

    # Step 3: Define the ancestor QID (kingdom of fungi)
    ancestor_qid = 'Q764'  # Kingdom of fungi

    # Step 4: Filter species that are descendants of the ancestor_qid
    logging.info(f"Filtering species that are descendants of {ancestor_qid} (kingdom of fungi)...")
    cache = {}
    fungi_species = []
    for qid in tqdm(species_qids, desc='Processing species'):
        if is_descendant_of_iterative(qid, ancestor_qid, parent_taxa, cache):
            fungi_species.append(qid)
    logging.info(f"Found {len(fungi_species)} fungi species after filtering.")

    # Proceed only if we have fungi species
    if not fungi_species:
        logging.info("No fungi species found. Exiting.")
        return

    fungi_species_set = set(fungi_species)

    # Step 5: Load labels for fungi species
    logging.info("Loading labels for fungi species...")
    labels = load_labels(data_dir, fungi_species_set)
    logging.info("Labels loaded.")

    # Step 6: Load descriptions for fungi species
    logging.info("Loading descriptions for fungi species...")
    descriptions = load_descriptions(data_dir, fungi_species_set)
    logging.info("Descriptions loaded.")

    # Step 7: Load additional properties for fungi species
    properties = {
        'P31': {},   # instance of
        'P105': {},  # taxon rank
        'P171': {},  # parent taxon
        'P225': {},  # species name
        'P789': {},  # edibility
        'P18': {}    # image
    }

    for prop_id in properties.keys():
        logging.info(f"Loading property {prop_id} for fungi species...")
        props = load_property_values(data_dir, prop_id, fungi_species_set)
        properties[prop_id] = props
        logging.info(f"Property {prop_id} loaded with {len(props)} entries.")

    # Collect all unique QIDs from properties (except P18 which is image filename)
    property_value_qids = set()
    for prop_id in ['P31', 'P105', 'P171', 'P789']:
        property_value_qids.update(properties[prop_id].values())

    # Step 8: Load labels for property values
    logging.info("Loading labels for property values...")
    value_labels = load_labels(data_dir, property_value_qids)
    logging.info("Labels for property values loaded.")

    # Replace property value QIDs with their labels where available
    for prop_id in ['P31', 'P105', 'P171', 'P789']:
        for qid in properties[prop_id]:
            value_qid = properties[prop_id][qid]
            properties[prop_id][qid] = value_labels.get(value_qid, value_qid)

    # Step 9: Save data into SQL database
    try:
        logging.info(f"Saving data into SQL database {db_file}...")
        conn = sqlite3.connect(db_file)
        c = conn.cursor()
        c.execute('''
            CREATE TABLE IF NOT EXISTS fungi_species (
                qid TEXT PRIMARY KEY,
                label TEXT,
                description TEXT,
                instance_of TEXT,
                taxon_rank TEXT,
                parent_taxon TEXT,
                species_name TEXT,
                edibility TEXT,
                image TEXT
            )
        ''')

        # Prepare data for batch insertion
        data_to_insert = []
        for qid in tqdm(fungi_species, desc='Preparing data for database'):
            label = labels.get(qid)
            description = descriptions.get(qid)
            instance_of = properties['P31'].get(qid)
            taxon_rank = properties['P105'].get(qid)
            parent_taxon = properties['P171'].get(qid)
            species_name = properties['P225'].get(qid)
            edibility = properties['P789'].get(qid)
            image_filename = properties['P18'].get(qid)
            image_url = get_commons_image_url(image_filename) if image_filename else None

            data_to_insert.append((qid, label, description, instance_of, taxon_rank, parent_taxon, species_name, edibility, image_url))

        c.executemany('''
            INSERT OR REPLACE INTO fungi_species (
                qid, label, description, instance_of, taxon_rank, parent_taxon, species_name, edibility, image
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', data_to_insert)

        conn.commit()
        conn.close()
        logging.info("Done.")
    except Exception as e:
        logging.error(f"Error during saving to database: {e}")

if __name__ == "__main__":
    main()
