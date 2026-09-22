# VoiceRoom Pro — Full Production Foundation

مشروع عربي RTL لتطبيق غرف صوتية احترافي، مع تطبيق Flutter + Backend + لوحة تحكم.

## المكونات
- `mobile/`: تطبيق Android Flutter.
- `backend/`: API Node.js + PostgreSQL + Socket.IO، ويشمل Auth/Rooms/Chat/Wallet/Gifts/Admin.
- `admin/`: لوحة تحكم Web.
- `.github/workflows/build-apk.yml`: بناء APK تلقائي عبر GitHub Actions.
- `DEPLOYMENT_CHECKLIST.md`: متطلبات الإطلاق العام.

## مهم
لا توجد خدمة سحابية أو مفاتيح دفع/صوت/FCM داخل الملف لأن هذه مفاتيح سرية يجب أن تكون مملوكة لك. بعد ربط الخدمات السحابية وتشغيل المتغيرات البيئية يصبح المشروع قابلًا للنشر.

### البناء
أسهل طريقة لبناء APK هي GitHub Actions الموجود داخل المشروع.
