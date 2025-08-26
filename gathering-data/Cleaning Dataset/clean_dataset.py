import os
import csv
import numpy as np
from multiprocessing import Pool, cpu_count
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import keras
import tensorflow as tf
from tqdm import tqdm  # For progress tracking

def load_and_preprocess_batch(file_paths):
    """Load and preprocess a batch of images without prediction"""
    target_size = (224, 224)
    batch_images = []
    valid_paths = []
    
    for file_path in file_paths:
        try:
            img = load_img(file_path, target_size=target_size)
            img_array = img_to_array(img)
            batch_images.append(img_array)
            valid_paths.append(file_path)
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
    
    if batch_images:
        batch_array = np.array(batch_images) / 255.0  # Normalize here
        return batch_array, valid_paths
    return None, valid_paths

def process_batch(model, file_paths):
    """Process a batch of images and return predictions"""
    # Load and preprocess images
    batch_array, valid_paths = load_and_preprocess_batch(file_paths)
    
    results = []
    if batch_array is not None and len(batch_array) > 0:
        # Make batch prediction
        predictions = model.predict(batch_array, verbose=0)
        
        # Create results
        for i, pred in enumerate(predictions):
            label = "relevant" if pred[0] >= 0.5 else "irrelevant"
            results.append((valid_paths[i], label))
    
    # Add errors for invalid paths
    for path in set(file_paths) - set(valid_paths):
        results.append((path, "error"))
        
    return results

def main():
    dataset_path = '/Users/remo/repos/mushroom_master/gathering-data/Model_Data'
    batch_size = 512  
    
    # Load the model once (not in each worker)
    model = keras.models.load_model('mushroom_model.keras')
    
    # Find all image files
    file_paths = []
    for root, dirs, files in os.walk(dataset_path):
        for file in files:
            if file.endswith((".jpg", ".JPG")) and not file.startswith('.'):
                file_paths.append(os.path.join(root, file))
    
    print(f"Found {len(file_paths)} images")
    
    # Process in batches
    results = []
    for i in tqdm(range(0, len(file_paths), batch_size)):
        batch_paths = file_paths[i:i + batch_size]
        batch_results = process_batch(model, batch_paths)
        results.extend(batch_results)
    
    # Write results to CSV
    csv_filename = 'inference_relevancy_results.csv'
    with open(csv_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['image_path', 'relevancy'])
        writer.writerows(results)
    
    print(f"Inference complete. Results saved to {csv_filename}")

if __name__ == '__main__':
    main()

