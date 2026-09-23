import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/mt2_widgets.dart';
import 'account_screens.dart';
class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});
  @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(18,16,18,24),children:[
    Row(children:[const Expanded(child:Text('Me',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900))),IconButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const SettingsScreen())),icon:const Icon(Icons.settings_outlined))]),
    const SizedBox(height:10),
    GradientCard(child:Column(children:[
      Row(children:[const AvatarBubble(index:7,radius:39),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('MT2 User',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900)),Text('ID 10006345 • Level 12',style:TextStyle(color:Colors.white60))])),IconButton(onPressed:(){},icon:const Icon(Icons.edit_outlined))]),
      const SizedBox(height:18),const Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[_Stat('Followers','1.2K'),_Stat('Following','326'),_Stat('Gifts','89')]),
    ])),
    const SizedBox(height:18),
    Row(children:[Expanded(child:_pill(c,Icons.account_balance_wallet_outlined,'Wallet',const WalletScreen())),const SizedBox(width:10),Expanded(child:_pill(c,Icons.workspace_premium,'VIP',const VipScreen()))]),
    const SizedBox(height:22),const SectionHeader('My Center'),const SizedBox(height:8),
    _item(c,Icons.card_giftcard,'My Gifts',const GiftsScreen()),_item(c,Icons.emoji_events_outlined,'Rank & Achievements',const RankingScreen()),_item(c,Icons.family_restroom,'Family',const FamilyScreen()),_item(c,Icons.favorite_border,'Moments',const MomentsScreen()),_item(c,Icons.settings_outlined,'Settings',const SettingsScreen()),
  ]));
  Widget _pill(BuildContext c,IconData i,String t,Widget p)=>InkWell(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p)),child:Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white.withOpacity(.06),borderRadius:BorderRadius.circular(18)),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(i,color:AppTheme.gold),const SizedBox(width:8),Text(t)])));
  Widget _item(BuildContext c,IconData i,String t,Widget p)=>Card(child:ListTile(leading:Icon(i,color:AppTheme.gold),title:Text(t,style:const TextStyle(fontWeight:FontWeight.w700)),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p))));
}
class _Stat extends StatelessWidget{final String a,b;const _Stat(this.a,this.b);@override Widget build(BuildContext c)=>Column(children:[Text(b,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800)),Text(a,style:const TextStyle(fontSize:12,color:Colors.white54))]);}