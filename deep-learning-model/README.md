# Deep Learning Model

This folder contains notebooks and small scripts I used to train, evaluate, and iterate on the image model used by the app.

### What’s here

- Notebooks like `Mushroom_MasterV1.ipynb`, `Mushroom_MasterV1_4.ipynb`, etc. for experiments and evaluation.
- `create_training_curve.py` for plotting training curves.
- Advanced evaluation in `advanced_model_evaluation.ipynb`.

These notebooks assume access to training images and labels (datasets are not included here). See attribution below for where images came from.

### Environment

Use Python 3.x and Jupyter.

Quick setup:
```
pip install jupyter numpy pandas matplotlib scikit-learn tensorflow  # adjust to your GPU/CPU
jupyter notebook
```

If you run into version issues, pin exact versions that work for your machine.

### Running

- Open any notebook and run cells top to bottom.
- Update dataset paths as needed for your local filesystem.
- Export a `.tflite` model at the end (or convert from a SavedModel) and place it in the app’s `assets/`.

Tip: clear outputs before committing so diffs stay small:
```
jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb
```

### Model File Hosting

The `.tflite` model file generated from these notebooks is hosted externally due to size constraints. You can download it from the following link:

[Download model.tflite](https://drive.google.com/drive/u/0/folders/1EZMteL_5zmNYjDi0AsAEAfsgrGLrqjMD)

After downloading, place the file in the `mobile-app/assets/` directory.

### Attribution

- Danish Fungi 2020 dataset (MycoKey, University of Copenhagen, Danish National History Museum). WACV 2022. DOI: 10.48550/arXiv.2103.10107.
- Mushroom Observer Machine Learning Dataset, CC BY‑SA 3.0: https://mushroomobserver.org/articles/20