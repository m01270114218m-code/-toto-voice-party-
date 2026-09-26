# VoiceRoom Pro — إطلاق الإنتاج

هذا التسليم يضم التطبيق + لوحة الإدارة + Backend قابل للتشغيل. لكي يصبح خدمة عامة حقيقية، نفّذ هذه الخطوات على حساباتك السحابية:

1. PostgreSQL مُدار + نسخ احتياطية.
2. API على VPS/Render/Fly.io/AWS مع HTTPS.
3. تخزين صور/فيديو على S3 أو Supabase Storage.
4. Firebase Cloud Messaging للإشعارات.
5. LiveKit أو Agora للصوت المباشر.
6. Google Play Billing للـCoins وVIP؛ التحقق من الشراء يجب أن يتم على الخادم.
7. دومين للوحة الإدارة مثل `admin.example.com` ودومين للـAPI مثل `api.example.com`.
8. متغيرات أسرار منفصلة للإنتاج وStaging.
9. مراقبة أخطاء ونسخ احتياطية وسجل تدقيق.
10. اختبار أمني واختبار تحميل قبل فتح التسجيل العام.