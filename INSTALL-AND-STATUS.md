# Royal Voice 4.2 — Full Clean

هذا الإصدار مبني على المواصفات المرفوعة مع فصل واضح بين الواجهة والخادم وبيانات CMS والخدمات الحقيقية.

## المسارات المعتمدة
- `public/` واجهة التطبيق فقط.
- `admin/` لوحة الإدارة فقط.
- `data/` بيانات seed/CMS المحلية فقط.
- `database/` مخططات Supabase/PostgreSQL.
- `server.js` API + Socket.IO.
- `supabase-rest.js` طبقة اتصال Supabase.
- `capacitor.config.ts` إعداد Capacitor.

## الخدمات
- Supabase Auth/Database/Realtime.
- LiveKit للصوت.
- Socket.IO للحضور والدردشة وأحداث الغرفة.

## تشغيل
1. Node.js 20+.
2. `npm install`.
3. اضبط متغيرات البيئة من `.env.example`.
4. `npm start`.
5. التطبيق: `/` ولوحة الإدارة: `/admin`.

## Android
يتم توليد مجلد `android/` بواسطة `npm run android:add` ثم `npm run android:sync`. لا توجد نسخة Android قديمة داخل هذا الإصدار.