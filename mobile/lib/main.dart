import 'package:flutter/material.dart';

void main() => runApp(const Mt2App());

class Mt2App extends StatelessWidget {
  const Mt2App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'MT2 Voice Party',
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF120B20),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5CF6), brightness: Brightness.dark),
    ),
    home: const HomeShell(),
  );
}

class HomeShell extends StatefulWidget { const HomeShell({super.key}); @override State<HomeShell> createState()=>_HomeShellState(); }
class _HomeShellState extends State<HomeShell> {
  int index=0;
  final pages=const [HomePage(),DiscoverPage(),PartyPage(),MessagesPage(),ProfilePage()];
  @override Widget build(BuildContext context)=>Scaffold(
    body:pages[index],
    bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(v)=>setState(()=>index=v),destinations:const [
      NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
      NavigationDestination(icon:Icon(Icons.explore_outlined),selectedIcon:Icon(Icons.explore),label:'Discover'),
      NavigationDestination(icon:Icon(Icons.mic_none),selectedIcon:Icon(Icons.mic),label:'Party'),
      NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat_bubble),label:'Messages'),
      NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Me'),
    ]));
}

class PageFrame extends StatelessWidget { final String title; final Widget child; const PageFrame({super.key,required this.title,required this.child}); @override Widget build(BuildContext c)=>SafeArea(child:CustomScrollView(slivers:[SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,18,20,10),child:Text(title,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w800)))),SliverPadding(padding:const EdgeInsets.all(16),sliver:SliverToBoxAdapter(child:child))])); }
class SectionTitle extends StatelessWidget { final String text; const SectionTitle(this.text,{super.key}); @override Widget build(BuildContext c)=>Text(text,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)); }

class HomePage extends StatelessWidget { const HomePage({super.key}); @override Widget build(BuildContext c)=>PageFrame(title:'MT2 PARTY',child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Container(height:190,padding:const EdgeInsets.all(22),decoration:BoxDecoration(borderRadius:BorderRadius.circular(26),gradient:const LinearGradient(colors:[Color(0xFF32155B),Color(0xFF8B3D9D)])),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('VOICE • PARTY • FRIENDS',style:TextStyle(color:Color(0xFFFFD76A),fontWeight:FontWeight.bold)),Spacer(),Text('Your voice, your world.',style:TextStyle(fontSize:28,fontWeight:FontWeight.w800)),SizedBox(height:8),Text('Meet people and join live rooms.')])) ,
  const SizedBox(height:24),const SectionTitle('Popular Rooms'),const SizedBox(height:12),
  GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:6,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.25),itemBuilder:(c,i)=>RoomCard(index:i)),
  const SizedBox(height:24),const SectionTitle('Featured Hosts'),const SizedBox(height:12),
  SizedBox(height:90,child:ListView.separated(scrollDirection:Axis.horizontal,itemCount:8,itemBuilder:(c,i)=>CircleAvatar(radius:40,backgroundColor:Color.lerp(const Color(0xFF6D28D9),const Color(0xFFEAB308),i/8)),separatorBuilder:(_,__)=>const SizedBox(width:12))),
])); }
class RoomCard extends StatelessWidget { final int index; const RoomCard({super.key,required this.index}); @override Widget build(BuildContext c)=>InkWell(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>VoiceRoom(title:'Room '+(index+1).toString()))),child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(borderRadius:BorderRadius.circular(20),gradient:LinearGradient(colors:[const Color(0xFF24143A),Color.lerp(const Color(0xFF24143A),const Color(0xFF7C3AED),index/6)!]),border:Border.all(color:Colors.white12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Spacer(),Text('Live Room '+(index+1).toString(),style:const TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:6),Text((12+index*7).toString()+' online',style:const TextStyle(color:Colors.white60))]))); }
class DiscoverPage extends StatelessWidget { const DiscoverPage({super.key}); @override Widget build(BuildContext c)=>PageFrame(title:'Discover',child:Column(children:[Wrap(spacing:8,runSpacing:8,children:['Trending','Nearby','New','Music','Games','Family'].map((x)=>Chip(label:Text(x))).toList()),const SizedBox(height:20),const SectionTitle('Royal Ranking'),const SizedBox(height:12),Container(height:150,width:double.infinity,decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),gradient:const LinearGradient(colors:[Color(0xFF3B0764),Color(0xFFEAB308)])),child:const Center(child:Text('TOP HOSTS',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900))))])); }
class PartyPage extends StatelessWidget { const PartyPage({super.key}); @override Widget build(BuildContext c)=>PageFrame(title:'Party',child:GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:12,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.2),itemBuilder:(_,i)=>RoomCard(index:i))); }
class MessagesPage extends StatelessWidget { const MessagesPage({super.key}); @override Widget build(BuildContext c)=>PageFrame(title:'Messages',child:Column(children:List.generate(8,(i)=>ListTile(contentPadding:const EdgeInsets.symmetric(vertical:8),leading:CircleAvatar(child:Text((i+1).toString())),title:Text('User '+(i+1).toString()),subtitle:const Text('New message'),trailing:const Icon(Icons.chevron_right))))); }
class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext c)=>PageFrame(title:'Me',child:Column(children:[const CircleAvatar(radius:48,child:Icon(Icons.person,size:50)),const SizedBox(height:12),const Text('MT2 User',style:TextStyle(fontSize:24,fontWeight:FontWeight.w800)),const SizedBox(height:24),...['VIP Center','My Gifts','Rank & Achievements','Family','Settings'].map((x)=>Card(child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_right))))])); }

class VoiceRoom extends StatelessWidget { final String title; const VoiceRoom({super.key,required this.title}); @override Widget build(BuildContext c)=>Scaffold(backgroundColor:const Color(0xFF0D0718),appBar:AppBar(title:Text(title),backgroundColor:Colors.transparent),body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[Container(width:double.infinity,padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFF26113C),borderRadius:BorderRadius.circular(16)),child:const Text('Announcement • Welcome to the party room')),const SizedBox(height:18),Expanded(child:GridView.builder(itemCount:10,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,crossAxisSpacing:12,mainAxisSpacing:18),itemBuilder:(_,i)=>Column(children:[CircleAvatar(radius:29,backgroundColor:i==0?const Color(0xFFEAB308):const Color(0xFF6D28D9),child:const Icon(Icons.person)),const SizedBox(height:6),Text(i==0?'Host':'Seat '+(i+1).toString(),style:const TextStyle(fontSize:11))]))),Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:const Color(0xFF1B1028),borderRadius:BorderRadius.circular(20)),child:Row(children:[const Expanded(child:Text('Say something...')),IconButton(onPressed:()=>showModalBottomSheet(context:c,builder:(_)=>const GiftSheet()),icon:const Icon(Icons.card_giftcard)),IconButton(onPressed:(){},icon:const Icon(Icons.mic)),IconButton(onPressed:(){},icon:const Icon(Icons.more_horiz))]))]))); }
class GiftSheet extends StatelessWidget { const GiftSheet({super.key}); @override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(18),child:Wrap(spacing:18,runSpacing:18,children:['🎁','💎','🌹','👑','🚀','❤️','💰','🎉'].map((x)=>Column(mainAxisSize:MainAxisSize.min,children:[Text(x,style:const TextStyle(fontSize:36)),const Text('Gift')])).toList()))); }
