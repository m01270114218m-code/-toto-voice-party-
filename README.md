# Royal Voice

Royal Voice LiveKit build: Supabase + LiveKit + Capacitor Android.

## Run
```bash
npm install
npm start
```
Open `http://localhost:3000`.

## Android
```bash
npm install
npx cap sync android
npx cap open android
```
Debug APK:
```bash
npx cap sync android
cd android
./gradlew assembleDebug
```

## LiveKit
The client requests temporary tokens from the Supabase `livekit-token` Edge Function and connects to the real LiveKit room. Keep `LIVEKIT_API_SECRET` only in Supabase Edge Function Secrets; never commit it.

## Supabase
Auth, profiles, rooms, seats/roles, messages, gifts, wallet and manual top-up are supported. Paymob is not used by the active manual charging flow.

## APK backend
Set `ROYAL_API_BASE` in `public/mobile-config.js` to the public HTTPS Node/Socket.IO backend before building. Do not use localhost in the APK.

The full local build is available as the Royal Voice LiveKit ZIP prepared in this chat.
