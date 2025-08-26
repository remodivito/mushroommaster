import os
import csv
import shutil
import random

# Define paths
labels_csv = "Cleaning Dataset/labels.csv"            
output_base_dir = "relevant_irrelevant_images"    

labels = ["Relevant", "Irrelevant"]
for label in labels:
    for split in ["train", "validation", "test"]:
        os.makedirs(os.path.join(output_base_dir, split, label), exist_ok=True)

# Load all CSV rows into a list and shuffle it
with open(labels_csv, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    rows = list(reader)
random.shuffle(rows)

total = len(rows)
val_count = int(total * 0.15)
test_count = int(total * 0.15)

for i, row in enumerate(rows):
    image_path = row['image_path']
    label = row['label']

    if i < val_count:
        split = "validation"
    elif i < val_count + test_count:
        split = "test"
    else:
        split = "train"

    dest_dir = os.path.join(output_base_dir, split, label)
    
    if os.path.exists(image_path):
        shutil.copy(image_path, dest_dir)
        print(f"Copied {image_path} to {dest_dir}")
    else:
        print(f"File not found: {image_path}")

print("Image sorting complete.")