import os
import shutil
from tqdm import tqdm
from imagededup.methods import PHash

def sanitize_species_name(name):
    """Ensure directory names are filesystem-safe."""
    return name.strip().replace(" ", "_").replace("/", "-")

def merge_datasets(dataset_paths, merged_root):
    """Merge datasets while removing duplicates using perceptual hashing."""
    phasher = PHash()
    seen_hashes = set()  # Track image hashes for deduplication
    
    for dataset in dataset_paths:
        species_dirs = os.listdir(dataset)
        
        for species_dir in tqdm(species_dirs, desc=f"Processing {os.path.basename(dataset)}"):
            src_species_path = os.path.join(dataset, species_dir)
            
            if not os.path.isdir(src_species_path):
                continue  # Skip non-directory files
                
            # Sanitize species name
            sanitized_species = sanitize_species_name(species_dir)
            dest_species_path = os.path.join(merged_root, sanitized_species)
            os.makedirs(dest_species_path, exist_ok=True)

            # Process images
            for img_file in os.listdir(src_species_path):
                src_img_path = os.path.join(src_species_path, img_file)
                
                if not os.path.isfile(src_img_path):
                    continue  # Skip non-file items
                
                try:
                    # Generate perceptual hash
                    img_hash = phasher.encode_image(src_img_path)
                    
                    # Check for duplicates
                    if img_hash in seen_hashes:
                        print(f"Skipping duplicate: {src_img_path}")
                        continue
                        
                    # Copy image if unique
                    dest_img_path = os.path.join(dest_species_path, img_file)
                    shutil.move(src_img_path, dest_img_path)
                    seen_hashes.add(img_hash)
                    
                except Exception as e:
                    print(f"Error processing {src_img_path}: {str(e)}")
                    continue

# Configuration
dataset_paths = [
    "DF_images",
    "MO_MI_images"
]
merged_root = "Model Data"

# Run the merge with deduplication
merge_datasets(dataset_paths, merged_root)
