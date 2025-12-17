# AKAdemy2.0 (Flutter)

Języki: Polski (domyślny) · [English](README.en.md) · [Українська](README.uk.md)

Aplikacja mobilna do nauki: moduły z wideo, infografikami i testami, dostęp offline dzięki pobieraniu treści, logowanie telefonem/PIN-em.

## Główne funkcje
- Logowanie telefonem i PIN-em, automatyczna blokada po powrocie z tła.
- Katalog modułów/przedmiotów z kartami treści (wideo, infografika/PDF, test).
- Podgląd wideo: pliki lokalne/sieciowe i YouTube, napisy, wskaźnik postępu.
- Pobieranie modułów do trybu offline (pliki, plakaty, napisy) z kontrolą integralności.
- Podgląd PDF/obrazów w dialogach, interaktywne powiększanie.
- Lokalizacja przez `flutter_localizations`/`intl`, jasny i ciemny motyw.
- Orientacja: cała aplikacja w pionie; dialogi wideo/YouTube mogą przechodzić w poziom i przy zamknięciu wracają do portretu.

## Architektura techniczna
- Flutter 3.4+/Dart 3.4+ (zob. `environment` w `pubspec.yaml`), zależności zarządzane przez `flutter pub`.
- Stan: Riverpod; nawigacja: GoRouter; sieć: Dio (+logger, retry); storage: Isar + secure storage.
- Pobieranie/offline: `DownloadManager` z podpisem treści i metadanymi.
- Wideo: `video_player` dla plików lokalnych/sieciowych, `youtube_player_flutter` dla YouTube, `flutter_pdfview` dla PDF.
- Konfiguracja API: compile-time `--dart-define=API_BASE_URL=<url>` (używane w `core/network/api.dart` dla `baseUrl`/`baseUploadUrl`).

## Jak uruchomić
1) Zainstaluj zależności:
```bash
flutter pub get
```
2) Uruchom (podaj API):
```bash
flutter run --dart-define=API_BASE_URL=https://test.akademy.edu.pl
```
3) Zbuduj wersję produkcyjną:
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your.api
# lub
flutter build ios --release --dart-define=API_BASE_URL=https://your.api
```

## Jak korzystać
- Zaloguj się telefonem/PIN-em; w razie potrzeby powiąż szkołę.
- Wybierz przedmiot/moduł → otwórz kartę treści:
  - wideo: lokalne/sieciowe lub YouTube; napisy ładowane z lokalnych/sieciowych plików;
  - infografika/PDF: podgląd w dialogu, możliwość powiększania/scrollu;
  - test: przejście do ekranu Quiz.
- Do trybu offline użyj ikony pobierania modułu; wskaźnik pokazuje postęp.
- Dialogi wideo mogą przechodzić w poziom; po zamknięciu orientacja wraca do pionu.

## Struktura projektu (skrót)
- `lib/app` — motyw, router, entry `App`.
- `lib/core` — sieć (Dio), storage (Isar/secure storage), pobieranie, synchronizacja, utils.
- `lib/features` — ekrany: auth/join, home/subjects/modules, videos, profile, splash.
- `assets/images`, `assets/fonts` — zasoby (logo, Rubik/Inter).
- `l10n` — lokalizacje.

## Testy
Uruchom testy unit/widget:
```bash
flutter test
```

## Licencja
Zobacz `LICENSE.md`.
