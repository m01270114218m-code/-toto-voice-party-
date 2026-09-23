import 'package:flutter/material.dart';
import '../widgets/mt2_widgets.dart';
import 'room_screen.dart';
class PartyScreen extends StatelessWidget{
  const PartyScreen({super.key});
  @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(18,16,18,24),children:[
    Row(children:[const Expanded(child:Text('Party',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900))),IconButton(onPressed:(){},icon:const Icon(Icons.add_circle_outline)),IconButton(onPressed:(){},icon:const Icon(Icons.filter_list))]),
    const SizedBox(height:12),
    GradientCard(child:Row(children:[const CircleAvatar(radius:28,child:Icon(Icons.mic)),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Create a room',style:TextStyle(fontWeight:FontWeight.w900,fontSize:18)),Text('Start your own live voice party.',style:TextStyle(color:Colors.white60))])),FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const RoomScreen(title:'My New Room'))),child:const Text('Create'))])),
    const SizedBox(height:22),
    GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:12,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.14),itemBuilder:(_,i)=>RoomTile(index:i,onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RoomScreen(title:'Party Room '+(i+1).toString()))))),
  ]));
}