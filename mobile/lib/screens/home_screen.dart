import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/mt2_widgets.dart';
import 'room_screen.dart';
import 'account_screens.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(18,14,18,22),children:[
    Row(children:[const Expanded(child:Text('MT2 PARTY',style:TextStyle(fontSize:27,fontWeight:FontWeight.w900))),IconButton(onPressed:(){},icon:const Icon(Icons.search)),IconButton(onPressed:(){},icon:const Icon(Icons.notifications_none))]),
    const SizedBox(height:8),
    GradientCard(colors:const[Color(0xFF32175B),Color(0xFF9A3E92)],child:SizedBox(height:175,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('VOICE • PARTY • FRIENDS',style:TextStyle(color:AppTheme.gold,fontWeight:FontWeight.bold)),const Spacer(),
      const Text('Your voice,\nyour world.',style:TextStyle(fontSize:29,fontWeight:FontWeight.w900)),const SizedBox(height:8),
      Row(children:[const Expanded(child:Text('Join live rooms and meet new people.',style:TextStyle(color:Colors.white70))),FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const RoomScreen(title:'Featured Party'))),child:const Text('Join'))]),
    ]))),
    const SizedBox(height:24),const SectionHeader('Quick Access'),const SizedBox(height:12),
    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
      _quick(c,Icons.card_giftcard,'Gifts',const GiftsScreen()),_quick(c,Icons.workspace_premium,'VIP',const VipScreen()),
      _quick(c,Icons.emoji_events,'Ranking',const RankingScreen()),_quick(c,Icons.family_restroom,'Family',const FamilyScreen()),
    ]),
    const SizedBox(height:25),const SectionHeader('Popular Rooms',action:'See all'),const SizedBox(height:12),
    GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:6,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.16),itemBuilder:(_,i)=>RoomTile(index:i,onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RoomScreen(title:'Party Room '+(i+1).toString()))))),
    const SizedBox(height:25),const SectionHeader('Featured Hosts'),const SizedBox(height:12),
    SizedBox(height:96,child:ListView.separated(scrollDirection:Axis.horizontal,itemCount:8,separatorBuilder:(_,__)=>const SizedBox(width:14),itemBuilder:(_,i)=>Column(children:[AvatarBubble(index:i,radius:30,online:true),const SizedBox(height:5),Text('Host '+(i+1).toString(),style:const TextStyle(fontSize:11))]))),
  ]));
  Widget _quick(BuildContext c,IconData icon,String label,Widget page)=>InkWell(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>page)),child:SizedBox(width:72,child:Column(children:[Container(width:54,height:54,decoration:BoxDecoration(color:Colors.white.withOpacity(.07),shape:BoxShape.circle),child:Icon(icon,color:AppTheme.gold)),const SizedBox(height:7),Text(label,style:const TextStyle(fontSize:12))])));
}