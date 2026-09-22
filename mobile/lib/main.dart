
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/toyo_api.dart';
import 'core/toyo_voice_service.dart';

const purple = Color(0xFF8A2BE2);
const deep = Color(0xFF050307);
const gold = Color(0xFFFFC84A);
const gold2 = Color(0xFFFFE08A);
const panel = Color(0xFF0D0A12);

void main() => runApp(const VoiceRoom());

class VoiceRoom extends StatelessWidget {
  const VoiceRoom({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TOYO Voice Party',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deep,
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark),
      fontFamily: 'Arial',
      useMaterial3: true,
    ),
    home: const Splash(),
  );
}

class Splash extends StatefulWidget { const Splash({super.key}); @override State<Splash> createState()=>_SplashState(); }
class _SplashState extends State<Splash> {
  @override void initState(){super.initState(); Future.delayed(const Duration(seconds:2),() async {
    final p=await SharedPreferences.getInstance();
    final logged=(p.getBool('logged')??false)&&await ToyoApi.token()!=null;
    if(!mounted)return;
    Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>logged?const Home():const Login()));
  });}
  @override Widget build(BuildContext c)=>Scaffold(body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    Container(width:110,height:110,decoration:BoxDecoration(shape:BoxShape.circle,gradient:const LinearGradient(colors:[purple,Color(0xFFFF42D0)]),boxShadow:[BoxShadow(color:purple.withOpacity(.45),blurRadius:40)]),child:const Icon(Icons.mic,size:55)),
    const SizedBox(height:20),const Text('TOYO',style:TextStyle(fontSize:42,fontWeight:FontWeight.w900,color:gold)),
    const Text('Voice Party',style:TextStyle(fontSize:15,color:Colors.white70,letterSpacing:2)),
    const SizedBox(height:8),
    const Text('صوتك .. عالمك الخاص',style:TextStyle(color:Colors.white60)),
    const SizedBox(height:35),const CircularProgressIndicator(color:gold),
  ])));
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override State<Login> createState()=>_LoginState();
}
class _LoginState extends State<Login>{
  final _email=TextEditingController();
  final _password=TextEditingController();
  @override void dispose(){_email.dispose();_password.dispose();super.dispose();}
  Future<void> go(BuildContext context) async {
    final email = _email.text.trim();
    final password = _password.text;
    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('أدخل البريد وكلمة المرور')));
      return;
    }
    try{
      await ToyoApi.login(email,password);
      if (!context.mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
    }catch(e){
      if(!context.mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر تسجيل الدخول: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const SizedBox(height: 30),
              const Text('مرحباً بك في TOYO', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: gold)),
              const SizedBox(height: 8),
              const Text('صوت • أصدقاء • هدايا • VIP', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 35),
              TextField(controller:_email,keyboardType:TextInputType.emailAddress,decoration: const InputDecoration(labelText: 'البريد الإلكتروني', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller:_password,obscureText: true,decoration: const InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, height: 54, child: FilledButton(onPressed: () => go(context), child: const Text('تسجيل الدخول'))),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata), label: const Text('الدخول بواسطة Google')),
              TextButton(onPressed: () {}, child: const Text('الدخول برقم الهاتف و OTP')),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget { const Home({super.key}); @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home>{
  int tab=0;
  bool loading=true;
  String? error;
  List<Map<String,dynamic>> rooms=[];
  @override void initState(){super.initState();_loadRooms();}
  Future<void> _loadRooms() async {
    setState(()=>loading=true);
    try{final data=await ToyoApi.rooms();if(mounted)setState((){rooms=data;loading=false;error=null;});}
    catch(e){if(mounted)setState((){loading=false;error='تعذر الاتصال بالخادم';});}
  }
  @override Widget build(BuildContext c){
    final pages=[homeBody(c),const Moments(),const Messages(),const Profile()];
    return Directionality(textDirection:TextDirection.rtl,child:Scaffold(
      body:pages[tab],
      floatingActionButton:FloatingActionButton(
        backgroundColor:gold,foregroundColor:deep,
        onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const CreateRoom())).then((_){_loadRooms();}),
        child:const Icon(Icons.add),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'الرئيسية'),
        NavigationDestination(icon:Icon(Icons.auto_awesome_mosaic_outlined),selectedIcon:Icon(Icons.auto_awesome_mosaic),label:'اللحظات'),
        NavigationDestination(icon:Icon(Icons.mail_outline),selectedIcon:Icon(Icons.mail),label:'الرسائل'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'أنا'),
      ]),
    ));
  }
  Widget homeBody(BuildContext c)=>SafeArea(child:RefreshIndicator(onRefresh:_loadRooms,child:CustomScrollView(slivers:[
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(18,18,18,8),child:Row(children:[
      Container(width:50,height:50,decoration:BoxDecoration(shape:BoxShape.circle,gradient:const LinearGradient(colors:[purple,gold]),border:Border.all(color:gold,width:1.5)),child:const Icon(Icons.person,color:Colors.white)),
      const SizedBox(width:12),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('مرحباً بك',style:TextStyle(color:Colors.white60,fontSize:12)),Text('TOYO',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:gold2))])),
      _pill('Coins',Icons.monetization_on,color:gold),const SizedBox(width:6),IconButton(onPressed:(){},icon:const Icon(Icons.notifications_none,color:gold2))
    ]))),
    SliverToBoxAdapter(child:Container(margin:const EdgeInsets.all(16),padding:const EdgeInsets.all(18),decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),gradient:const LinearGradient(colors:[Color(0xFF3B1761),Color(0xFF12071B)]),border:Border.all(color:gold.withOpacity(.35))),child:Row(children:[
      const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('مجتمع TOYO',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900,color:gold2)),SizedBox(height:5),Text('غرف صوتية مباشرة • هدايا • VIP',style:TextStyle(color:Colors.white70))])),
      Container(width:64,height:64,decoration:BoxDecoration(shape:BoxShape.circle,color:Colors.black38,border:Border.all(color:gold,width:2)),child:const Icon(Icons.mic,color:gold,size:32))
    ]))),
    SliverToBoxAdapter(child:SingleChildScrollView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:16,vertical:4),child:Row(children:['الرائجة','أتابعها','حفلات','ألعاب','موسيقى','VIP','قبائل','وكالات'].map((x)=>Padding(padding:const EdgeInsets.only(left:8),child:Chip(label:Text(x)))).toList()))),
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(18,18,18,12),child:Row(children:[const Expanded(child:Text('الغرف المباشرة',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:gold))),Text('${rooms.length} غرفة',style:const TextStyle(color:Colors.white54))]))),
    if(loading) const SliverFillRemaining(hasScrollBody:false,child:Center(child:CircularProgressIndicator(color:gold)))
    else if(error!=null) SliverFillRemaining(hasScrollBody:false,child:Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text(error!,style:const TextStyle(color:Colors.white70)),const SizedBox(height:12),FilledButton(onPressed:_loadRooms,child:const Text('إعادة المحاولة'))])))
    else if(rooms.isEmpty) const SliverFillRemaining(hasScrollBody:false,child:Center(child:Text('لا توجد غرف مباشرة حالياً',style:TextStyle(color:Colors.white60))))
    else SliverList(delegate:SliverChildBuilderDelegate((_,i)=>roomCard(c,rooms[i]),childCount:rooms.length)),
    const SliverToBoxAdapter(child:SizedBox(height:80))
  ])));
  Widget roomCard(BuildContext c,Map<String,dynamic> room){
    final id=room['id']?.toString();
    final name=room['name']?.toString()??'غرفة TOYO';
    final owner=room['owner_name']?.toString()??'مضيف TOYO';
    final viewers=room['viewer_count']?.toString()??'0';
    return Padding(padding:const EdgeInsets.fromLTRB(16,0,16,12),child:InkWell(
      borderRadius:BorderRadius.circular(22),
      onTap:id==null?null:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>Room(name:name,roomId:id))),
      child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(colors:[Color(0xFF241039),Color(0xFF0A0710)],begin:Alignment.topRight,end:Alignment.bottomLeft),border:Border.all(color:gold.withOpacity(.22))),child:Row(children:[
        Container(width:76,height:76,decoration:BoxDecoration(borderRadius:BorderRadius.circular(18),gradient:const LinearGradient(colors:[purple,Color(0xFF180D25)]),border:Border.all(color:gold.withOpacity(.5))),child:const Icon(Icons.mic,color:gold,size:34)),
        const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[Expanded(child:Text(name,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w900,color:gold2))),Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration:BoxDecoration(color:Colors.redAccent.withOpacity(.16),borderRadius:BorderRadius.circular(8),border:Border.all(color:Colors.redAccent.withOpacity(.5))),child:const Text('LIVE',style:TextStyle(fontSize:10,color:Colors.redAccent,fontWeight:FontWeight.bold)))]),
          const SizedBox(height:7),Text('$owner • $viewers مستمع',style:const TextStyle(color:Colors.white60)),
          const SizedBox(height:8),Row(children:[const Icon(Icons.card_giftcard,size:15,color:gold),const SizedBox(width:5),Text('هدايا • VIP • دردشة',style:const TextStyle(fontSize:12,color:Colors.white54))])
        ]))
      ]))
    ));
  }
}

Widget _pill(String t,IconData i,{Color color=Colors.white})=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),decoration:BoxDecoration(color:Colors.white10,borderRadius:BorderRadius.circular(20)),child:Row(children:[Icon(i,size:16,color:color),const SizedBox(width:4),Text(t)]));

class Room extends StatefulWidget { final String name; final String? roomId; const Room({super.key,required this.name,this.roomId}); @override State<Room> createState()=>_RoomState(); }
class _RoomState extends State<Room>{
  final messages=<String>['مرحباً بكم في الغرفة 👋','يرجى احترام الآخرين والتواصل بأدب.'];
  final voice=ToyoVoiceService();
  bool mic=false; int seat=-1; int selectedSeat=0; bool joining=true; String rtcStatus='جاري الاتصال بالغرفة...';
  @override void initState(){super.initState(); _connect();}
  Future<void> _connect() async {
    if(widget.roomId==null){setState(() { joining=false; rtcStatus='هذه غرفة عرض فقط'; });return;}
    try{
      await ToyoApi.joinRoom(widget.roomId!);
      final data=await ToyoApi.rtcToken(widget.roomId!);
      await voice.join(appId:data['appId'],token:data['token'],channelId:data['channelName'],account:data['uid'],publish:false);
      final state=await ToyoApi.roomState(widget.roomId!);
      final room=state['room'] is Map ? Map<String,dynamic>.from(state['room']) : <String,dynamic>{};
      final msgs=await ToyoApi.messages(widget.roomId!);
      if(mounted)setState((){maxSeats=[8,10,15].contains(int.tryParse('${room['max_seats']}')??8)?int.tryParse('${room['max_seats']}')!:8;ownerId=room['owner_id']?.toString();messages
        ..clear()
        ..addAll(msgs.map((m)=>'${m['display_name']??''}: ${m['text']??''}')); joining=false;rtcStatus='متصل صوتياً';});
    }catch(e){if(mounted)setState(() { joining=false; rtcStatus='الصوت غير مهيأ بعد — أضف مفاتيح Agora'; });}
  }
  @override void dispose(){voice.leave(); if(widget.roomId!=null) ToyoApi.leaveRoom(widget.roomId!); super.dispose();}
  Future<void> _toggleSeat() async {
    if(widget.roomId==null){setState(()=>seat=seat<0?selectedSeat:-1);return;}
    try{
      if(seat<0){
        await ToyoApi.requestSeat(widget.roomId!,selectedSeat+1);
        final data=await ToyoApi.rtcToken(widget.roomId!,publisher:true);
        await voice.leave();
        await voice.join(appId:data['appId'],token:data['token'],channelId:data['channelName'],account:data['uid'],publish:true);
        setState(() { seat=selectedSeat; mic=false; rtcStatus='أنت على المايك'; });
      }else{
        await ToyoApi.leaveSeat(widget.roomId!,seat+1);
        await voice.leave();
        final data=await ToyoApi.rtcToken(widget.roomId!);
        await voice.join(appId:data['appId'],token:data['token'],channelId:data['channelName'],account:data['uid'],publish:false);
        setState(() { seat=-1; mic=true; rtcStatus='متصل كمستمع'; });
      }
    }catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر تغيير المقعد: $e')));}
  }
  @override Widget build(BuildContext c)=>Scaffold(
    body:Stack(children:[
      Positioned.fill(child:Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFF321052),Color(0xFF090414)])),child:CustomPaint(painter:StarPainter()))),
      SafeArea(child:Column(children:[
        Padding(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(c),icon:const Icon(Icons.arrow_back)),Expanded(child:Text(widget.name,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold))),const Icon(Icons.share),const SizedBox(width:8),const CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/70?img=12'))])),
        const SizedBox(height:10),
        Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:Row(children:[const Icon(Icons.circle,size:9,color:Colors.greenAccent),const SizedBox(width:6),Expanded(child:Text(rtcStatus,style:const TextStyle(color:Colors.white70)))])),
        const SizedBox(height:10),
        Expanded(child:GridView.count(crossAxisCount:5,childAspectRatio:.75,padding:const EdgeInsets.all(12),children:List.generate(maxSeats,(i)=>seatWidget(i)))),
        Container(margin:const EdgeInsets.all(12),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.black45,borderRadius:BorderRadius.circular(20)),height:220,child:Column(children:[
          const Row(children:[Text('الكل',style:TextStyle(fontWeight:FontWeight.bold,color:Colors.purpleAccent)),SizedBox(width:20),Text('دردشة'),SizedBox(width:20),Text('هدايا')]),
          const SizedBox(height:8),Expanded(child:ListView(children:messages.map((m)=>Padding(padding:const EdgeInsets.symmetric(vertical:5),child:Text(m))).toList())),
          Row(children:[Expanded(child:TextField(onSubmitted:(v){if(v.trim().isNotEmpty)setState(()=>messages.add(v));},decoration:const InputDecoration(hintText:'اكتب رسالة...',isDense:true))),IconButton(onPressed:(){},icon:const Icon(Icons.card_giftcard,color:gold))])
        ])),
        Padding(padding:const EdgeInsets.fromLTRB(12,0,12,12),child:Row(children:[
          _round(Icons.card_giftcard,gold,(){showModalBottomSheet(context:c,isScrollControlled:true,backgroundColor:const Color(0xFF160A28),builder:(_)=>GiftSheet(roomId:widget.roomId,receiverId:ownerId));}),
          _round(mic?Icons.mic_off:Icons.mic,Colors.white,() async {final next=!mic; if(seat>=0){await voice.setMuted(next);setState(()=>mic=next);} }),
          _round(Icons.add_reaction,Colors.pink,(){}),
          Expanded(child:FilledButton(onPressed:_toggleSeat,child:Text(seat<0?'طلب مقعد':'مغادرة المقعد'))),
        ]))
      ]))
    ]));
  Widget seatWidget(int i)=>GestureDetector(onTap:()=>setState(()=>selectedSeat=i),child:Column(children:[
    Container(width:55,height:55,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:i==seat?gold:Colors.white24,width:2),gradient:const LinearGradient(colors:[purple,Color(0xFF26103E)])),child:i==0?const Icon(Icons.person):const Icon(Icons.event_seat,color:Colors.white54)),
    const SizedBox(height:5),Text(i==0?'المالك':'${i+1}',style:const TextStyle(fontSize:11))
  ]));
  Widget _round(IconData icon,Color col,VoidCallback f)=>Padding(padding:const EdgeInsets.only(left:6),child:CircleAvatar(backgroundColor:Colors.white10,child:IconButton(onPressed:f,icon:Icon(icon,color:col))));
}

class GiftSheet extends StatefulWidget{
  final String? roomId; final String? receiverId;
  const GiftSheet({super.key,this.roomId,this.receiverId});
  @override State<GiftSheet> createState()=>_GiftSheetState();
}
class _GiftSheetState extends State<GiftSheet>{
  bool loading=true; bool sending=false; List<Map<String,dynamic>> gifts=[];
  @override void initState(){super.initState();_load();}
  Future<void> _load() async { try { final data=await ToyoApi.gifts(); if(mounted)setState(()=>gifts=data); } catch (_) {} if(mounted)setState(()=>loading=false); }
  Future<void> _send(Map<String,dynamic> gift) async {
    if(widget.roomId==null){Navigator.pop(context);return;}
    setState(()=>sending=true);
    try { await ToyoApi.sendGift(roomId:widget.roomId!,giftId:gift['id'].toString(),receiverId:widget.receiverId); if(mounted){Navigator.pop(context);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم إرسال الهدية بنجاح 🎁')));} }
    catch(e){if(mounted){setState(()=>sending=false);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر إرسال الهدية: $e')));}}
  }
  @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Padding(padding:const EdgeInsets.fromLTRB(18,18,18,30),child:Column(mainAxisSize:MainAxisSize.min,children:[
    Row(children:[const Expanded(child:Text('إرسال هدية',style:TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:gold))),if(sending)const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:gold))]),
    const SizedBox(height:14),
    if(loading)const Padding(padding:EdgeInsets.all(30),child:CircularProgressIndicator(color:gold))
    else if(gifts.isEmpty)const Padding(padding:EdgeInsets.all(30),child:Text('لا توجد هدايا متاحة حالياً',style:TextStyle(color:Colors.white60)))
    else GridView.count(shrinkWrap:true,crossAxisCount:3,mainAxisSpacing:8,crossAxisSpacing:8,children:gifts.map((g)=>Card(color:const Color(0xFF24123A),child:InkWell(onTap:sending?null:()=>_send(g),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      const Text('🎁',style:TextStyle(fontSize:34)),
      Text(g['name']?.toString()??'هدية',maxLines:1,overflow:TextOverflow.ellipsis),
      Text('${g['price']??0} 🪙',style:const TextStyle(color:gold,fontWeight:FontWeight.bold)),
    ])))).toList())
  ])));
}

class CreateRoom extends StatefulWidget{ const CreateRoom({super.key}); @override State<CreateRoom> createState()=>_CreateRoomState(); }
class _CreateRoomState extends State<CreateRoom>{
  final name=TextEditingController(); final desc=TextEditingController(); String category='general'; int seats=8; bool saving=false;
  @override void dispose(){name.dispose();desc.dispose();super.dispose();}
  Future<void> save() async {
    if(name.text.trim().isEmpty)return;
    setState(()=>saving=true);
    try{
      final room=await ToyoApi.createRoom(name:name.text.trim(),description:desc.text.trim(),category:category,maxSeats:seats);
      if(!mounted)return;
      Navigator.pop(context,room);
    }catch(e){
      if(mounted){setState(()=>saving=false);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر إنشاء الغرفة: $e')));}
    }
  }
  @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
    appBar:AppBar(title:const Text('إنشاء غرفة صوتية')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),gradient:const LinearGradient(colors:[Color(0xFF35145A),Color(0xFF100718)]),border:Border.all(color:gold.withOpacity(.35))),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('غرفتك، قوانينك، جمهورك',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:gold2)),SizedBox(height:6),Text('أنشئ غرفة حقيقية وستظهر مباشرة للمستخدمين.',style:TextStyle(color:Colors.white60))])),
      const SizedBox(height:18),TextField(controller:name,decoration:const InputDecoration(labelText:'اسم الغرفة',border:OutlineInputBorder())),
      const SizedBox(height:12),TextField(controller:desc,maxLines:3,decoration:const InputDecoration(labelText:'الوصف',border:OutlineInputBorder())),
      const SizedBox(height:12),DropdownButtonFormField<String>(value:category,items:const[
        DropdownMenuItem(value:'general',child:Text('دردشة عامة')),DropdownMenuItem(value:'music',child:Text('موسيقى')),DropdownMenuItem(value:'games',child:Text('ألعاب')),DropdownMenuItem(value:'vip',child:Text('VIP')),DropdownMenuItem(value:'events',child:Text('حفلات'))
      ],onChanged:(v)=>setState(()=>category=v??'general'),decoration:const InputDecoration(labelText:'الفئة',border:OutlineInputBorder())),
      const SizedBox(height:12),DropdownButtonFormField<int>(value:seats,items:[8,10,15].map((x)=>DropdownMenuItem(value:x,child:Text('$x مايك'))).toList(),onChanged:(v)=>setState(()=>seats=v??8),decoration:const InputDecoration(labelText:'عدد المقاعد',border:OutlineInputBorder())),
      const SizedBox(height:24),SizedBox(height:54,child:FilledButton.icon(onPressed:saving?null:save,icon:saving?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.mic),label:Text(saving?'جاري الإنشاء...':'إنشاء الغرفة')))
    ])
  ));
}

class Moments extends StatelessWidget {
  const Moments({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اللحظات')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.auto_awesome, color: gold, size: 60),
                SizedBox(height: 16),
                Text('لا توجد لحظات منشورة بعد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: gold2)),
                SizedBox(height: 8),
                Text('سيظهر المحتوى الحقيقي هنا بعد نشره من المستخدمين.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  const Messages({super.key});
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('الرسائل الخاصة')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.mail_outline, color: gold, size: 60),
            SizedBox(height: 16),
            Text('لا توجد رسائل بعد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: gold2)),
            SizedBox(height: 8),
            Text('ستظهر محادثاتك الحقيقية هنا بعد بدء التواصل مع المستخدمين.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
          ]),
        ),
      ),
    ),
  );
}

class Wallet extends StatefulWidget {
  const Wallet({super.key});
  @override State<Wallet> createState()=>_WalletState();
}
class _WalletState extends State<Wallet> {
  bool loading=true;
  String? error;
  List<Map<String,dynamic>> balances=[];
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {
    try { final data=await ToyoApi.wallet(); if(mounted)setState((){balances=data;loading=false;error=null;}); }
    catch(e) { if(mounted)setState((){loading=false;error='تعذر تحميل المحفظة';}); }
  }
  @override Widget build(BuildContext c)=>Directionality(
    textDirection:TextDirection.rtl,
    child:Scaffold(
      appBar:AppBar(title:const Text('المحفظة • Coins & Diamonds')),
      body:loading
        ? const Center(child:CircularProgressIndicator(color:gold))
        : error!=null
          ? Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text(error!),const SizedBox(height:12),FilledButton(onPressed:_load,child:const Text('إعادة المحاولة'))]))
          : ListView(
              padding:const EdgeInsets.all(18),
              children:[
                ...balances.map((b)=>Card(child:ListTile(
                  leading:Icon(b['currency']=='coins'?Icons.monetization_on:Icons.diamond,color:gold),
                  title:Text(b['currency']=='coins'?'Coins':'Diamonds'),
                  trailing:Text('${b['balance']??0}',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:gold)),
                ))),
                if(balances.isEmpty) const Padding(padding:EdgeInsets.all(30),child:Center(child:Text('لا يوجد رصيد حالياً',style:TextStyle(color:Colors.white60)))),
              ],
            ),
    ),
  );
}

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override State<Profile> createState()=>_ProfileState();
}
class _ProfileState extends State<Profile> {
  bool loading=true;
  String? error;
  Map<String,dynamic>? me;
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {
    try { final data=await ToyoApi.me(); if(mounted)setState((){me=data;loading=false;error=null;}); }
    catch(e) { if(mounted)setState((){loading=false;error='تعذر تحميل الملف الشخصي';}); }
  }
  @override Widget build(BuildContext c) {
    if(loading) return const Scaffold(body:Center(child:CircularProgressIndicator(color:gold)));
    if(error!=null) return Scaffold(body:Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text(error!),const SizedBox(height:12),FilledButton(onPressed:_load,child:const Text('إعادة المحاولة'))])));
    final name=me?['display_name']?.toString()??'مستخدم TOYO';
    final id=me?['public_id']?.toString()??'—';
    final level=me?['level']?.toString()??'1';
    final vip=me?['vip_level']?.toString()??'0';
    final initial=name.isEmpty?'؟':name.substring(0,1);
    return Directionality(textDirection:TextDirection.rtl,child:Scaffold(body:SafeArea(child:ListView(children:[
      Container(height:280,decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF4A1A7B),Color(0xFF0B0614)])),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
        CircleAvatar(radius:55,child:Text(initial,style:const TextStyle(fontSize:34))),
        const SizedBox(height:12),
        Text(name,style:const TextStyle(fontSize:27,fontWeight:FontWeight.w900,color:gold2)),
        Text('ID:$id'),
        const SizedBox(height:8),
        Text('VIP $vip • LEVEL $level',style:const TextStyle(color:gold,fontWeight:FontWeight.w900)),
      ])),
      Card(margin:const EdgeInsets.symmetric(horizontal:12,vertical:8),child:ListTile(
        leading:const Icon(Icons.account_balance_wallet,color:gold),
        title:const Text('المحفظة'),
        subtitle:const Text('عرض الرصيد الحقيقي'),
        trailing:const Icon(Icons.chevron_left),
        onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const Wallet())),
      )),
      const ListTile(leading:Icon(Icons.emoji_events,color:gold),title:Text('الإنجازات')),
      const ListTile(leading:Icon(Icons.card_giftcard),title:Text('أطلس الهدايا')),
      const ListTile(leading:Icon(Icons.workspace_premium),title:Text('الشارات')),
      const ListTile(leading:Icon(Icons.shield_outlined),title:Text('الحساب والأمان')),
      const ListTile(leading:Icon(Icons.settings),title:Text('الإعدادات')),
      ListTile(leading:const Icon(Icons.logout,color:Colors.red),title:const Text('تسجيل الخروج',style:TextStyle(color:Colors.red)),onTap:() async {
        final p=await SharedPreferences.getInstance();
        await p.remove('token');
        await p.setBool('logged',false);
        if(c.mounted)Navigator.pushAndRemoveUntil(c,MaterialPageRoute(builder:(_)=>const Login()),(_)=>false);
      }),
    ]))));
  }
}

class StarPainter extends CustomPainter{ @override void paint(Canvas c,Size s){final p=Paint()..color=Colors.white.withOpacity(.18);for(int i=0;i<70;i++){final x=(i*73)%s.width;final y=(i*131)%s.height;c.drawCircle(Offset(x.toDouble(),y.toDouble()),i%3==0?1.4:.7,p);}} @override bool shouldRepaint(c)=>false;}
