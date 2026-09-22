import 'package:flutter/material.dart';
import 'backend.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const bg = Color(0xFF08050D);
const surface = Color(0xFF14101C);
const surface2 = Color(0xFF21152C);
const royal = Color(0xFF6F2DBD);
const royal2 = Color(0xFFB45CFF);
const gold = Color(0xFFFFC857);
const goldSoft = Color(0xFFFFE4A3);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TajBackend.initialize();
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
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: royal,
          brightness: Brightness.dark,
        ),
        fontFamily: 'sans',
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: TajBackend.authChanges,
      builder: (context, snapshot) {
        if (TajBackend.user != null) return const HomeShell();
        return const AuthPage();
      },
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  bool signup = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _activeSeatCount = widget.seatCount;
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل بريدًا صحيحًا وكلمة مرور من 6 أحرف على الأقل')),
      );
      return;
    }
    setState(() => loading = true);
    try {
      if (signup) {
        await TajBackend.signUpWithEmail(
          email: email.text.trim(),
          password: password.text,
          displayName: name.text.trim().isEmpty ? 'مستخدم تاج لايف' : name.text.trim(),
        );
      } else {
        await TajBackend.signInWithEmail(email.text.trim(), password.text);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(signup ? 'تم إنشاء الحساب. تحقق من بريدك إذا طُلب ذلك.' : 'تم تسجيل الدخول')),
      );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3A1554), bg, Color(0xFF050308)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: gold.withOpacity(.28)),
                    boxShadow: [BoxShadow(color: royal.withOpacity(.25), blurRadius: 35)],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [royal2, royal]),
                          border: Border.all(color: gold, width: 2),
                        ),
                        child: const Icon(Icons.workspace_premium, color: gold, size: 52),
                      ),
                      const SizedBox(height: 14),
                      const Text('تاج لايف', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: goldSoft)),
                      const SizedBox(height: 5),
                      const Text('غرف صوتية • أصدقاء • هدايا • لحظات', style: TextStyle(color: Colors.white60)),
                      const SizedBox(height: 26),
                      if (signup) ...[
                        TextField(
                          controller: name,
                          decoration: const InputDecoration(labelText: 'الاسم', prefixIcon: Icon(Icons.person_outline)),
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline)),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: loading ? null : submit,
                          style: FilledButton.styleFrom(backgroundColor: royal),
                          child: loading
                              ? const CircularProgressIndicator()
                              : Text(signup ? 'إنشاء حساب' : 'دخول'),
                        ),
                      ),
                      TextButton(
                        onPressed: loading ? null : () => setState(() => signup = !signup),
                        child: Text(signup ? 'لدي حساب بالفعل' : 'إنشاء حساب جديد'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;

  final pages = const [
    HomePage(),
    MomentsPage(),
    MessagesPage(),
    CreatePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: tab, children: pages),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF100C15),
          indicatorColor: royal.withOpacity(.35),
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: gold), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome, color: gold), label: 'اللحظات'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat, color: gold), label: 'الرسائل'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle, color: gold), label: 'إنشاء'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: gold), label: 'أنا'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = TajBackend.liveRooms();
  }

  Future<void> _refresh() async {
    setState(() => _roomsFuture = TajBackend.liveRooms());
    await _roomsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: royal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('مرحباً بك', style: TextStyle(color: Colors.white60)),
                        SizedBox(height: 3),
                        Text(
                          'أمير القلوب',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  _coinPill(),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A1554), Color(0xFF171020)],
                  ),
                  border: Border.all(color: gold.withOpacity(.28)),
                  boxShadow: [
                    BoxShadow(
                      color: royal.withOpacity(.25),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الغرفة الملكية', style: TextStyle(color: goldSoft)),
                          SizedBox(height: 6),
                          Text(
                            'ادخل وتحدث مع أصدقائك',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 5),
                          Text('غرف صوتية • هدايا • مقاعد'),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoomPage(name: 'مجلس العرب'),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: royal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('دخول'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                children: ['الرائجة', 'أتابعها', 'حفلات', 'ألعاب', 'موسيقى', 'VIP', 'قبائل']
                    .map(
                      (x) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(x),
                          selected: x == 'الرائجة',
                          onSelected: (_) {},
                          selectedColor: royal,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'الغرف المباشرة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _roomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(28),
                    child: Center(child: CircularProgressIndicator(color: gold)),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'تعذر تحميل الغرف: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  );
                }
                final rooms = snapshot.data ?? const <Map<String, dynamic>>[];
                if (rooms.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(28),
                    child: Center(
                      child: Text('لا توجد غرف مباشرة الآن', style: TextStyle(color: Colors.white60)),
                    ),
                  );
                }
                return Column(
                  children: rooms.map((room) {
                    final owner = room['profiles'] as Map<String, dynamic>?;
                    return _RoomCard(
                      name: room['name'] as String? ?? 'غرفة تاج لايف',
                      listeners: '${room['viewer_count'] ?? 0}',
                      roomId: room['id'] as String,
                      ownerName: owner?['display_name'] as String?,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  static Widget _coinPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withOpacity(.25)),
      ),
      child: const Row(
        children: [
          Icon(Icons.monetization_on, size: 17, color: gold),
          SizedBox(width: 4),
          Text('5,250'),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String name;
  final String listeners;
  final String roomId;
  final String? ownerName;

  const _RoomCard({
    required this.name,
    required this.listeners,
    required this.roomId,
    this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 11),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomPage(name: name, roomId: roomId)),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: royal.withOpacity(.42)),
          ),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D2DB2), Color(0xFF281438)],
                  ),
                  border: Border.all(color: gold.withOpacity(.3)),
                ),
                child: const Icon(Icons.mic_rounded, color: gold, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8D214C),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'مباشر',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '🇪🇬 مصر • $listeners مستمع • ${ownerName ?? 'مالك الغرفة'}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: List.generate(
                        5,
                        (i) => const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: royal2,
                            child: Icon(Icons.person, size: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomPage extends StatefulWidget {
  final String name;
  final String? roomId;
  final int seatCount;
  const RoomPage({super.key, required this.name, this.roomId, this.seatCount = 8});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  int selectedSeat = -1;
  late int _activeSeatCount;
  bool _joined = false;
  bool micOn = false;
  bool _seatBusy = false;
  final messages = <String>[
    'مرحباً بكم في الغرفة 👋',
    'أهلاً بكل الموجودين ❤️',
    'يرجى احترام الجميع والتواصل بأدب.',
  ];
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    if (widget.roomId != null) {
      TajBackend.leaveRoom(widget.roomId!);
    }
    super.dispose();
  }

  Future<void> _toggleMic() async {
    if (widget.roomId == null || selectedSeat < 0 || TajBackend.user == null) {
      if (mounted) setState(() => micOn = !micOn);
      return;
    }
    try {
      await TajBackend.setMic(widget.roomId!, selectedSeat + 1, !micOn);
      if (mounted) setState(() => micOn = !micOn);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر تغيير حالة الميكروفون: $e')),
        );
      }
    }
  }

  Future<void> _sendMessage(String value) async {
    if (value.trim().isEmpty) return;
    final roomId = widget.roomId;
    if (roomId == null || TajBackend.user == null) {
      setState(() => messages.add(value.trim()));
    } else {
      try {
        await TajBackend.sendRoomMessage(roomId, value);
      } catch (_) {
        if (mounted) setState(() => messages.add(value.trim()));
      }
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!_joined && widget.roomId != null && TajBackend.user != null) {
      _joined = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => TajBackend.joinRoom(widget.roomId!));
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3B1454), Color(0xFF0C0710), bg],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const Text('1,248 مستمع', style: TextStyle(fontSize: 11, color: Colors.white54)),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => _roomSettings(context), icon: const Icon(Icons.settings_outlined)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
                      const CircleAvatar(
                        radius: 19,
                        backgroundColor: royal,
                        child: Icon(Icons.person, size: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: gold.withOpacity(.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.workspace_premium, color: gold, size: 19),
                      SizedBox(width: 8),
                      Text('الغرفة الملكية'),
                      Spacer(),
                      Text('VIP 5', style: TextStyle(color: gold)),
                    ],
                  ),
                ),
                Expanded(
                  child: widget.roomId == null
                      ? GridView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 15, 12, 6),
                          itemCount: _activeSeatCount,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _activeSeatCount == 15 ? 5 : 4,
                            childAspectRatio: .70,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (_, i) => _Seat(
                            index: i,
                            selected: i == selectedSeat,
                            onTap: () => setState(() => selectedSeat = i),
                          ),
                        )
                      : StreamBuilder<List<Map<String, dynamic>>>(
                          stream: TajBackend.roomSeats(widget.roomId!),
                          builder: (context, snapshot) {
                            final rows = snapshot.data ?? const <Map<String, dynamic>>[];
                            return GridView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 15, 12, 6),
                              itemCount: widget.seatCount,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: widget.seatCount == 15 ? 5 : 4,
                                childAspectRatio: .70,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (_, i) {
                                final seatNo = i + 1;
                                final row = rows.cast<Map<String, dynamic>?>().firstWhere(
                                  (x) => x?['seat_number'] == seatNo,
                                  orElse: () => null,
                                );
                                final occupied = row?['user_id'] != null;
                                final mine = row?['user_id'] == TajBackend.user?.id;
                                return _Seat(
                                  index: i,
                                  selected: mine,
                                  occupied: occupied,
                                  onLongPress: occupied && !mine ? () => _moderate(context, row?['user_id']?.toString() ?? '') : null,
                                  onTap: () async {
                                    if (_seatBusy) return;
                                    setState(() => _seatBusy = true);
                                    try {
                                      if (mine) {
                                        await TajBackend.releaseSeat(widget.roomId!, seatNo);
                                        if (mounted) setState(() => selectedSeat = -1);
                                      } else if (!occupied) {
                                        await TajBackend.requestSeat(widget.roomId!, seatNo);
                                        if (mounted) setState(() => selectedSeat = i);
                                      }
                                    } catch (e) {
                                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تعذر تغيير المقعد: $e')),
                                      );
                                    } finally {
                                      if (mounted) setState(() => _seatBusy = false);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  padding: const EdgeInsets.all(12),
                  height: 205,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text('الدردشة', style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
                          SizedBox(width: 22),
                          Text('الهدايا', style: TextStyle(color: Colors.white70)),
                          Spacer(),
                          Icon(Icons.more_horiz),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: widget.roomId == null
                            ? ListView(
                                children: messages.map((m) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(m),
                                )).toList(),
                              )
                            : StreamBuilder<List<Map<String, dynamic>>>(
                                stream: TajBackend.roomMessages(widget.roomId!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(child: Text('تعذر تحميل المحادثة'));
                                  }
                                  final rows = snapshot.data ?? const <Map<String, dynamic>>[];
                                  if (rows.isEmpty) {
                                    return const Center(child: Text('ابدأ أول محادثة في الغرفة', style: TextStyle(color: Colors.white54)));
                                  }
                                  return ListView.builder(
                                    itemCount: rows.length,
                                    itemBuilder: (_, i) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(rows[i]['body']?.toString() ?? ''),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: _sendMessage,
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: 'اكتب رسالة...',
                                isDense: true,
                                filled: true,
                                fillColor: surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showGifts(context),
                            icon: const Icon(Icons.card_giftcard, color: gold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    children: [
                      _RoundButton(icon: Icons.card_giftcard, color: gold, onTap: () => _showGifts(context)),
                      _RoundButton(
                        icon: micOn ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        onTap: _toggleMic,
                      ),
                      _RoundButton(icon: Icons.add_reaction, color: royal2, onTap: () {}),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => setState(() => selectedSeat = selectedSeat < 0 ? 0 : -1),
                          style: FilledButton.styleFrom(backgroundColor: royal),
                          child: Text(selectedSeat < 0 ? 'طلب مقعد' : 'مغادرة المقعد'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _roomSettings(BuildContext context) async {
    if (widget.roomId == null) return;
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: surface,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(padding: EdgeInsets.all(18), child: Text('إعدادات الغرفة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          for (final count in [8, 10, 15])
            ListTile(
              leading: Icon(Icons.mic_external_on, color: count == _activeSeatCount ? gold : Colors.white54),
              title: Text('$count ميكروفونات'),
              trailing: count == _activeSeatCount ? const Icon(Icons.check, color: gold) : null,
              onTap: () => Navigator.pop(context, count),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shield_outlined, color: gold),
            title: const Text('إدارة المستخدمين'),
            onTap: () => Navigator.pop(context, -1),
          ),
        ]),
      ),
    );
    if (selected == null || selected < 1) return;
    if (selected == _activeSeatCount) return;
    try {
      await TajBackend.updateRoomSeats(widget.roomId!, selected);
      if (mounted) setState(() => _activeSeatCount = selected);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن تغيير عدد المقاعد: $e')));
    }
  }

  Future<void> _moderate(BuildContext context, String targetId) async {
    if (widget.roomId == null) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: surface,
      builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(padding: EdgeInsets.all(18), child: Text('إدارة المستخدم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ListTile(leading: const Icon(Icons.volume_off), title: const Text('كتم'), onTap: () => Navigator.pop(context, 'mute')),
        ListTile(leading: const Icon(Icons.volume_up), title: const Text('إلغاء الكتم'), onTap: () => Navigator.pop(context, 'unmute')),
        ListTile(leading: const Icon(Icons.warning_amber), title: const Text('تحذير'), onTap: () => Navigator.pop(context, 'warn')),
        ListTile(leading: const Icon(Icons.remove_circle_outline), title: const Text('إخراج من الغرفة'), onTap: () => Navigator.pop(context, 'kick')),
        ListTile(leading: const Icon(Icons.block), title: const Text('حظر'), onTap: () => Navigator.pop(context, 'ban')),
      ])),
    );
    if (action == null) return;
    try {
      await TajBackend.moderateUser(roomId: widget.roomId!, targetUserId: targetId, action: action);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تنفيذ الإجراء')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ليس لديك صلاحية لهذا الإجراء: $e')));
    }
  }

  Future<void> _showGifts(BuildContext context) async {
    String? receiverId;
    if (widget.roomId != null) {
      try {
        final rows = await TajBackend.roomSeats(widget.roomId!).first;
        for (final row in rows) {
          final id = row['user_id']?.toString();
          if (id != null && id != TajBackend.user?.id) {
            receiverId = id;
            break;
          }
        }
      } catch (_) {}
    }
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      isScrollControlled: true,
      builder: (_) => GiftSheet(roomId: widget.roomId, receiverId: receiverId),
    );
  }
}

class _Seat extends StatelessWidget {
  final int index;
  final bool selected;
  final bool occupied;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _Seat({
    required this.index,
    required this.selected,
    this.occupied = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF67269D), Color(0xFF1B1026)],
              ),
              border: Border.all(
                color: selected ? gold : (occupied ? Colors.redAccent : royal2.withOpacity(.35)),
                width: selected ? 3 : 1.5,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: gold.withOpacity(.28), blurRadius: 16)]
                  : null,
            ),
            child: Icon(
              index == 0 ? Icons.person : Icons.event_seat,
              color: index == 0 ? gold : Colors.white38,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            index == 0 ? 'المالك' : 'مقعد ${index + 1}',
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: CircleAvatar(
        backgroundColor: surface2,
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class GiftSheet extends StatefulWidget {
  final String? roomId;
  final String? receiverId;
  const GiftSheet({super.key, this.roomId, this.receiverId});
  @override State<GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<GiftSheet> {
  late Future<List<Map<String, dynamic>>> _future;
  String? _sending;
  @override void initState() { super.initState(); _future = TajBackend.gifts(); }

  Future<void> _send(Map<String, dynamic> gift) async {
    final receiver = widget.receiverId;
    final room = widget.roomId;
    if (receiver == null || room == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر متحدثًا على مقعد أولاً')));
      return;
    }
    final id = gift['id']?.toString();
    if (id == null) return;
    setState(() => _sending = id);
    try {
      await TajBackend.sendGift(receiverId: receiver, giftId: id, quantity: 1, roomId: room);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال ' + (gift['name']?.toString() ?? 'الهدية') + ' 🎁')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر إرسال الهدية: ' + e.toString())));
    } finally {
      if (mounted) setState(() => _sending = null);
    }
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator(color: gold)));
          if (snapshot.hasError) return SizedBox(height: 220, child: Center(child: Text('تعذر تحميل الهدايا: ' + snapshot.error.toString())));
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) return const SizedBox(height: 220, child: Center(child: Text('لا توجد هدايا متاحة')));
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('إرسال هدية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              itemCount: rows.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (_, i) {
                final g = rows[i];
                final id = g['id']?.toString();
                final busy = _sending == id;
                return Card(
                  color: surface2,
                  child: InkWell(
                    onTap: busy ? null : () => _send(g),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(g['emoji']?.toString() ?? '🎁', style: const TextStyle(fontSize: 31)),
                      Text(g['name']?.toString() ?? 'هدية'),
                      Text((g['coin_price']?.toString() ?? '0') + ' 🪙', style: const TextStyle(color: gold)),
                      if (busy) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                    ]),
                  ),
                );
              },
            ),
          ]);
        },
      ),
    ),
  );
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override State<NotificationsPage> createState() => _NotificationsPageState();
}
class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Map<String, dynamic>>> _future;
  @override void initState() { super.initState(); _future = TajBackend.myNotifications(); }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الإشعارات')),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: gold));
        if (snapshot.hasError) return Center(child: Text('تعذر تحميل الإشعارات: ' + snapshot.error.toString()));
        final rows = snapshot.data ?? const <Map<String, dynamic>>[];
        if (rows.isEmpty) return const Center(child: Text('لا توجد إشعارات جديدة'));
        return ListView.separated(
          padding: const EdgeInsets.all(14), itemCount: rows.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final n = rows[i]; final read = n['read_at'] != null;
            return ListTile(
              leading: Icon(read ? Icons.notifications_none : Icons.notifications_active, color: read ? Colors.white54 : gold),
              title: Text(n['title']?.toString() ?? 'تاج لايف'),
              subtitle: Text(n['body']?.toString() ?? ''),
              onTap: () async {
                if (!read && n['id'] != null) await TajBackend.markNotificationRead(n['id'].toString());
                if (mounted) setState(() => _future = TajBackend.myNotifications());
              },
            );
          },
        );
      },
    ),
  );
}

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});
  @override State<MomentsPage> createState() => _MomentsPageState();
}
class _MomentsPageState extends State<MomentsPage> {
  late Future<List<Map<String, dynamic>>> _future;
  @override void initState() { super.initState(); _future = TajBackend.moments(); }
  Future<void> _refresh() async { setState(() => _future = TajBackend.moments()); await _future; }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('اللحظات'), actions: [IconButton(onPressed: _compose, icon: const Icon(Icons.add, color: gold))]),
    body: RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: gold));
          if (snapshot.hasError) return Center(child: Text('تعذر تحميل اللحظات: ' + snapshot.error.toString()));
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) return ListView(children: const [SizedBox(height: 220), Center(child: Text('لا توجد لحظات بعد'))]);
          return ListView.builder(
            padding: const EdgeInsets.all(16), itemCount: rows.length,
            itemBuilder: (_, i) {
              final r = rows[i]; final p = r['profiles'] as Map<String, dynamic>?;
              return _MomentCard(name: p?['display_name']?.toString() ?? 'مستخدم تاج لايف', text: r['text']?.toString() ?? '', likes: (r['likes_count'] as num?)?.toInt() ?? 0);
            },
          );
        },
      ),
    ),
  );
  Future<void> _compose() async {
    final c = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('نشر لحظة'),
        content: TextField(controller: c, maxLines: 5, autofocus: true, decoration: const InputDecoration(hintText: 'اكتب ما تريد مشاركته...')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('نشر'))],
      ),
    );
    c.dispose();
    if (text == null || text.isEmpty) return;
    try { await TajBackend.createMoment(text); if (mounted) setState(() => _future = TajBackend.moments()); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر نشر اللحظة: ' + e.toString()))); }
  }
}
class _MomentCard extends StatelessWidget {
  const _MomentCard({required this.name, required this.text, required this.likes});
  final String name, text; final int likes;
  @override Widget build(BuildContext context) => Card(
    color: surface, margin: const EdgeInsets.only(bottom: 12),
    child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const CircleAvatar(backgroundColor: royal, child: Icon(Icons.person)), const SizedBox(width: 9), Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), const Text('منذ قليل', style: TextStyle(color: Colors.white38))]),
      const SizedBox(height: 12), Text(text, style: const TextStyle(fontSize: 16)), const SizedBox(height: 12),
      Row(children: [const Icon(Icons.favorite_border, color: gold, size: 19), const SizedBox(width: 5), Text(likes.toString()), const SizedBox(width: 20), const Icon(Icons.chat_bubble_outline, size: 19), const SizedBox(width: 5), const Text('تعليق')]),
    ])),
  );
}
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  final c=TextEditingController();
  List<Map<String,dynamic>> rows=[];
  bool loading=false;
  Future<void> go() async {
    setState(()=>loading=true);
    try { rows=await TajBackend.searchProfiles(c.text); }
    catch (_) { rows=[]; }
    if(mounted)setState(()=>loading=false);
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar: AppBar(title: const Text('البحث')),
    body: Column(children:[
      Padding(padding: const EdgeInsets.all(14), child: TextField(controller:c, textInputAction:TextInputAction.search, onSubmitted:(_)=>go(), decoration:InputDecoration(hintText:'اسم أو username أو ID', suffixIcon:IconButton(onPressed:go,icon:const Icon(Icons.search))))),
      if(loading) const LinearProgressIndicator(color:gold),
      Expanded(child:ListView.builder(itemCount:rows.length,itemBuilder:(_,i){final r=rows[i];return ListTile(leading:const CircleAvatar(child:Icon(Icons.person)),title:Text(r['display_name']?.toString()??'مستخدم'),subtitle:Text('@'+(r['username']?.toString()??'')+' • ID '+(r['public_id']?.toString()??'')));})),
    ])
  );
}
class VipPage extends StatefulWidget {
  const VipPage({super.key});
  @override State<VipPage> createState()=>_VipPageState();
}
class _VipPageState extends State<VipPage>{
  late Future<List<Map<String,dynamic>>> f;
  @override void initState(){super.initState();f=TajBackend.vipLevels();}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('VIP')),body:FutureBuilder<List<Map<String,dynamic>>>(future:f,builder:(c,s)=>ListView(children:(s.data??[]).map((r)=>Card(color:surface,child:ListTile(leading:const Icon(Icons.workspace_premium,color:gold),title:Text('VIP '+r['level'].toString()),subtitle:Text('XP: '+r['xp_required'].toString()))).toList())));
}
class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});
  @override State<ProfileEditPage> createState()=>_ProfileEditPageState();
}
class _ProfileEditPageState extends State<ProfileEditPage>{
  final name=TextEditingController(), username=TextEditingController(), bio=TextEditingController();
  @override void initState(){super.initState();TajBackend.myProfile().then((p){if(p!=null){name.text=p['display_name']?.toString()??'';username.text=p['username']?.toString()??'';bio.text=p['bio']?.toString()??'';}if(mounted)setState((){});});}
  Future<void> save() async {try{await TajBackend.updateProfile(displayName:name.text.trim(),username:username.text.trim(),bio:bio.text.trim());if(mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم الحفظ')));Navigator.pop(context);}}catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر الحفظ: $e')));}}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('تعديل الملف الشخصي')),body:ListView(padding:const EdgeInsets.all(18),children:[
    TextField(controller:name,decoration:const InputDecoration(labelText:'الاسم')),const SizedBox(height:12),
    TextField(controller:username,decoration:const InputDecoration(labelText:'اسم المستخدم')),const SizedBox(height:12),
    TextField(controller:bio,maxLines:4,decoration:const InputDecoration(labelText:'نبذة')),const SizedBox(height:20),
    FilledButton(onPressed:save,child:const Text('حفظ التغييرات'))
  ]));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('الإعدادات')),body:ListView(children:[
    ListTile(leading:const Icon(Icons.notifications_outlined),title:const Text('الإشعارات'),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const NotificationsPage()))),
    const ListTile(leading:Icon(Icons.lock_outline),title:Text('الخصوصية والأمان'),subtitle:Text('إعدادات الحساب والحماية')),
    const ListTile(leading:Icon(Icons.language),title:Text('اللغة'),subtitle:Text('العربية')),
    const ListTile(leading:Icon(Icons.info_outline),title:Text('عن تاج لايف'),subtitle:Text('الإصدار 1.0.0')),
  ]));
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('إنشاء')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      ListTile(leading: const Icon(Icons.mic, color: gold), title: const Text('إنشاء غرفة صوتية'), subtitle: const Text('8 أو 10 أو 15 مقعداً'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRoomPage()))),
      ListTile(leading: const Icon(Icons.auto_awesome, color: royal2), title: const Text('نشر لحظة'), subtitle: const Text('شارك مع مجتمع تاج لايف'), onTap: () {}),
      ListTile(leading: const Icon(Icons.card_giftcard, color: gold), title: const Text('الهدايا'), subtitle: const Text('استعراض الهدايا'), onTap: () => showModalBottomSheet(context: context, backgroundColor: surface, builder: (_) => const GiftSheet())),
    ]),
  );
}

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});
  @override State<CreateRoomPage> createState() => _CreateRoomPageState();
}
class _CreateRoomPageState extends State<CreateRoomPage> {
  final name = TextEditingController(text: 'غرفتي الملكية');
  int seats = 8;
  @override void dispose() { name.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('إنشاء غرفة')),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الغرفة', border: OutlineInputBorder())),
      const SizedBox(height: 18),
      const Text('عدد المقاعد', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      SegmentedButton<int>(
        segments: const [ButtonSegment(value: 8, label: Text('8')), ButtonSegment(value: 10, label: Text('10')), ButtonSegment(value: 15, label: Text('15'))],
        selected: {seats},
        onSelectionChanged: (v) => setState(() => seats = v.first),
      ),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: () async {
          final roomName = name.text.trim().isEmpty ? 'غرفتي الملكية' : name.text.trim();
          if (TajBackend.user == null) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سجّل الدخول أولاً لإنشاء غرفة حقيقية')),
            );
            return;
          }
          try {
            final roomId = await TajBackend.createRoom(name: roomName, seatCount: seats);
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RoomPage(name: roomName, roomId: roomId, seatCount: seats)),
            );
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تعذر إنشاء الغرفة: $e')),
            );
          }
        },
        child: const Text('إنشاء ودخول'),
      ),
    ]),
  );
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const names = ['سارة', 'محمد', 'فاطمة', 'نور', 'أحمد', 'خالد', 'ليلى', 'جمال'];
    return Scaffold(
      appBar: AppBar(title: const Text('الرسائل')),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(backgroundColor: royal, child: Text('${i + 1}')),
          title: Text(names[i]),
          subtitle: const Text('أهلاً، كيف حالك؟'),
          trailing: const Text('09:45', style: TextStyle(color: Colors.white54)),
        ),
      ),
    );
  }
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override State<WalletPage> createState() => _WalletPageState();
}
class _WalletPageState extends State<WalletPage> {
  late Future<Map<String, dynamic>?> _wallet;
  @override void initState() { super.initState(); _wallet = TajBackend.myWallet(); }

  Future<void> _topup(int amount) async {
    try {
      await TajBackend.client.from('wallet_topups').insert({'user_id': TajBackend.user?.id, 'amount': amount, 'status': 'pending'});
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء طلب الشحن، وسيتم تحديث الرصيد بعد تأكيد الدفع')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر إنشاء طلب الشحن: $e')));
    }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('المحفظة')),
    body: FutureBuilder<Map<String, dynamic>?>(
      future: _wallet,
      builder: (context, s) {
        final p = s.data ?? const <String,dynamic>{};
        final coins = (p['coins'] as num?)?.toInt() ?? 0;
        final diamonds = (p['diamonds'] as num?)?.toInt() ?? 0;
        return ListView(padding: const EdgeInsets.all(18), children: [
          Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), gradient: const LinearGradient(colors: [Color(0xFF5C2097), Color(0xFF24102F)]), border: Border.all(color: gold.withOpacity(.25))),
            child: Column(children: [
              const Text('رصيد العملات', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 7),
              Text('$coins 🪙', style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: goldSoft)),
              const SizedBox(height: 8),
              Text('$diamonds 💎', style: const TextStyle(fontSize: 18, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 20),
          for (final x in [100,550,1250,2750,6000])
            Card(color: surface, child: ListTile(title: Text('$x 🪙'), subtitle: const Text('طلب شحن'), trailing: FilledButton(onPressed: () => _topup(x), style: FilledButton.styleFrom(backgroundColor: royal), child: const Text('شراء')))),
          const SizedBox(height: 15),
          const Text('ملاحظة: الشحن الحقيقي يحتاج بوابة دفع وربط webhook قبل تحصيل أموال حقيقية.', style: TextStyle(color: Colors.white54)),
        ]);
      },
    ),
  );
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _profile;
  @override void initState() { super.initState(); _profile = TajBackend.myProfile(); }
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profile,
          builder: (context, snapshot) {
            final p = snapshot.data ?? const <String, dynamic>{};
            final name = (p['display_name'] ?? 'مستخدم تاج لايف').toString();
            final publicId = (p['public_id'] ?? '—').toString();
            final country = (p['country'] ?? 'مصر').toString();
            final bio = (p['bio'] ?? '').toString();
            return ListView(children: [
              Container(
                height: 300,
                decoration: const BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFF4A1A69), bg],
                )),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 112, height: 112, decoration: BoxDecoration(
                    shape: BoxShape.circle, border: Border.all(color: gold, width: 2),
                    gradient: const LinearGradient(colors: [royal2, royal]),
                  ), child: const Icon(Icons.person, size: 60)),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                  Text('ID: $publicId • $country', style: const TextStyle(color: Colors.white60)),
                  if (bio.isNotEmpty) Padding(padding: const EdgeInsets.all(10), child: Text(bio, textAlign: TextAlign.center)),
                ]),
              ),
              ListTile(leading: const Icon(Icons.account_balance_wallet, color: gold), title: const Text('المحفظة'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletPage()))),
              const ListTile(leading: Icon(Icons.emoji_events, color: gold), title: Text('الإنجازات')),
              const ListTile(leading: Icon(Icons.card_giftcard, color: royal2), title: Text('الهدايا والشارات')),
              ListTile(leading: const Icon(Icons.workspace_premium, color: gold), title: const Text('VIP والمستوى'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VipPage()))),
              const ListTile(leading: Icon(Icons.shield_outlined), title: Text('الحساب والأمان')),
              const ListTile(leading: Icon(Icons.settings), title: Text('الإعدادات')),
              ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: const Text('تسجيل الخروج'),
                onTap: () => TajBackend.signOut()),
            ]);
          },
        ),
      ),
    );
  }
}
