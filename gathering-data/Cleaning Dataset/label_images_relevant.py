import os
import cv2
import random

# Set up paths
image_folder = "/Users/remo/repos/mushroom_master/gathering-data/Model_Data"
output_file = "labels.csv"

# Get all image file paths recursively
image_paths = []
for root, _, files in os.walk(image_folder):
    for file in files:
        if file.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif', '.tiff')):
            image_paths.append(os.path.join(root, file))

# Shuffle the list for random order
random.shuffle(image_paths)

labels = {}

print("Instructions:")
print("Press R for Relevant")
print("Press I for Irrelevant")
print("Press S to skip this image")
print("Press D when done to save and exit")

# Labeling loop
for img_path in image_paths:
    image = cv2.imread(img_path)
    
    if image is None:
        print(f"Skipping unreadable image: {img_path}")
        continue

    cv2.imshow("Label Image (R=Relevant, I=Irrelevant, S=Skip, D=Done)", image)
    key = cv2.waitKey(0) & 0xFF  

    # Check the key pressed
    if key == ord('r'):
        labels[img_path] = "Relevant"
    elif key == ord('i'):
        labels[img_path] = "Irrelevant"
    elif key == ord('s'):
        print(f"Skipped: {img_path}")
    elif key == ord('d'):
        print("Done pressed. Exiting labeling loop.")
        cv2.destroyAllWindows()
        break

    cv2.destroyAllWindows()

# Save labels to CSV
with open(output_file, "w") as f:
    f.write("image_path,label\n")  
    for img, label in labels.items():
        f.write(f"{img},{label}\n")

print(f"Labeling complete. Labels saved to: {output_file}")
