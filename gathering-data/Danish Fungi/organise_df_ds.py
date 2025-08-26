import os
import shutil
import pandas as pd
from tqdm import tqdm 

csv_path = "Danish Fungi/DF20-metadata/DF20-public_test_metadata_PROD-2.csv"  
src_dir = "/Users/remo/Downloads/DF20_300"         
dest_dir = "DF_images"          

# Load the CSV metadata
df = pd.read_csv(csv_path)

# Sanitize species names to remove invalid characters (e.g., spaces, slashes)
def sanitize_species_name(name):
    return name.replace(" ", "_").replace("/", "-").strip()

# Iterate through each row in the CSV
for _, row in tqdm(df.iterrows(), total=len(df)):
    if pd.isna(row["species"]):
        continue
    image_filename = os.path.basename(row["image_path"])  
    species = sanitize_species_name(row["species"])
    
    # Define source and destination paths
    src_path = os.path.join(src_dir, image_filename)
    dest_folder = os.path.join(dest_dir, species)
    dest_path = os.path.join(dest_folder, image_filename)
    
    # Skip if the image doesn't exist
    if not os.path.exists(src_path):
        print(f"Missing: {src_path}")
        continue
    
    # Create species directory if it doesn't exist
    os.makedirs(dest_folder, exist_ok=True)
    
    shutil.copy2(src_path, dest_path)  