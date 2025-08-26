# Contributing

Thanks for helping improve Mushroom Master. Keep changes small and focused. Open an issue before large changes.

## Project layout

- App: see [mobile-app/README.md](mobile-app/README.md)
- Model notebooks: see [deep-learning-model/README.md](deep-learning-model/README.md)
- Data scripts: see [gathering-data/README.md](gathering-data/README.md)

## Getting started

- Fork the repo, create a feature branch.
- Make sure ignores and LFS are respected:
  - Ignore build artifacts and Pods (see [.gitignore](.gitignore)).
  - Track large assets like .tflite/.db with Git LFS (see [.gitattributes](.gitattributes)).

## Development

Flutter app (mobile-app):
- Setup:
  - Install Flutter (stable), Android SDKs, Xcode if building iOS.
  - From `mobile-app`:
    - `flutter pub get`
    - iOS only: `cd ios && pod install && cd ..`
- Run:
  - `flutter run`
- Checks:
  - `flutter format .`
  - `flutter analyze`
  - `flutter test`

Python notebooks (deep-learning-model):
- Use Python 3.x and Jupyter.
- Install deps you need (numpy, pandas, matplotlib, tensorflow, scikit-learn, etc.).
- Clear outputs before committing:
  - `jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb`

Data scripts (gathering-data):
- Read the notes in [gathering-data/README.md](gathering-data/README.md).
- Respect dataset licenses and terms of use.

## Code style

- Dart: `flutter format .` and fix analyzer warnings.
- Python: format with `black` (or similar) and keep imports ordered.
- Small, focused PRs with clear titles. Describe what changed and why.

## Do not commit

- iOS Pods, Flutter build outputs, Android build dirs, .dart_tool.
- Real service credentials or API keys (e.g., GoogleService-Info.plist). Use examples/placeholders instead.
- Large binaries outside Git LFS (.tflite, .db, model checkpoints).

## Submitting a pull request

- Rebase onto latest `main`.
- Run all checks listed above.
- Add or update tests when changing behavior.
- Update docs if needed (e.g., [mobile-app/README.md](mobile-app/README.md)).

## Attribution and licenses

- Keep third‑party notices intact (TensorFlow Lite, Flutter plugins, etc.).
- When adding datasets or derived artifacts, include proper attribution in the relevant README and ensure