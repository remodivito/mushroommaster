import os
import csv
import shutil
import time
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm
import pandas as pd

def copy_file(src_dest):
    src, dest = src_dest
    try:
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copy2(src, dest)
        return True
    except Exception as e:
        print(f"Error copying {src}: {e}")
        return False

def create_clean_dataset(csv_path, output_dir, max_workers=None):
    start_time = time.time()
    
    print(f"Reading CSV file: {csv_path}")
    df = pd.read_csv(csv_path)
    
    relevant_df = df[df['relevancy'] == 'relevant']
    print(f"Found {len(relevant_df)} relevant images out of {len(df)} total")
    
    
    os.makedirs(output_dir, exist_ok=True)
    
    src_dest_pairs = []
    for _, row in relevant_df.iterrows():
        src_path = row['image_path']
        rel_path = os.path.relpath(src_path, '/Users/remo/repos/mushroom_master/gathering-data/Model_Data')
        dest_path = os.path.join(output_dir, rel_path)
        src_dest_pairs.append((src_path, dest_path))
    
    print(f"Copying {len(src_dest_pairs)} files to {output_dir}")
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        list(tqdm(
            executor.map(copy_file, src_dest_pairs), 
            total=len(src_dest_pairs),
            desc="Copying files"
        ))
    
    elapsed_time = time.time() - start_time
    print(f"Done! Created clean dataset at {output_dir}")
    print(f"Process completed in {elapsed_time:.2f} seconds")

if __name__ == "__main__":
    csv_file = 'inference_relevancy_results.csv'
    output_directory = 'Clean_Model_Data'
    
    max_threads = os.cpu_count()
    
    create_clean_dataset(
        csv_file,
        output_directory,
        max_threads
    )