# TOYO — Voice Party

تطبيق Android عربي RTL لغرف الدردشة الصوتية، مع Backend وواجهة إدارة.

## البناء
يتم فحص مشروع Flutter (flutter analyze) قبل إنشاء APK، ثم يتم التحقق من وجود ملف APK قبل رفعه.

## المكونات
- mobile: تطبيق Android Flutter.
- backend: API Node.js + PostgreSQL + Socket.IO.
- admin: لوحة تحكم Web.

## ملاحظة
مفاتيح الخدمات الخارجية مثل Agora وFCM والدفع لا توضع داخل المستودع. يمكن إضافتها لاحقًا عبر متغيرات البيئة.
