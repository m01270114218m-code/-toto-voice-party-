import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/mt2_widgets.dart';
import 'room_screen.dart';
import 'account_screens.dart';

class DiscoverScreen extends StatelessWidget{
  const DiscoverScreen({super.key});
  @override Widget build(BuildContext c){
    const cats=['Trending','Nearby','New','Music','Games','Family'];
    return SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(18,16,18,24),children:[
      Row(children:[const Expanded(child:Text('Discover',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900))),IconButton(onPressed:(){},icon:const Icon(Icons.search))]),
      const SizedBox(height:12),SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:cats.map((x)=>Padding(padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(x),selected:x=='Trending',onSelected:(_){ }))).toList())),
      const SizedBox(height:22),
      GradientCard(colors:const[Color(0xFF3D1266),Color(0xFFB66B20)],child:Row(children:[const Icon(Icons.emoji_events,color:AppTheme.gold,size:46),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Royal Ranking',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),Text('Top hosts, rooms and gifts today.',style:TextStyle(color:Colors.white70))])),OutlinedButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const RankingScreen())),child:const Text('View'))])),
      const SizedBox(height:26),const SectionHeader('Trending Rooms'),const SizedBox(height:12),
      ...List.generate(6,(i)=>Padding(padding:const EdgeInsets.only(bottom:10),child:ListTile(tileColor:Colors.white.withOpacity(.045),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)),leading:AvatarBubble(index:i,radius:28,online:true),title:Text('Trending Room '+(i+1).toString(),style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text((28+i*9).toString()+' people • Music & Chat'),trailing:FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RoomScreen(title:'Trending Room '+(i+1).toString()))),child:const Text('Join'))))),
    ]));
  }
}