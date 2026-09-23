import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/discover_screen.dart';
import '../screens/party_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/profile_screen.dart';

class Mt2App extends StatelessWidget {
  const Mt2App({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner:false, title:'MT2 Voice Party', theme:AppTheme.dark, home:const MainShell(),
  );
}
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState()=>_MainShellState();
}
class _MainShellState extends State<MainShell>{
  int index=0;
  static const pages=[HomeScreen(),DiscoverScreen(),PartyScreen(),MessagesScreen(),ProfileScreen()];
  @override Widget build(BuildContext c)=>Scaffold(
    body:IndexedStack(index:index,children:pages),
    bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(v)=>setState(()=>index=v),destinations:const[
      NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
      NavigationDestination(icon:Icon(Icons.explore_outlined),selectedIcon:Icon(Icons.explore),label:'Discover'),
      NavigationDestination(icon:Icon(Icons.mic_none),selectedIcon:Icon(Icons.mic),label:'Party'),
      NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat_bubble),label:'Messages'),
      NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Me'),
    ]),
  );
}