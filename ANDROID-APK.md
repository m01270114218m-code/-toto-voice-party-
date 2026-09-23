# Android build — Royal Voice 4.2

1. Install Node.js 20+ and Android Studio/SDK.
2. Run `npm install`.
3. Set `ROYAL_API_BASE` in `public/mobile-config.js` to a public HTTPS API before building.
4. Run `npm run android:add` once.
5. Run `npm run android:sync`.
6. Run `npm run android:build` for a debug APK.
7. Run `npm run android:release` for a release build after signing configuration.

The repository intentionally contains no legacy Android project; Capacitor generates the Android project from the current `public/` tree.