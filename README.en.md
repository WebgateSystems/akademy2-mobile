# Academy 2.0 (Flutter)

Languages: [Polski](README.md) · English · [Українська](README.uk.md)

Mobile learning app: modules with video, infographics, and quizzes; offline access via downloads; login with phone/PIN.

## Core features
- Phone + PIN login, auto-lock after returning from background.
- Catalog of subjects/modules with content cards (video, infographic/PDF, quiz).
- Video preview: local/remote files and YouTube, subtitles, progress indicator.
- Module downloads for offline (files, posters, subtitles) with integrity checks.
- PDF/image preview in dialogs with interactive zoom.
- Localization via `flutter_localizations`/`intl`, light and dark theme.
- Orientation: whole app stays portrait; video/YouTube dialogs may rotate to landscape and restore portrait on close.

## Tech architecture
- Flutter 3.4+/Dart 3.4+ (see `environment` in `pubspec.yaml`), dependencies via `flutter pub`.
- State: Riverpod; navigation: GoRouter; networking: Dio (+logger, retry); storage: Isar + secure storage.
- Downloads/offline: `DownloadManager` with content signature and metadata.
- Video: `video_player` for local/remote files, `youtube_player_flutter` for YouTube, `flutter_pdfview` for PDF.
- API config: compile-time `--dart-define=API_BASE_URL=<url>` (used in `core/network/api.dart` for `baseUrl`/`baseUploadUrl`).

## Run it
1) Install dependencies:
```bash
flutter pub get
```
2) Run (set API):
```bash
flutter run --dart-define=API_BASE_URL=https://test.akademy.edu.pl
```
3) Build release:
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your.api
# or
flutter build ios --release --dart-define=API_BASE_URL=https://your.api
```

## How to use
- Sign in with phone/PIN; bind a school if required.
- Pick a subject/module → open a content card:
  - video: local/remote or YouTube; subtitles picked up from local/remote files;
  - infographic/PDF: dialog preview with zoom/scroll;
  - quiz: navigate to the Quiz screen.
- For offline, tap the module download icon; the indicator shows progress.
- Video dialogs can rotate to landscape; orientation returns to portrait when closed.

## Project structure (short)
- `lib/app` — theme, router, entry `App`.
- `lib/core` — networking (Dio), storage (Isar/secure storage), downloads, sync, utils.
- `lib/features` — screens: auth/join, home/subjects/modules, videos, profile, splash.
- `assets/images`, `assets/fonts` — assets (logo, Rubik/Inter).
- `l10n` — localizations.

## Tests
Run unit/widget tests:
```bash
flutter test
```

## License
See `LICENSE.md`.
