# Royal Voice 4.2 Architecture

- `public/app.js`: واجهة العميل وحالة التطبيق.
- `public/index.html`: نقطة دخول واحدة للواجهة.
- `public/mobile-config.js`: إعدادات العميل العامة فقط.
- `server.js`: HTTP API وSocket.IO.
- `supabase-rest.js`: اتصال Supabase.
- `data/*.json`: seed/CMS fallback.
- LiveKit هو مسار الصوت النشط.
- لوحة `admin/` تعدّل بيانات CMS عبر API محمي.