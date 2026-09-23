# MT2 asset integration

The source MT2 archive was inspected and contains about 2,000 visual/animation files, including 127 SVGA/MP4 animation assets plus PNG/WebP/JPG resources.

## Important
The original archive is an APK/resource bundle, not an open-source Flutter package. Its proprietary binary assets are therefore kept outside this repository until they are supplied for redistribution in the project.

## Asset families identified
- Home: discover, game, profile, hall flash, messages, new-user packs, party
- KRoom: gifts, gift counters, party wave, PK, rockets, lucky bags, fireworks, CP seat, voice effects
- Rank: charm/gift/room rank 1-3
- Family: level 8/21/26, sign-in, today
- CP: courting, CP background/line, relation upgrade, ring flash
- Diamond: add/flame/rotate/multiplier card
- Dynamic: in-room and moment-like animations
- Sign-in: reward/state/state2
- VIP/Nickname: VIP7/VIP8 and RTL variants
- UID: good-number levels 1-9
- Medal/identity/voice-wave animations

After copying the extracted assets into mobile/assets/mt2/, run flutter pub get and rebuild. The directory is already declared in pubspec.yaml.
