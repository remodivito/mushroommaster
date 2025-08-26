from google.cloud import storage
from collections import defaultdict

BUCKET_NAME = 'mushroom-master-central'
CLEANED_DATA_PREFIX = 'cleaned_dataset/'

client = storage.Client()
bucket = client.bucket(BUCKET_NAME)  
image_counts = defaultdict(int)

print(f"Counting images under '{CLEANED_DATA_PREFIX}'...")
blobs = list(client.list_blobs(BUCKET_NAME, prefix=CLEANED_DATA_PREFIX))

blob_count = 0
for blob in blobs:
    blob_count += 1
    if blob.name.lower().endswith(('.jpg', '.jpeg', '.png', '.bmp', '.gif')):
        relative_path = blob.name[len(CLEANED_DATA_PREFIX):]
        parts = relative_path.split('/')
        if len(parts) >= 2:
            subdir = parts[0]
            image_counts[subdir] += 1

print(f"Total blobs scanned: {blob_count}")

dirs_to_delete = [d for d, c in image_counts.items() if c < 600]

print(f"\nDirectories to delete (<350 images): {len(dirs_to_delete)}")
for d in dirs_to_delete:
    print(f"- {d} ({image_counts[d]} images)")

confirm = input("\nProceed to delete these directories? (y/n): ").strip().lower()
if confirm == 'y':
    for subdir in dirs_to_delete:
        full_prefix = f"{CLEANED_DATA_PREFIX}{subdir}/"
        print(f"Deleting all blobs under {full_prefix}...")

        blobs_to_delete = list(client.list_blobs(BUCKET_NAME, prefix=full_prefix))
        
        if blobs_to_delete:
            bucket.delete_blobs(blobs_to_delete)  
            print(f"Deleted {len(blobs_to_delete)} files in {subdir}/")

    print("Deletion complete.")
else:
    print("Deletion canceled.")
