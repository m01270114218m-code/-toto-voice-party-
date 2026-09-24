# فرعون بارتي — Pharaoh Party

منصة غرف دردشة صوتية عربية بواجهة ملكية، مع تطبيق Android مبني بـ Flutter.

## التشغيل
```bash
npm install
npm start
```

افتح `http://localhost:3000`.

## Android
التطبيق الموجود في `mobile/` هو مصدر نسخة Android. لبناء APK:
```bash
cd mobile
flutter pub get
flutter build apk --release
```

## البنية
الواجهة في `public/`، لوحة الإدارة في `admin/`، بيانات CMS في `data/`، SQL في `database/`، والخادم في `server.js`.

لا تضع مفاتيح LiveKit السرية أو Supabase service-role داخل المستودع أو التطبيق.