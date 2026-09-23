# MT2 visual organization

The Flutter app does not use a standalone `res/` directory at runtime.

All supplied Android visual resources are classified into feature folders:

- `assets/mt2/home/` — home, navigation and main assets
- `assets/mt2/room/` — voice-room, seats, microphones and room controls
- `assets/mt2/gifts/` — gifts and gift effects
- `assets/mt2/ranking/` — ranking, medals and leaderboards
- `assets/mt2/vip/` — VIP/SVIP
- `assets/mt2/family/` — family
- `assets/mt2/cp/` — CP/relation
- `assets/mt2/auth/` — login/splash/logo
- `assets/mt2/common/` — shared assets

The Dart code is also feature-based:

- `lib/screens/home_screen.dart`
- `lib/screens/discover_screen.dart`
- `lib/screens/party_screen.dart`
- `lib/screens/room_screen.dart`
- `lib/screens/messages_screen.dart`
- `lib/screens/chat_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/screens/account_screens.dart`
- `lib/widgets/mt2_widgets.dart`
- `lib/theme/app_theme.dart`

Use `tool/import_res_design.sh res.zip` to classify the Android resources. Do not copy the Android `res` tree into `lib/`.
