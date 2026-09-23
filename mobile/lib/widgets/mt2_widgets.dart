import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientCard extends StatelessWidget{
  final Widget child; final EdgeInsets padding; final List<Color> colors;
  const GradientCard({super.key,required this.child,this.padding=const EdgeInsets.all(16),this.colors=const[Color(0xFF271442),Color(0xFF5B247A)]});
  @override Widget build(BuildContext c)=>Container(padding:padding,decoration:BoxDecoration(gradient:LinearGradient(colors:colors),borderRadius:BorderRadius.circular(22),border:Border.all(color:Colors.white10)),child:child);
}
class SectionHeader extends StatelessWidget{
  final String title; final String? action; final VoidCallback? onTap;
  const SectionHeader(this.title,{super.key,this.action,this.onTap});
  @override Widget build(BuildContext c)=>Row(children:[Expanded(child:Text(title,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800))),if(action!=null)TextButton(onPressed:onTap,child:Text(action!))]);
}
class AvatarBubble extends StatelessWidget{
  final int index; final double radius; final bool online;
  const AvatarBubble({super.key,required this.index,this.radius=28,this.online=false});
  @override Widget build(BuildContext c)=>Stack(children:[
    CircleAvatar(radius:radius,backgroundColor:Color.lerp(AppTheme.purple,AppTheme.gold,(index%8)/8),child:Icon(Icons.person,size:radius,color:Colors.white70)),
    if(online)Positioned(right:0,bottom:1,child:Container(width:12,height:12,decoration:BoxDecoration(color:Colors.greenAccent,shape:BoxShape.circle,border:Border.all(color:AppTheme.bg,width:2)))),
  ]);
}
class RoomTile extends StatelessWidget{
  final int index; final VoidCallback onTap;
  const RoomTile({super.key,required this.index,required this.onTap});
  @override Widget build(BuildContext c)=>InkWell(
    onTap:onTap,borderRadius:BorderRadius.circular(20),
    child:GradientCard(padding:const EdgeInsets.all(14),colors:[const Color(0xFF211331),Color.lerp(const Color(0xFF211331),AppTheme.purple,(index%5)/5)!],
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[AvatarBubble(index:index,radius:23,online:true),const Spacer(),const Icon(Icons.more_horiz,color:Colors.white54)]),
        const Spacer(),Text('Party Room '+(index+1).toString(),style:const TextStyle(fontWeight:FontWeight.w800)),
        const SizedBox(height:5),Row(children:[const Icon(Icons.headset_mic,size:14,color:AppTheme.gold),const SizedBox(width:5),Text((10+index*7).toString()+' online',style:const TextStyle(color:Colors.white60,fontSize:12))]),
      ]),
    ),
  );
}