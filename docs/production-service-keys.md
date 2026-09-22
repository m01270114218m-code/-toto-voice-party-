# تاج لايف — مفاتيح الخدمات

لا تضع هذه القيم داخل Flutter أو GitHub.

## LiveKit
Supabase Edge Function: `livekit-token`

Secrets:
- LIVEKIT_URL
- LIVEKIT_API_KEY
- LIVEKIT_API_SECRET

## Paymob Egypt
Supabase Edge Functions: `paymob-create-intention` و `paymob-webhook`

Secrets:
- PAYMOB_BASE_URL=https://accept.paymob.com
- PAYMOB_SECRET_KEY
- PAYMOB_PUBLIC_KEY
- PAYMOB_HMAC_SECRET
- PAYMOB_INTEGRATION_ID_CARD

ضعها في Supabase Edge Function Secrets.

بعد إدخال المفاتيح:
- LiveKit يصبح الصوت الحقيقي داخل الغرف.
- Paymob يصبح الشحن الحقيقي.
- إضافة العملات لا تتم إلا بعد webhook Paymob موثّق بـ HMAC.
