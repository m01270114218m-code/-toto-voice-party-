import 'package:flutter/material.dart';

const Color kBlack = Color(0xFF07050A);
const Color kPurple = Color(0xFF6F35B8);
const Color kGold = Color(0xFFD7A84B);
const Color kGoldLight = Color(0xFFFFE2A0);
const Color kSurface = Color(0xFF120C1B);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TajLiveApp());
}

class TajLiveApp extends StatelessWidget {
  const TajLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تاج لايف',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBlack,
        colorScheme: ColorScheme.fromSeed(seedColor: kPurple, brightness: Brightness.dark),
        fontFamily: 'sans',
        useMaterial3: true,
      ),
      home: const TajHome(),
    );
  }
}

class TajHome extends StatefulWidget {
  const TajHome({super.key});
  @override
  State<TajHome> createState() => _TajHomeState();
}

class _TajHomeState extends State<TajHome> {
  int index = 0;
  final pages = const [_HomePage(), _MomentsPage(), _MessagesPage(), _CreatePage(), _ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(child: pages[index]),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF0D0912),
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'اللحظات'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'الرسائل'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline, size: 30), selectedIcon: Icon(Icons.add_circle, size: 30), label: ''),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'أنا'),
          ],
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 24, backgroundColor: kPurple, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تاج لايف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text('غرف صوتية اجتماعية', style: TextStyle(color: Colors.white60)),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Color(0xFF27123C), Color(0xFF0D0813)]),
            border: Border.all(color: kGold.withOpacity(.35)),
          ),
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('مرحباً بك في تاج لايف', style: TextStyle(color: kGoldLight, fontSize: 23, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('اكتشف الغرف وتحدث مع أصدقاء جدد'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('الغرف الصوتية', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (int i = 1; i <= 6; i++) _RoomCard(number: i),
      ],
    );
  }
}

class _RoomCard extends StatelessWidget {
  final int number;
  const _RoomCard({required this.number});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kSurface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: kGold.withOpacity(.16)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [kPurple, Color(0xFF24102F)]),
            border: Border.all(color: kGold.withOpacity(.5)),
          ),
          child: const Icon(Icons.mic, color: kGoldLight),
        ),
        title: Text('غرفة تاج رقم ' + number.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('غرفة صوتية • 8 مقاعد'),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _RoomPage())),
      ),
    );
  }
}

class _RoomPage extends StatelessWidget {
  const _RoomPage();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('غرفة تاج'), backgroundColor: Colors.transparent),
        body: Column(
          children: [
            const SizedBox(height: 8),
            const Text('تاج لايف', style: TextStyle(color: kGoldLight, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('مرحباً بكم في الغرفة'),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(18),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 18),
                itemCount: 8,
                itemBuilder: (_, i) => Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSurface,
                        border: Border.all(color: kGold.withOpacity(.5)),
                      ),
                      child: Icon(i == 0 ? Icons.workspace_premium : Icons.person_outline, color: kGoldLight),
                    ),
                    const SizedBox(height: 6),
                    Text('مقعد ' + (i + 1).toString(), style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFF0D0912)),
              child: Row(
                children: [
                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'اكتب رسالة...', filled: true, fillColor: kSurface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.card_giftcard, color: kGold)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: kGold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MomentsPage extends StatelessWidget {
  const _MomentsPage();
  @override
  Widget build(BuildContext context) => const Center(child: Text('اللحظات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
}

class _MessagesPage extends StatelessWidget {
  const _MessagesPage();
  @override
  Widget build(BuildContext context) => const Center(child: Text('الرسائل', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
}

class _CreatePage extends StatelessWidget {
  const _CreatePage();
  @override
  Widget build(BuildContext context) => const Center(child: Text('إنشاء', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 18),
        const CircleAvatar(radius: 48, backgroundColor: kPurple, child: Icon(Icons.person, size: 48)),
        const SizedBox(height: 12),
        const Center(child: Text('حسابي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(height: 24),
        const _ProfileTile(icon: Icons.account_balance_wallet_outlined, title: 'المحفظة'),
        const _ProfileTile(icon: Icons.workspace_premium_outlined, title: 'VIP والمستوى'),
        const _ProfileTile(icon: Icons.card_giftcard_outlined, title: 'الهدايا'),
        const _ProfileTile(icon: Icons.settings_outlined, title: 'الإعدادات'),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ProfileTile({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kSurface,
      child: ListTile(
        leading: Icon(icon, color: kGold),
        title: Text(title),
        trailing: const Icon(Icons.chevron_left),
        onTap: () {},
      ),
    );
  }
}
