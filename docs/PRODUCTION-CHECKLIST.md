# Production checklist

1. Authentication: phone OTP, email, Google/Apple; refresh/revoke sessions.
2. Database: apply database/schema.sql and enable row-level authorization.
3. Storage: avatars, room covers, banners, gift media, seasonal assets.
4. Voice: production LiveKit/SFU with server-issued tokens.
5. Economy: server-side atomic ledger, idempotency and receipt verification.
6. Moderation: reports, rate limits, blocked words/URLs, audit log, age protections.
7. Admin: role-based access, audit trails and approval workflows.
8. Notifications: FCM/APNs and transactional events.
9. Observability: logs, metrics, error tracking and backups.
10. Legal: privacy, terms, community guidelines and consent flows.