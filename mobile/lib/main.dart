
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
    final logged=p.getBool('logged')??false;
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
  final rooms=['مجلس TOYO','سهرة القمر','عشاق الطرب','VIP Lounge','أصدقاء مصر','ليلة الألعاب'];
  @override Widget build(BuildContext c){
    final pages=[homeBody(c),const Moments(),const Messages(),const Profile()];
    return Scaffold(body:pages[tab],bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
      NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'الرئيسية'),
      NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat),label:'اللحظات'),
      NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat),label:'الرسائل'),
      NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'أنا'),
    ]));
  }
  Widget homeBody(BuildContext c)=>SafeArea(child:CustomScrollView(slivers:[
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(16),child:Row(children:[
      const CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=12')),
      const SizedBox(width:10),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('مرحباً 👋'),Text('أمير القلوب',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))])),
      _pill('5,250',Icons.monetization_on,color:gold),IconButton(onPressed:(){},icon:const Icon(Icons.notifications_none))
    ]))),
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:FilledButton.icon(onPressed:(){Navigator.push(c,MaterialPageRoute(builder:(_)=>const CreateRoom()));},icon:const Icon(Icons.add),label:const Text('إنشاء غرفة صوتية')))),
    SliverToBoxAdapter(child:SingleChildScrollView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.all(16),child:Row(children:['الرائجة','أتابعها','حفلات','ألعاب','موسيقى','VIP','قبائل','وكالات'].map((x)=>Padding(padding:const EdgeInsets.only(left:8),child:Chip(label:Text(x)))).toList()))),
    SliverToBoxAdapter(child:const Padding(padding:EdgeInsets.fromLTRB(16,4,16,10),child:Text('الغرف الصوتية المباشرة',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:gold)))),
    SliverList(delegate:SliverChildBuilderDelegate((_,i)=>roomCard(c,rooms[i],i),childCount:rooms.length)),
  ]));
  Widget roomCard(BuildContext c,String name,int i)=>Padding(padding:const EdgeInsets.fromLTRB(16,0,16,10),child:InkWell(
    onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>Room(name:name))),
    child:Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(borderRadius:BorderRadius.circular(20),gradient:const LinearGradient(colors:[Color(0xFF1A0B28),Color(0xFF08060B)],begin:Alignment.topRight,end:Alignment.bottomLeft),border:Border.all(color:purple.withOpacity(.35))),child:Row(children:[
      ClipRRect(borderRadius:BorderRadius.circular(14),child:Image.network('https://picsum.photos/seed/$i/100',width:75,height:75,fit:BoxFit.cover)),
      const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Expanded(child:Text(name,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w900,color:gold2))),Container(padding:const EdgeInsets.symmetric(horizontal:7,vertical:3),decoration:BoxDecoration(color:Colors.redAccent,borderRadius:BorderRadius.circular(7)),child:const Text('LIVE',style:TextStyle(fontSize:10)))]),
        const SizedBox(height:8),const Text('👑 VIP • 🇪🇬 مصر • 1.2K موجود',style:TextStyle(color:Colors.white60)),
        const SizedBox(height:8),Row(children:List.generate(4,(j)=>Padding(padding:const EdgeInsets.only(left:4),child:CircleAvatar(radius:12,backgroundImage:NetworkImage('https://i.pravatar.cc/60?img=${j+20}')))))
      ]))
    ]))));
}

Widget _pill(String t,IconData i,{Color color=Colors.white})=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),decoration:BoxDecoration(color:Colors.white10,borderRadius:BorderRadius.circular(20)),child:Row(children:[Icon(i,size:16,color:color),const SizedBox(width:4),Text(t)]));

class Room extends StatefulWidget { final String name; const Room({super.key,required this.name}); @override State<Room> createState()=>_RoomState(); }
class _RoomState extends State<Room>{
  final messages=<String>['مرحباً بكم في الغرفة 👋','يرجى احترام الآخرين والتواصل بأدب.','أحمد: أهلاً بالجميع ❤️'];
  bool mic=false; int seat=-1;
  @override Widget build(BuildContext c)=>Scaffold(
    body:Stack(children:[
      Positioned.fill(child:Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFF321052),Color(0xFF090414)])),child:CustomPaint(painter:StarPainter()))),
      SafeArea(child:Column(children:[
        Padding(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),child:Row(children:[IconButton(onPressed:()=>Navigator.pop(c),icon:const Icon(Icons.arrow_back)),Expanded(child:Text(widget.name,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold))),const Icon(Icons.share),const SizedBox(width:8),const CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/70?img=12'))])),
        const SizedBox(height:10),
        Expanded(child:GridView.count(crossAxisCount:5,childAspectRatio:.75,padding:const EdgeInsets.all(12),children:List.generate(10,(i)=>seatWidget(i)))),
        Container(margin:const EdgeInsets.all(12),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.black45,borderRadius:BorderRadius.circular(20)),height:220,child:Column(children:[
          const Row(children:[Text('الكل',style:TextStyle(fontWeight:FontWeight.bold,color:Colors.purpleAccent)),SizedBox(width:20),Text('دردشة'),SizedBox(width:20),Text('هدايا')]),
          const SizedBox(height:8),Expanded(child:ListView(children:messages.map((m)=>Padding(padding:const EdgeInsets.symmetric(vertical:5),child:Text(m))).toList())),
          Row(children:[Expanded(child:TextField(onSubmitted:(v){if(v.trim().isNotEmpty)setState(()=>messages.add(v));},decoration:const InputDecoration(hintText:'اكتب رسالة...',isDense:true))),IconButton(onPressed:(){},icon:const Icon(Icons.card_giftcard,color:gold))])
        ])),
        Padding(padding:const EdgeInsets.fromLTRB(12,0,12,12),child:Row(children:[
          _round(Icons.card_giftcard,gold,(){showModalBottomSheet(context:c,backgroundColor:const Color(0xFF160A28),builder:(_)=>GiftSheet());}),
          _round(mic?Icons.mic:Icons.mic_off,Colors.white,()=>setState(()=>mic=!mic)),
          _round(Icons.add_reaction,Colors.pink,(){}),
          Expanded(child:FilledButton(onPressed:()=>setState(()=>seat=seat<0?0:-1),child:Text(seat<0?'طلب مقعد':'مغادرة المقعد'))),
        ]))
      ]))
    ]));
  Widget seatWidget(int i)=>GestureDetector(onTap:()=>setState(()=>seat=i),child:Column(children:[
    Container(width:55,height:55,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:i==seat?gold:Colors.white24,width:2),gradient:const LinearGradient(colors:[purple,Color(0xFF26103E)])),child:i==0?const Icon(Icons.person):const Icon(Icons.event_seat,color:Colors.white54)),
    const SizedBox(height:5),Text(i==0?'المالك':'${i+1}',style:const TextStyle(fontSize:11))
  ]));
  Widget _round(IconData icon,Color col,VoidCallback f)=>Padding(padding:const EdgeInsets.only(left:6),child:CircleAvatar(backgroundColor:Colors.white10,child:IconButton(onPressed:f,icon:Icon(icon,color:col))));
}

class GiftSheet extends StatelessWidget{ GiftSheet({super.key}); final gifts=const [('وردة',10,'🌹'),('قلب',20,'❤️'),('سيارة',100,'🚗'),('طائرة',200,'✈️'),('قصر',1000,'🏰'),('تنين',5000,'🐉')]; @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.all(18),child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('الهدايا المتحركة',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:gold)),const SizedBox(height:15),GridView.count(shrinkWrap:true,crossAxisCount:3,children:gifts.map((g)=>Card(child:InkWell(onTap:()=>Navigator.pop(c),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(g.$3,style:const TextStyle(fontSize:35)),Text(g.$1),Text('${g.$2} 🪙',style:const TextStyle(color:gold))])))).toList())])); }

class CreateRoom extends StatelessWidget{ const CreateRoom({super.key}); @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('إنشاء غرفة')),body:ListView(padding:const EdgeInsets.all(18),children:[
  TextField(decoration:InputDecoration(labelText:'اسم الغرفة',border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
  const SizedBox(height:12),TextField(maxLines:3,decoration:InputDecoration(labelText:'وصف مختصر',border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
  const SizedBox(height:12),DropdownButtonFormField(items:['موسيقى','دردشة عامة','ألعاب','VIP','حفلات'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(_){},decoration:const InputDecoration(labelText:'فئة الغرفة')),
  SwitchListTile(value:true,onChanged:(_){},title:const Text('غرفة عامة')),SwitchListTile(value:true,onChanged:(_){},title:const Text('السماح بالهدايا')),SwitchListTile(value:true,onChanged:(_){},title:const Text('السماح بطلبات المقاعد')),
  TextField(decoration:InputDecoration(labelText:'رسالة الترحيب',border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
  const SizedBox(height:20),SizedBox(height:52,child:FilledButton(onPressed:()=>Navigator.pop(c),child:const Text('إنشاء الغرفة')))
]));}

class Moments extends StatelessWidget {
  const Moments({super.key});
  @override Widget build(BuildContext context)=>Directionality(
    textDirection:TextDirection.rtl,
    child:Scaffold(
      appBar:AppBar(title:const Text('اللحظات')),
      body:ListView(
        padding:const EdgeInsets.all(14),
        children:[
          _moment('أمير القلوب','ليلة جميلة في TOYO ✨','https://picsum.photos/seed/toyo1/900/520'),
          _moment('سارة','من داخل غرفة النخبة 💜','https://picsum.photos/seed/toyo2/900/520'),
          _moment('محمد','أجمل أصدقاء TOYO ❤️','https://picsum.photos/seed/toyo3/900/520'),
        ],
      ),
    ),
  );
  Widget _moment(String name,String text,String image)=>Card(
    clipBehavior:Clip.antiAlias,
    child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      ListTile(leading:const CircleAvatar(child:Icon(Icons.person)),title:Text(name),subtitle:const Text('منذ قليل')),
      Image.network(image,height:190,fit:BoxFit.cover),
      Padding(padding:const EdgeInsets.all(12),child:Text(text,style:const TextStyle(fontSize:16,fontWeight:FontWeight.bold))),
      const ButtonBar(children:[Icon(Icons.favorite_border),Icon(Icons.chat_bubble_outline),Icon(Icons.share_outlined)])
    ]),
  );
}

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    const names = ['سارة','محمد','فاطمة','نور','أحمد','خالد','ليلى','جمال'];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الرسائل الخاصة')),
        body: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, i) => ListTile(
            leading: CircleAvatar(child: Text(names[i].substring(0, 1))),
            title: Text(names[i]),
            subtitle: const Text('أهلاً، كيف حالك؟'),
            trailing: const Text('09:45'),
          ),
        ),
      ),
    );
  }
}

class Wallet extends StatelessWidget{const Wallet({super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('المحفظة • Coins & Diamonds')),body:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
  Container(width:double.infinity,padding:const EdgeInsets.all(24),decoration:BoxDecoration(borderRadius:BorderRadius.circular(25),gradient:const LinearGradient(colors:[Color(0xFF7B2CFF),Color(0xFFCC3BFF)])),child:const Column(children:[Text('رصيد Coins',style:TextStyle(color:Colors.white70)),Text('5,250 🪙',style:TextStyle(fontSize:35,fontWeight:FontWeight.bold))])),
  const SizedBox(height:20),...['100 🪙','550 🪙','1,250 🪙','2,750 🪙','6,000 🪙'].map((x)=>Card(child:ListTile(title:Text(x),subtitle:const Text('باقة شحن'),trailing:FilledButton(onPressed:(){},child:const Text('شراء')))))
])));}

class Profile extends StatelessWidget{const Profile({super.key});@override Widget build(BuildContext c)=>Scaffold(body:SafeArea(child:ListView(children:[
  Container(height:280,decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF4A1A7B),Color(0xFF0B0614)])),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const CircleAvatar(radius:55,backgroundImage:NetworkImage('https://i.pravatar.cc/160?img=12')),const SizedBox(height:12),const Text('أمير القلوب',style:TextStyle(fontSize:27,fontWeight:FontWeight.w900,color:gold2)),const Text('ID:1501637 • 🇪🇬 مصر'),const SizedBox(height:8),Text('VIP 5 • LEVEL 32 • ✨ عضو مميز',style:TextStyle(color:gold,fontWeight:FontWeight.w900))])),
  Card(margin:const EdgeInsets.symmetric(horizontal:12,vertical:8),child:ListTile(leading:const Icon(Icons.account_balance_wallet,color:gold),title:const Text('المحفظة'),subtitle:const Text('5,250 Coins • 120 Diamonds'),trailing:const Icon(Icons.chevron_left),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const Wallet())))),
  ListTile(leading:const Icon(Icons.emoji_events,color:gold),title:const Text('الإنجازات'),onTap:(){}),ListTile(leading:const Icon(Icons.card_giftcard),title:const Text('أطلس الهدايا')),ListTile(leading:const Icon(Icons.workspace_premium),title:const Text('الشارات')),ListTile(leading:const Icon(Icons.shield_outlined),title:const Text('الحساب والأمان')),ListTile(leading:const Icon(Icons.settings),title:const Text('الإعدادات')),ListTile(leading:const Icon(Icons.logout,color:Colors.red),title:const Text('تسجيل الخروج',style:TextStyle(color:Colors.red)),onTap:() async {final p=await SharedPreferences.getInstance();await p.setBool('logged',false);if(c.mounted)Navigator.pushAndRemoveUntil(c,MaterialPageRoute(builder:(_)=>const Login()),(_)=>false);}),
])));}

class StarPainter extends CustomPainter{ @override void paint(Canvas c,Size s){final p=Paint()..color=Colors.white.withOpacity(.18);for(int i=0;i<70;i++){final x=(i*73)%s.width;final y=(i*131)%s.height;c.drawCircle(Offset(x.toDouble(),y.toDouble()),i%3==0?1.4:.7,p);}} @override bool shouldRepaint(c)=>false;}

class StateProvider{static dynamic of(BuildContext c)=>_Dummy();} class _Dummy{String displayName='أمير القلوب';int coins=5250;}
