# VoiceRoom API

Backend production foundation for authentication, rooms, realtime chat, wallet ledger, gifts and admin moderation.

## Run locally
1. Copy `.env.example` to `.env` and change `JWT_SECRET` and admin credentials.
2. `docker compose up --build`
3. API: `http://localhost:8080/health`

## Production requirements
- Use managed PostgreSQL with encrypted connection.
- Put API behind HTTPS/reverse proxy.
- Replace admin bootstrap/auth with your organization identity provider or a secure admin provisioning flow.
- Configure push notifications, object storage, payment provider and a voice provider (LiveKit/Agora) before public launch.
- Never ship secrets inside the Flutter app.