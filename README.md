# Mushroom Master

This repo contains the Mushroom Master app and the code I used to build and evaluate the model and collect the supporting data.

- The Flutter app lives in `mobile-app`.
- Model training/evaluation notebooks live in `deep-learning-model`.
- Data gathering and scripts live in `gathering-data`.

## Quick start

- App (Flutter):
  - Prereqs: Flutter (stable), Android Studio SDKs, Xcode for iOS.
  - Run:
    ```
    cd mobile-app
    flutter pub get
    flutter run
    ```
  - Tests:
    ```
    flutter test
    ```

- Notebooks:
  - Prereqs: Python 3.x + Jupyter.
  - Launch:
    ```
    cd deep-learning-model
    pip install jupyter numpy pandas matplotlib tensorflow  # adjust to your setup
    jupyter notebook
    ```

- Data scripts:
  - See [gathering-data/README](gathering-data/README.md) for what each script does and any setup.

## Repo layout

- [mobile-app](mobile-app/README.md) — Flutter app. Main code under `lib/`, tests under `test/`, assets (model, labels, db) under `assets/`.
- [deep-learning-model](deep-learning-model/README.md) — notebooks and small helpers for training/evaluation.
- [gathering-data](gathering-data/README.md) — scripts for scraping images and building the field guide data.

## Model File Hosting

The `.tflite` model file used in the app is hosted externally due to size constraints. You can download it from the following link:

[Download model.tflite](https://drive.google.com/drive/u/0/folders/1EZMteL_5zmNYjDi0AsAEAfsgrGLrqjMD)

After downloading, place the file in the `mobile-app/assets/` directory.

## License and attribution

- License: MIT — see [LICENSE](LICENSE).
- Taxonomy data in the app is based on GBIF, used under CC BY 4.0.
- Images from the Danish Fungi 2020 dataset were used in training (MycoKey, University of Copenhagen, Danish National History Museum). Source: L. Picek et al., WACV 2022, DOI: 10.48550/arXiv.2103.10107.
- Some training images were sourced from the Mushroom Observer Machine Learning Dataset (CC BY-SA 3.0): https://mushroomobserver.org/articles/20

## Notes

- CocoaPods/Flutter build outputs and large native binaries are not needed in git. If you cloned a dev snapshot with those files, run `flutter clean` inside `mobile-app` and make sure `Pods/` and `build/` are ignored.
- Large model/db assets are tracked with Git LFS.

Contributions are welcome. Open an issue or a PR.