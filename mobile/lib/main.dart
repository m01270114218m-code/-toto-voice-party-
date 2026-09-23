// lib/main.dart
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  SocketService.initSocket();
  runApp(const TajApp());
}

class SocketService {
  static late IO.Socket socket;
  static void initSocket() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }
}

const gold = Color(0xFFFFD66B);
const gold2 = Color(0xFFFFB62E);
const bg = Color(0xFF09070D);
const panel = Color(0xFF17111F);
const panel2 = Color(0xFF21152B);
const purple = Color(0xFF8C45D9);

class TajApp extends StatelessWidget {
  const TajApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taj Live',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bg,
          colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const MainNavigationPage(),
      );
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});
  @override State<MainNavigationPage> createState() => _MainNavigationPageState();
}
class _MainNavigationPageState extends State<MainNavigationPage> {
  int index = 0;
  final pages = const [HomePage(), DiscoverPage(), PartyPage(), MessagePage(), ProfilePage()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF0E0A13),
          indicatorColor: purple.withOpacity(.28),
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: gold), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore, color: gold), label: 'Discover'),
            NavigationDestination(icon: Icon(Icons.mic_none), selectedIcon: Icon(Icons.mic, color: gold), label: 'Party'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble, color: gold), label: 'Messages'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: gold), label: 'Me'),
          ],
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Row(children: [Icon(Icons.diamond, color: gold), SizedBox(width: 8), Text('TAJ', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2))]),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search)), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
    ),
    body: ListView(padding: const EdgeInsets.fromLTRB(14, 0, 14, 20), children: [
      _hero(),
      const SizedBox(height: 18),
      _sectionTitle('Popular Rooms', 'View all'),
      const SizedBox(height: 10),
      SizedBox(height: 160, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 5, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, i) => _roomCard(context, i))),
      const SizedBox(height: 22),
      _sectionTitle('Featured Hosts', 'More'),
      const SizedBox(height: 12),
      _hostRow(context),
      const SizedBox(height: 22),
      _sectionTitle('Recommended', 'Refresh'),
      const SizedBox(height: 10),
      ...List.generate(4, (i) => _wideRoom(context, i)),
    ]),
  );

  Widget _hero() => Container(
    height: 178,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF32144E), Color(0xFF0F0915)]),
      border: Border.all(color: gold.withOpacity(.20)),
      boxShadow: [BoxShadow(color: purple.withOpacity(.18), blurRadius: 28)],
    ),
    child: Stack(children: [
      Positioned(right: -20, top: -25, child: Icon(Icons.auto_awesome, size: 160, color: gold.withOpacity(.08))),
      const Positioned(left: 20, top: 24, child: Text('TAJ PARTY', style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2))),
      const Positioned(left: 20, top: 52, child: Text('Your voice,\nyour world.', style: TextStyle(fontSize: 30, height: 1.05, fontWeight: FontWeight.w900))),
      Positioned(left: 20, bottom: 18, child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.mic), label: const Text('Start Party'))),
    ]),
  );
}

Widget _sectionTitle(String a, String b) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(a, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)), Text(b, style: const TextStyle(color: gold, fontSize: 12))]);

Widget _roomCard(BuildContext context, int i) {
  final names = ['Royal Palace', 'Arabian Nights', 'Friends Club', 'Golden Lounge', 'Night Owls'];
  return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceChatRoom(title: names[i]))), child: Container(width: 205, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [panel2, Color(0xFF120D18)]), border: Border.all(color: Colors.white.withOpacity(.06))), child: Stack(children: [
    Positioned(top: 0, left: 0, right: 0, height: 76, child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), gradient: LinearGradient(colors: [purple.withOpacity(.65), Colors.transparent])))),
    const Positioned(left: 12, top: 12, child: CircleAvatar(radius: 25, backgroundColor: Color(0xFF30203C), child: Icon(Icons.person, color: gold))),
    Positioned(left: 12, top: 83, child: Text(names[i], style: const TextStyle(fontWeight: FontWeight.bold))),
    const Positioned(left: 12, bottom: 14, child: Row(children: [Icon(Icons.headset_mic, size: 14, color: gold), SizedBox(width: 4), Text('8.2K', style: TextStyle(fontSize: 11, color: Colors.white60))])),
    const Positioned(right: 12, top: 12, child: _LiveBadge()),
  ])));
}

class _LiveBadge extends StatelessWidget { const _LiveBadge(); @override Widget build(BuildContext c) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEC4B68), borderRadius: BorderRadius.circular(20)), child: const Text('LIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))); }

Widget _hostRow(BuildContext context) => SizedBox(height: 82, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 7, separatorBuilder: (_, __) => const SizedBox(width: 14), itemBuilder: (_, i) => Column(children: [Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [gold, purple])), child: const CircleAvatar(radius: 27, backgroundColor: panel, child: Icon(Icons.person, color: Colors.white))), const SizedBox(height: 5), Text('Host '+(i+1).toString(), style: const TextStyle(fontSize: 11))])));

Widget _wideRoom(BuildContext context, int i) => GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceChatRoom(title: 'Room '+(i + 1).toString()))), child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white.withOpacity(.05))), child: Row(children: [const CircleAvatar(radius: 28, backgroundColor: Color(0xFF33213F), child: Icon(Icons.person, color: gold)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Royal Voice Room', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 5), Text('🎤 Music • Games • Friends', style: TextStyle(color: Colors.white54, fontSize: 12))])), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(.05), borderRadius: BorderRadius.circular(20)), child: const Text('2.4K', style: TextStyle(fontSize: 11, color: gold))) ])));

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Discover', style: TextStyle(fontWeight: FontWeight.w800))), body: ListView(padding: const EdgeInsets.all(14), children: [const _Tabs(), const SizedBox(height: 18), _discoverBanner(), const SizedBox(height: 20), _sectionTitle('Trending', 'See all'), const SizedBox(height: 12), ...List.generate(6, (i) => _wideRoom(c, i))]);
}
class _Tabs extends StatelessWidget { const _Tabs(); @override Widget build(BuildContext c) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['Trending','Nearby','New','Music','Games','Family'].map((x)=>Padding(padding: const EdgeInsets.only(right: 8), child: Chip(label: Text(x), side: BorderSide.none, backgroundColor: x=='Trending'?purple.withOpacity(.35):panel))).toList())); }
Widget _discoverBanner() => Container(height: 120, padding: const EdgeInsets.all(18), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [Color(0xFF552B7D), Color(0xFF1A1022)])), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text('Royal Ranking', style: TextStyle(color: gold, fontWeight: FontWeight.bold)), SizedBox(height: 5), Text('Top hosts are live now', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800))]);

class PartyPage extends StatelessWidget {
  const PartyPage({super.key});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Party Rooms', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.filter_list))]), body: GridView.builder(padding: const EdgeInsets.all(14), itemCount: 10, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .82), itemBuilder: (_, i) => GestureDetector(onTap: ()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>VoiceChatRoom(title:'Party Room '+(i+1).toString()))), child: Container(decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(.06))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors:[purple.withOpacity(.5),Colors.black]))), child: const Center(child: Icon(Icons.mic, size: 42, color: gold)))), Padding(padding: const EdgeInsets.all(11), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('VIP Party '+(i+1).toString(), style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 5), const Row(children: [Icon(Icons.people_alt_outlined,size:14,color:gold), SizedBox(width:4), Text('10 seats', style: TextStyle(fontSize:11,color:Colors.white54))])]))])))); }
}

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed:(){},icon:const Icon(Icons.edit_outlined))]), body: ListView(padding: const EdgeInsets.all(12), children: List.generate(6, (i)=>ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 5), leading: const CircleAvatar(backgroundColor: panel2, child: Icon(Icons.person,color:gold)), title: Text(['Sara','Omar','Mina','Lina','Khaled','Nour'][i],style:const TextStyle(fontWeight:FontWeight.w700)), subtitle: const Text('See you in the room tonight',style:TextStyle(color:Colors.white54)), trailing: const Text('12:30',style:TextStyle(fontSize:10,color:Colors.white38))))); }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext c) => Scaffold(body: ListView(children: [Container(height:250, decoration: const BoxDecoration(gradient: LinearGradient(colors:[Color(0xFF4A226B),Color(0xFF0A0710)],begin:Alignment.topCenter,end:Alignment.bottomCenter)), child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[Container(padding:const EdgeInsets.all(3),decoration:const BoxDecoration(shape:BoxShape.circle,gradient:LinearGradient(colors:[gold,purple])),child:const CircleAvatar(radius:42,backgroundColor:panel,child:Icon(Icons.person,size:45,color:Colors.white))),const SizedBox(height:10),const Text('Taj User',style:TextStyle(fontSize:21,fontWeight:FontWeight.w800)),const SizedBox(height:5),const Text('ID 100063 • Level 12',style:TextStyle(color:Colors.white54)),]),), Padding(padding:const EdgeInsets.all(14), child:Column(children:[Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[_stat('12','Following'),_stat('268','Followers'),_stat('9.8K','Likes'),_stat('4.2K','Coins')]),const SizedBox(height:22),_profileTile(Icons.diamond,'VIP Center'),_profileTile(Icons.card_giftcard,'My Gifts'),_profileTile(Icons.workspace_premium,'Rank & Achievements'),_profileTile(Icons.family_restroom,'Family'),_profileTile(Icons.settings_outlined,'Settings'),]))])); }
Widget _stat(String n,String t)=>Column(children:[Text(n,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:3),Text(t,style:const TextStyle(fontSize:11,color:Colors.white54))]);
Widget _profileTile(IconData i,String t)=>Container(margin:const EdgeInsets.only(bottom:8),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(16)),child:ListTile(leading:Icon(i,color:gold),title:Text(t),trailing:const Icon(Icons.chevron_right,color:Colors.white38)));

class VoiceChatRoom extends StatefulWidget {
  final String title;
  const VoiceChatRoom({super.key, required this.title});
  @override State<VoiceChatRoom> createState()=>_VoiceChatRoomState();
}
class _VoiceChatRoomState extends State<VoiceChatRoom> {
  bool muted=false; int selected=0; String notice='Welcome to the party • Be kind and have fun';
  final names=['Crown','Luna','Mido','Soso','Toto','Nour','Ali','Maya','Host','You'];
  @override Widget build(BuildContext c)=>Scaffold(backgroundColor:const Color(0xFF120A18), body:Stack(children:[Positioned.fill(child:Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFF3B1A53),Color(0xFF0B0710),Color(0xFF09070D)])))), SafeArea(child:Column(children:[_roomTop(),_announcement(),Expanded(child:GridView.builder(padding:const EdgeInsets.fromLTRB(20,20,20,10),itemCount:10,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,mainAxisSpacing:22,crossAxisSpacing:10,childAspectRatio:.72),itemBuilder:(_,i)=>_seat(i))),_chatBar(),_controls()]))]));
  Widget _roomTop()=>Padding(padding:const EdgeInsets.fromLTRB(12,6,12,10),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.keyboard_arrow_down)),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(widget.title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const Text('Room 100063  •  2.8K online',style:TextStyle(fontSize:10,color:Colors.white54))])),IconButton(onPressed:(){},icon:const Icon(Icons.share_outlined)),IconButton(onPressed:(){},icon:const Icon(Icons.more_horiz))]));
  Widget _announcement()=>Container(margin:const EdgeInsets.symmetric(horizontal:12),padding:const EdgeInsets.symmetric(horizontal:13,vertical:9),decoration:BoxDecoration(color:Colors.black.withOpacity(.28),borderRadius:BorderRadius.circular(22),border:Border.all(color:gold.withOpacity(.12))),child:Row(children:[const Icon(Icons.campaign_outlined,color:gold,size:17),const SizedBox(width:8),Expanded(child:Text(notice,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,color:Colors.white70)))]));
  Widget _seat(int i)=>GestureDetector(onTap:()=>setState(()=>selected=i),child:Column(children:[Container(padding:const EdgeInsets.all(2.5),decoration:BoxDecoration(shape:BoxShape.circle,gradient:LinearGradient(colors:i==0?[gold,gold2]:[purple,const Color(0xFF3A1C4B)]),boxShadow:i==selected?[BoxShadow(color:gold.withOpacity(.35),blurRadius:14)]:null),child:CircleAvatar(radius:28,backgroundColor:const Color(0xFF211328),child:Icon(i==0?Icons.workspace_premium:Icons.person,color:i==0?gold:Colors.white,size:27))),const SizedBox(height:6),Text(i==0?'Host':names[i],style:TextStyle(fontSize:10,fontWeight:i==0?FontWeight.bold:FontWeight.w500,color:i==0?gold:Colors.white70),overflow:TextOverflow.ellipsis),if(i==0) const Text('VIP 8',style:TextStyle(fontSize:8,color:gold2))]));
  Widget _chatBar()=>Padding(padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),child:Container(height:40,padding:const EdgeInsets.symmetric(horizontal:13),decoration:BoxDecoration(color:Colors.black.withOpacity(.25),borderRadius:BorderRadius.circular(22)),child:Row(children:[const Icon(Icons.emoji_emotions_outlined,size:19,color:gold),const SizedBox(width:10),const Expanded(child:Text('Say something...',style:TextStyle(color:Colors.white38,fontSize:12))),IconButton(onPressed:()=>_gifts(),icon:const Icon(Icons.card_giftcard,color:gold,size:20))])));
  Widget _controls()=>Container(padding:const EdgeInsets.fromLTRB(12,8,12,14),decoration:BoxDecoration(color:Colors.black.withOpacity(.48),border:const Border(top:BorderSide(color:Colors.white10))),child:Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[_control(Icons.mic,muted?'Unmute':'Mute',()=>setState(()=>muted=!muted)),_control(Icons.videogame_asset,'Games',()=>_sheet('Games',Icons.videogame_asset)),_control(Icons.card_giftcard,'Gift',_gifts),_control(Icons.people_alt_outlined,'Members',()=>_sheet('Members',Icons.people_alt_outlined)),_control(Icons.settings_outlined,'Room',()=>_sheet('Room settings',Icons.settings_outlined))]));
  Widget _control(IconData i,String t,VoidCallback f)=>GestureDetector(onTap:f,child:Column(children:[Container(width:45,height:45,decoration:BoxDecoration(color:Colors.white.withOpacity(.06),shape:BoxShape.circle),child:Icon(i,color:t=='Mute'&&muted?Colors.red:gold)),const SizedBox(height:4),Text(t,style:const TextStyle(fontSize:9,color:Colors.white60))]));
  void _gifts()=>showModalBottomSheet(context:context,backgroundColor:const Color(0xFF17111F),shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(26))),builder:(_)=>Padding(padding:const EdgeInsets.all(18),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Send a Gift',style:TextStyle(fontSize:19,fontWeight:FontWeight.w800)),const SizedBox(height:15),GridView.count(shrinkWrap:true,crossAxisCount:4,children:['🌹','💎','👑','🚀','🎁','💰','❤️','✨'].map((g)=>GestureDetector(onTap:(){Navigator.pop(context);setState(()=>notice='🎁 You sent '+g+' to Host • Thank you!');},child:Column(children:[Text(g,style:const TextStyle(fontSize:30)),const SizedBox(height:3),const Text('100',style:TextStyle(fontSize:9,color:gold))]))).toList())])));
  void _sheet(String title,IconData icon)=>showModalBottomSheet(context:context,backgroundColor:panel,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(26))),builder:(_)=>SizedBox(height:260,child:Column(children:[const SizedBox(height:14),Icon(icon,color:gold,size:28),const SizedBox(height:8),Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:12),const ListTile(leading:Icon(Icons.star,color:gold),title:Text('VIP privileges')),const ListTile(leading:Icon(Icons.shield_outlined,color:gold),title:Text('Room moderation'))]));
}
