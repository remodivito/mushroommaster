# Gathering Data

This directory contains all the code related to gathering data for the Mushroom Master app.

The “Scraping Images” folder has the script for downloading images used for training the model from the Mushroom Observer Machine Learning dataset:
https://mushroomobserver.org/articles/20

Other directories include attempts to reliably gather information about mushrooms for the “guide” part of the app. The “Wikidata - using swd” was the successful attempt (swd is the simple-wikidata-db package: https://github.com/neelguha/simple-wikidata-db). It uses modified fetching scripts, altered from those in the swd package, to gather relevant info about mushrooms from a downloaded Wikidata dump. The other attempts hit API limits but are archived here in case they’re useful as a secondary data source.

### Quick notes

- Clean GCS helpers and small utilities are included (see `clean_GCS_bucket.py`, `enhance_mushroom_details.py`).
- Image scraping scripts expect you to set paths and/or API endpoints in the script before running.
- If you need to re‑build the field guide database, start with the “Wikidata - using swd” pipeline, then normalize the output into the app’s `fungi_species.db` schema.

Please respect dataset licenses and terms of use when running these scripts.

### Model File Hosting

The `.tflite` model file used in the app is hosted externally due to size constraints. You can download it from the following link:

[Download model.tflite](https://drive.google.com/drive/u/0/folders/1EZMteL_5zmNYjDi0AsAEAfsgrGLrqjMD)

After downloading, place the file in the `mobile-app/assets/` directory.