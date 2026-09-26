# VoiceRoom — Production Control Center

هذا المستودع يحتوي على النسخة الجديدة من مركز تحكم VoiceRoom.

## لوحة الإدارة
- المسار: `admin/`
- React + Vite
- اتصال مباشر بـ Supabase
- تسجيل دخول Supabase Auth
- التحقق من صلاحية الإدارة عبر `is_admin()`
- إدارة المستخدمين والغرف والأصول والهدايا وإعدادات التطبيق

## التشغيل
داخل مجلد `admin`:

```bash
npm install
npm run dev
```

للنشر على Vercel استخدم Root Directory = `admin` و Build Command = `npm run build`.

## متغيرات البيئة
انسخ `admin/.env.example` إلى متغيرات البيئة في Vercel أو بيئة التشغيل، وضع مفتاح Supabase العام فقط.

> لا تضع Service Role Key أو كلمات مرور الإدارة داخل GitHub.
