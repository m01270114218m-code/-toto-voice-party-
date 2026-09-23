import 'package:flutter/material.dart';
import '../widgets/mt2_widgets.dart';
import 'chat_screen.dart';
class MessagesScreen extends StatelessWidget{
  const MessagesScreen({super.key});
  @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(18,16,18,24),children:[
    Row(children:[const Expanded(child:Text('Messages',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900))),IconButton(onPressed:(){},icon:const Icon(Icons.person_add_alt_1))]),
    const SizedBox(height:12),TextField(decoration:InputDecoration(hintText:'Search messages',prefixIcon:const Icon(Icons.search),filled:true,fillColor:Colors.white.withOpacity(.06),border:OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(18)),borderSide:BorderSide.none))),
    const SizedBox(height:16),
    ...List.generate(10,(i)=>Padding(padding:const EdgeInsets.only(bottom:7),child:ListTile(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>ChatScreen(user:'User '+(i+1).toString()))),leading:AvatarBubble(index:i,radius:27,online:i.isEven),title:Text('User '+(i+1).toString(),style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:const Text('Welcome to MT2 Party'),trailing:const Icon(Icons.chevron_right,color:Colors.white38)))),
  ]));
}