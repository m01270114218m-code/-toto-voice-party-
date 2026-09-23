# Royal Voice 4.2 — Full Clean

منصة اجتماعية صوتية 3D مبنية على Supabase + LiveKit + Socket.IO + Capacitor.

## التشغيل
```bash
npm install
npm start
```

افتح `http://localhost:3000`.

## Android
اضبط `window.ROYAL_API_BASE` في `public/mobile-config.js` على عنوان HTTPS عام للخادم، ثم:
```bash
npm run android:add
npm run android:sync
npm run android:build
```

## البنية
الواجهة في `public/`، لوحة الإدارة في `admin/`، بيانات CMS في `data/`، SQL في `database/`، والخادم في `server.js`.

لا تضع مفاتيح LiveKit السرية أو Supabase service-role داخل المستودع أو التطبيق.