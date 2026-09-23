import 'package:flutter/material.dart';

const bg=Color(0xFF08050D),surface=Color(0xFF14101C),surface2=Color(0xFF21152C),royal=Color(0xFF6F2DBD),royal2=Color(0xFFB45CFF),gold=Color(0xFFFFC857);

void main()=>runApp(const RoyalVoiceApp());

class RoyalVoiceApp extends StatelessWidget{
 const RoyalVoiceApp({super.key});
 @override Widget build(BuildContext c)=>MaterialApp(debugShowCheckedModeBanner:false,title:'صوت يجمعنا',theme:ThemeData(brightness:Brightness.dark,scaffoldBackgroundColor:bg,colorScheme:ColorScheme.fromSeed(seedColor:royal,brightness:Brightness.dark),useMaterial3:true),home:const Shell());
}

class Shell extends StatefulWidget{const Shell({super.key});@override State<Shell> createState()=>_ShellState();}
class _ShellState extends State<Shell>{
 int tab=0;
 final pages=const[Home(),Messages(),Wallet(),Profile()];
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(body:IndexedStack(index:tab,children:pages),bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),backgroundColor:surface2,indicatorColor:royal.withOpacity(.35),destinations:const[
 NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home,color:gold),label:'الرئيسية'),
 NavigationDestination(icon:Icon(Icons.chat_outlined),selectedIcon:Icon(Icons.chat,color:gold),label:'الرسائل'),
 NavigationDestination(icon:Icon(Icons.account_balance_wallet_outlined),selectedIcon:Icon(Icons.account_balance_wallet,color:gold),label:'المحفظة'),
 NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person,color:gold),label:'حسابي'),
 ])));
 }
}

class Home extends StatelessWidget{
 const Home({super.key});
 static const rooms=['مجلس العرب','ليالي القمر','سهرة الأصدقاء','جلسة طرب','VIP Lounge','أهل السهرة'];
 @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
 const Row(children:[CircleAvatar(radius:25,backgroundColor:royal,child:Icon(Icons.person)),SizedBox(width:10),Expanded(child:Text('مرحباً بك\nأمير القلوب',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),Icon(Icons.notifications_none),SizedBox(width:8),Text('🪙 5,250')]),
 const SizedBox(height:18),
 Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(borderRadius:BorderRadius.circular(25),gradient:const LinearGradient(colors:[Color(0xFF3A1554),Color(0xFF171020)]),border:Border.fromBorderSide(BorderSide(color:gold,width:.3))),child:Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('الغرفة الملكية',style:TextStyle(color:Color(0xFFFFE4A3))),SizedBox(height:6),Text('ادخل وتحدث مع أصدقائك',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),SizedBox(height:6),Text('غرف صوتية • هدايا • مقاعد')]),),FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const Room(name:'مجلس العرب'))),style:FilledButton.styleFrom(backgroundColor:royal),child:const Text('دخول'))])),
 const SizedBox(height:16),
 SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:['الرائجة','أتابعها','حفلات','ألعاب','موسيقى','VIP','قبائل'].map((x)=>Padding(padding:const EdgeInsets.only(left:7),child:ChoiceChip(label:Text(x),selected:x=='الرائجة',onSelected:(_){},selectedColor:royal))).toList())),
 const SizedBox(height:12),const Text('الغرف المباشرة',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
 const SizedBox(height:10),
 ...rooms.map((r)=>Card(color:surface,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20),side:const BorderSide(color:Color(0x556F2DBD))),child:ListTile(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>Room(name:r))),leading:const CircleAvatar(backgroundColor:royal2,child:Icon(Icons.mic,color:Colors.white)),title:Text(r,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:const Text('🇪🇬 مصر • 742 مستمع'),trailing:const Text('مباشر',style:TextStyle(color:Colors.pinkAccent))))
 ]));
}

class Room extends StatefulWidget{final String name;const Room({super.key,required this.name});@override State<Room> createState()=>_RoomState();}
class _RoomState extends State<Room>{
 int seat=-1;bool mic=false;final chat=['مرحباً بكم 👋','أهلاً بكل الموجودين ❤️','يرجى احترام الجميع والتواصل بأدب.'];
 @override Widget build(BuildContext c)=>Scaffold(body:Container(decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF3B1454),bg],begin:Alignment.topCenter,end:Alignment.bottomCenter)),child:SafeArea(child:Column(children:[
  Row(children:[IconButton(onPressed:()=>Navigator.pop(c),icon:const Icon(Icons.arrow_forward)),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(widget.name,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const Text('1,248 مستمع',style:TextStyle(color:Colors.white54))])),const Icon(Icons.share_outlined),const SizedBox(width:12)]),
  Container(margin:const EdgeInsets.all(12),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.black26,borderRadius:BorderRadius.circular(16)),child:const Row(children:[Icon(Icons.workspace_premium,color:gold),SizedBox(width:8),Text('الغرفة الملكية'),Spacer(),Text('VIP 5',style:TextStyle(color:gold))])),
  Expanded(child:GridView.builder(itemCount:10,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,childAspectRatio:.75),itemBuilder:(_,i)=>GestureDetector(onTap:()=>setState(()=>seat=i),child:Column(children:[CircleAvatar(radius:29,backgroundColor:i==seat?gold:surface2,child:Icon(i==0?Icons.person:Icons.event_seat,color:i==seat?bg:royal2)),const SizedBox(height:4),Text(i==0?'المالك':'مقعد '+(i+1).toString(),style:const TextStyle(fontSize:10))])))),
  Container(height:210,margin:const EdgeInsets.all(12),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.black38,borderRadius:BorderRadius.circular(22)),child:Column(children:[const Align(alignment:Alignment.centerRight,child:Text('الدردشة',style:TextStyle(color:gold,fontWeight:FontWeight.bold))),Expanded(child:ListView(children:chat.map((x)=>Padding(padding:const EdgeInsets.all(4),child:Text(x))).toList())),TextField(onSubmitted:(v){if(v.trim().isNotEmpty)setState(()=>chat.add(v.trim()));},decoration:const InputDecoration(hintText:'اكتب رسالة...',filled:true,fillColor:surface))])),
  Padding(padding:const EdgeInsets.fromLTRB(12,0,12,12),child:Row(children:[IconButton(onPressed:()=>showGifts(c),icon:const Icon(Icons.card_giftcard,color:gold)),IconButton(onPressed:()=>setState(()=>mic=!mic),icon:Icon(mic?Icons.mic:Icons.mic_off,color:Colors.white)),Expanded(child:FilledButton(onPressed:()=>setState(()=>seat=seat<0?0:-1),style:FilledButton.styleFrom(backgroundColor:royal),child:Text(seat<0?'طلب مقعد':'مغادرة المقعد')))]))
 ])));
}

void showGifts(BuildContext c)=>showModalBottomSheet(context:c,backgroundColor:surface,builder:(_)=>const GiftSheet());
class GiftSheet extends StatelessWidget{const GiftSheet({super.key});@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.all(18),child:GridView.count(shrinkWrap:true,crossAxisCount:3,children:const[('🌹','وردة','10'),('❤️','قلب','20'),('🚗','سيارة','100'),('✈️','طائرة','200'),('🏰','قصر','1000'),('🐉','تنين','5000')].map((g)=>Card(color:surface2,child:InkWell(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(g.$1,style:const TextStyle(fontSize:30)),Text(g.$2),Text(g.$3+' 🪙',style:const TextStyle(color:gold))]),onTap:()=>Navigator.pop(c)))).toList()));}

class Messages extends StatelessWidget{const Messages({super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('الرسائل')),body:ListView(children:const[('سارة','أهلاً، كيف حالك؟'),('محمد','أراك في الغرفة الليلة'),('فاطمة','أرسلت لك هدية 🎁'),('نور','موعدنا في الفعالية')].map((x)=>ListTile(leading:CircleAvatar(backgroundColor:royal,child:Icon(Icons.person)),title:Text(x.$1),subtitle:Text(x.$2),trailing:Text('09:45'))).toList()));}
class Wallet extends StatelessWidget{const Wallet({super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('المحفظة')),body:ListView(padding:const EdgeInsets.all(18),children:[Container(padding:const EdgeInsets.all(25),decoration:BoxDecoration(borderRadius:BorderRadius.circular(25),gradient:const LinearGradient(colors:[Color(0xFF5C2097),Color(0xFF24102F)])),child:const Column(children:[Text('رصيد العملات'),SizedBox(height:8),Text('5,250 🪙',style:TextStyle(fontSize:35,fontWeight:FontWeight.w900,color:gold))])),const SizedBox(height:18),...['100 🪙','550 🪙','1,250 🪙','2,750 🪙','6,000 🪙'].map((x)=>Card(color:surface,child:ListTile(title:Text(x),subtitle:const Text('باقة شحن'),trailing:FilledButton(onPressed:(){},child:const Text('شراء'))))) ]));}
class Profile extends StatelessWidget{const Profile({super.key});@override Widget build(BuildContext c)=>Scaffold(body:SafeArea(child:ListView(children:[Container(height:285,decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF4A1A69),bg],begin:Alignment.topCenter,end:Alignment.bottomCenter)),child:const Column(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(radius:58,backgroundColor:royal2,child:Icon(Icons.person,size:60)),SizedBox(height:12),Text('أمير القلوب',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),Text('ID: 1501637 • 🇪🇬 مصر',style:TextStyle(color:Colors.white60)),SizedBox(height:8),Text('VIP 5 • المستوى 32',style:TextStyle(color:gold,fontWeight:FontWeight.bold))])),const ListTile(leading:Icon(Icons.emoji_events,color:gold),title:Text('الإنجازات')),const ListTile(leading:Icon(Icons.card_giftcard,color:royal2),title:Text('الهدايا والشارات')),const ListTile(leading:Icon(Icons.workspace_premium,color:gold),title:Text('VIP والمستوى')),const ListTile(leading:Icon(Icons.shield_outlined),title:Text('الحساب والأمان')),const ListTile(leading:Icon(Icons.settings),title:Text('الإعدادات'))])));}
