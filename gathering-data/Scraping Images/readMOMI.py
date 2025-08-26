import csv
import os
import requests
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor, as_completed

# Define the path to the CSV file and the directory to save images
csv_file_path = 'Scraping Images/MO MI images - imagesAndNames.csv' 
download_dir = 'MO_MI_images'
max_workers = 100  #

# Create the download directory if it doesn't exist
os.makedirs(download_dir, exist_ok=True)

# Function to download and save an image
def download_image(image, save_path):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'
    }
    try:
        response = requests.get(image, headers=headers, stream=True)
        if response.status_code == 200:
            with open(save_path, 'wb') as file:
                for chunk in response.iter_content(1024):
                    file.write(chunk)
            return True
        else:
            print(f"Failed to download {image} - Status code: {response.status_code}")
            return False
    except Exception as e:
        print(f"Error downloading {image} - {e}")
        return False

# Prepare download tasks for multi-processing
download_tasks = []

with open(csv_file_path, 'r') as file:
    reader = csv.reader(file)
    headers = next(reader) 
    image_index = headers.index('image')
    name_index = headers.index('name')  
    
    for idx, row in enumerate(reader):
        image = row[image_index]
        mushroom_name = row[name_index]
        
        # Create a directory for each mushroom species
        safe_mushroom_name = "".join(c for c in mushroom_name if c.isalnum() or c in " _-")
        species_dir = os.path.join(download_dir, safe_mushroom_name)
        os.makedirs(species_dir, exist_ok=True)
        
        # Determine the file extension and save path
        file_extension = image.split('.')[-1]
        save_path = os.path.join(species_dir, f"{safe_mushroom_name}_{idx}.{file_extension}") 
        
        # Add task to download tasks list
        download_tasks.append((image, save_path))

# Download images in parallel
with ThreadPoolExecutor(max_workers=max_workers) as executor:
    futures = [executor.submit(download_image, image, save_path) for image, save_path in download_tasks]
    for future in tqdm(as_completed(futures), total=len(futures), desc="Downloading images"):
        future.result()  

print("Download and organization completed.")
