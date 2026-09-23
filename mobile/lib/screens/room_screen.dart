import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RoomScreen extends StatefulWidget{
  final String title; const RoomScreen({super.key,required this.title});
  @override State<RoomScreen> createState()=>_RoomScreenState();
}
class _RoomScreenState extends State<RoomScreen>{
  bool muted=false,liked=false;
  @override Widget build(BuildContext c)=>Scaffold(
    backgroundColor:const Color(0xFF090512),
    appBar:AppBar(title:Row(children:[const CircleAvatar(radius:18,child:Icon(Icons.person,size:20)),const SizedBox(width:9),Expanded(child:Text(widget.title,overflow:TextOverflow.ellipsis))]),actions:[IconButton(onPressed:(){},icon:const Icon(Icons.more_horiz))]),
    body:Column(children:[
      Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(16,2,16,10),child:const Row(children:[Icon(Icons.campaign_outlined,color:AppTheme.gold,size:19),SizedBox(width:7),Expanded(child:Text('Welcome to the party room. Be kind and have fun.',style:TextStyle(color:Colors.white70)))])),
      Expanded(child:GridView.builder(padding:const EdgeInsets.symmetric(horizontal:18,vertical:18),itemCount:10,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,crossAxisSpacing:12,mainAxisSpacing:20,childAspectRatio:.72),itemBuilder:(_,i)=>Column(children:[
        Stack(alignment:Alignment.bottomRight,children:[CircleAvatar(radius:29,backgroundColor:i==0?AppTheme.gold:AppTheme.purple,child:const Icon(Icons.person)),Container(width:18,height:18,decoration:BoxDecoration(color:const Color(0xFF251332),shape:BoxShape.circle,border:Border.all(color:Colors.white12)),child:Icon(i==0?Icons.star:Icons.mic,size:11,color:i==0?AppTheme.gold:Colors.white70))]),
        const SizedBox(height:6),Text(i==0?'Host':'Seat '+(i+1).toString(),style:const TextStyle(fontSize:10))
      ]))),
      Container(padding:const EdgeInsets.fromLTRB(12,10,12,12),color:const Color(0xFF140B20),child:Row(children:[
        Expanded(child:TextField(decoration:InputDecoration(hintText:'Say something...',filled:true,fillColor:Colors.white.withOpacity(.06),border:OutlineInputBorder(borderRadius:BorderRadius.circular(24),borderSide:BorderSide.none),contentPadding:const EdgeInsets.symmetric(horizontal:17,vertical:11)))),
        IconButton(onPressed:()=>_gifts(c),icon:const Icon(Icons.card_giftcard,color:AppTheme.gold)),
        IconButton(onPressed:()=>setState(()=>muted=!muted),icon:Icon(muted?Icons.mic_off:Icons.mic)),
        IconButton(onPressed:()=>setState(()=>liked=!liked),icon:Icon(liked?Icons.favorite:Icons.favorite_border,color:liked?Colors.pinkAccent:null)),
      ])),
    ]),
  );
  void _gifts(BuildContext c)=>showModalBottomSheet(context:c,backgroundColor:const Color(0xFF160C22),showDragHandle:true,builder:(_)=>const GiftPanel());
}
class GiftPanel extends StatelessWidget{
  const GiftPanel({super.key});
  @override Widget build(BuildContext c){
    const gifts=[['🌹','Rose','1'],['💎','Diamond','10'],['👑','Crown','50'],['🚀','Rocket','100'],['❤️','Love','5'],['🎁','Box','20'],['🎉','Party','30'],['💰','Coins','80']];
    return SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(18,4,18,24),child:Column(mainAxisSize:MainAxisSize.min,children:[
      const Row(children:[Expanded(child:Text('Gifts',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900))),Text('Balance 1,250',style:TextStyle(color:AppTheme.gold))]),const SizedBox(height:18),
      GridView.count(crossAxisCount:4,shrinkWrap:true,mainAxisSpacing:14,crossAxisSpacing:10,children:gifts.map((g)=>InkWell(onTap:()=>Navigator.pop(c),child:Column(children:[Text(g[0],style:const TextStyle(fontSize:34)),Text(g[1],style:const TextStyle(fontSize:11)),Text(g[2],style:const TextStyle(fontSize:10,color:Colors.white54))]))).toList())
    ])));
  }
}