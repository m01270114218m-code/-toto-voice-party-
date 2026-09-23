import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/mt2_widgets.dart';

class SimplePage extends StatelessWidget{
  final String title;final Widget child;
  const SimplePage({super.key,required this.title,required this.child});
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(title)),body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.all(18),child:child)));
}
class GiftsScreen extends StatelessWidget{
  const GiftsScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'My Gifts',child:Column(children:[
    GradientCard(colors:const[Color(0xFF32165B),Color(0xFF8B3D9D)],child:const Row(children:[Icon(Icons.card_giftcard,size:42,color:AppTheme.gold),SizedBox(width:14),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Gift Collection',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),Text('89 gifts received',style:TextStyle(color:Colors.white60))])])),
    const SizedBox(height:22),GridView.count(crossAxisCount:4,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),mainAxisSpacing:22,children:List.generate(12,(i)=>Column(children:[Text(['🌹','💎','👑','🚀','❤️','🎁'][i%6],style:const TextStyle(fontSize:34)),Text('Gift '+(i+1).toString(),style:const TextStyle(fontSize:11))])))
  ]));
}
class VipScreen extends StatelessWidget{
  const VipScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'VIP Center',child:Column(children:[
    GradientCard(colors:const[Color(0xFF3B1C05),Color(0xFF8A5A0A)],child:const Row(children:[Icon(Icons.workspace_premium,color:AppTheme.gold,size:52),SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('VIP 7',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900)),Text('1,280 / 2,000 XP',style:TextStyle(color:Colors.white70))]))])),
    const SizedBox(height:18),...['Exclusive frame','VIP entrance effect','Special gifts','Private room badge','Monthly rewards'].map((x)=>Card(child:ListTile(leading:const Icon(Icons.check_circle,color:AppTheme.gold),title:Text(x))))
  ]));
}
class RankingScreen extends StatelessWidget{
  const RankingScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'Ranking',child:Column(children:[
    GradientCard(colors:const[Color(0xFF4A2106),Color(0xFF6D28D9)],child:const Column(children:[Icon(Icons.emoji_events,size:55,color:AppTheme.gold),Text('Royal Ranking',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),Text('Today • Hosts',style:TextStyle(color:Colors.white60))])),
    const SizedBox(height:18),...List.generate(10,(i)=>Card(child:ListTile(leading:CircleAvatar(child:Text((i+1).toString())),title:Text('Top Host '+(i+1).toString(),style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(((120-i*7)*100).toString()+' popularity'),trailing:const Icon(Icons.chevron_right))))
  ]));
}
class FamilyScreen extends StatelessWidget{
  const FamilyScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'Family',child:Column(children:[
    GradientCard(colors:const[Color(0xFF25134B),Color(0xFF7437A5)],child:const Row(children:[CircleAvatar(radius:31,child:Icon(Icons.family_restroom,size:34)),SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('MT2 Royal Family',style:TextStyle(fontSize:20,fontWeight:FontWeight.w900)),Text('Level 21 • 328 members',style:TextStyle(color:Colors.white60))]))])),
    const SizedBox(height:20),const SectionHeader('Family Center'),...['Family members','Daily sign-in','Family tasks','Family ranking','Family settings'].map((x)=>Card(child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_right))))
  ]));
}
class WalletScreen extends StatelessWidget{
  const WalletScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'Wallet',child:Column(children:[
    GradientCard(child:const Column(children:[Text('Coin Balance',style:TextStyle(color:Colors.white60)),Text('1,250',style:TextStyle(fontSize:38,fontWeight:FontWeight.w900,color:AppTheme.gold)),Text('Diamonds 320 • Beans 85',style:TextStyle(color:Colors.white70))])),
    const SizedBox(height:18),FilledButton.icon(onPressed:(){},icon:const Icon(Icons.add),label:const Text('Recharge')),const SizedBox(height:18),
    ...['Transaction history','Gift income','Recharge records'].map((x)=>Card(child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_right))))
  ]));
}
class MomentsScreen extends StatelessWidget{
  const MomentsScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'Moments',child:Column(children:List.generate(5,(i)=>Card(margin:const EdgeInsets.only(bottom:10),child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Row(children:[const AvatarBubble(index:2,radius:22),const SizedBox(width:10),Text('User '+(i+1).toString(),style:const TextStyle(fontWeight:FontWeight.w800))]),const SizedBox(height:12),
    Text('Having a great time in MT2 Party room '+(i+1).toString()+'! 🎉'),const SizedBox(height:10),
    Row(children:[const Icon(Icons.favorite_border,size:19),const SizedBox(width:5),Text((12+i).toString()),const SizedBox(width:20),const Icon(Icons.chat_bubble_outline,size:19),const SizedBox(width:5),Text((3+i).toString())])
  ]))))));
}
class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});
  @override Widget build(BuildContext c)=>SimplePage(title:'Settings',child:Column(children:[
    ...['Account & Security','Notifications','Privacy','Language','Clear cache','About MT2'].map((x)=>Card(child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_right)))),
    const SizedBox(height:20),OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.logout),label:const Text('Log out'))
  ]));
}