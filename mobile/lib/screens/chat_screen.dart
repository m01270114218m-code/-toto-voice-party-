import 'package:flutter/material.dart';
class ChatScreen extends StatefulWidget{
  final String user; const ChatScreen({super.key,required this.user});
  @override State<ChatScreen> createState()=>_ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen>{
  final controller=TextEditingController();
  final messages=<String>['Hey! Welcome to MT2 👋','Are you joining the room tonight?'];
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(widget.user)),body:Column(children:[
    Expanded(child:ListView.builder(padding:const EdgeInsets.all(18),itemCount:messages.length,itemBuilder:(_,i)=>Align(alignment:i.isEven?Alignment.centerLeft:Alignment.centerRight,child:Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.symmetric(horizontal:14,vertical:11),decoration:BoxDecoration(color:i.isEven?Colors.white.withOpacity(.07):const Color(0xFF6336A0),borderRadius:BorderRadius.circular(18)),child:Text(messages[i]))))),
    SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(12,6,12,12),child:Row(children:[
      Expanded(child:TextField(controller:controller,decoration:InputDecoration(hintText:'Message...',filled:true,fillColor:Colors.white.withOpacity(.06),border:OutlineInputBorder(borderRadius:BorderRadius.circular(24),borderSide:BorderSide.none)))),
      IconButton(onPressed:(){if(controller.text.trim().isEmpty)return;setState((){messages.add(controller.text.trim());controller.clear();});},icon:const Icon(Icons.send))
    ])))
  ]));
}