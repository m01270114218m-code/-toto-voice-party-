# MT2 visual file locations

The supplied res.zip is an Android resource bundle. It is imported to:

- mobile/assets/mt2/res/

The MT2 animation archive is imported to:

- mobile/assets/mt2/assets/

Visual families:

- Home: mipmap-xxhdpi-v4/ic_main_*, ic_home_*, bg_main_home_*
- Navigation: ic_nav_selected_*, ic_nav_unselected_*
- Voice room: ic_room_*, ic_capsule_mic_*, ic_mic_*
- Gifts: ic_gift_*, ic_capsule_gift_*, gift_*
- Rankings: ic_rank_*, ic_main_rank_*, bg_room_rank
- VIP/SVIP: ic_vip_*, ic_svip_*, main_me_vip_bg
- Family: ic_family_*, ic_user_family*, ic_main_cp_family
- CP: ic_cp_*, ic_cencel_cp_*, ic_invite_cp_*
- Login/splash: ic_login_logo, ic_splash_logo, ic_logo

Flutter declares assets/mt2/ as the single asset root. Do not move resources into lib/.

Import from mobile/:
bash tool/import_res_design.sh /path/to/res.zip
bash tool/import_mt2_assets.sh /path/to/MT2.zip
