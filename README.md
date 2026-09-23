# MT2 Voice Party

Clean Flutter voice-party application rebuilt from scratch around the MT2 visual/resource structure.

## Project layout

- `mobile/lib/main.dart` — clean MT2-oriented UI foundation.
- `mobile/assets/mt2/` — MT2 resources are imported here when available.
- `mobile/tool/import_mt2_assets.sh` — imports `assets/` and `res/` from the supplied MT2 archive.
- `mobile/tool/configure_android.sh` — adds the Android permissions required for a voice-party app.
- `mobile/tool/bootstrap_flutter.sh` — creates the standard Android platform files for a clean checkout.
- `.github/workflows/build-apk.yml` — bootstraps, analyzes, tests, and builds the release APK.

## MT2 resources

The source MT2 archive is not committed as one large binary. Use:

```bash
cd mobile
bash tool/import_mt2_assets.sh /path/to/MT2.zip
```

The importer preserves the archive's `assets/` and `res/` structure under `mobile/assets/mt2/`.

## Local setup

From `mobile/`:

```bash
bash tool/bootstrap_flutter.sh
flutter pub get
flutter analyze
flutter test
flutter run
```

The repository intentionally contains no legacy backend, migrations, or previous application implementation.
