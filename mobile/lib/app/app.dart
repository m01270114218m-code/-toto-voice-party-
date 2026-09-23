import 'package:flutter/material.dart';
import '../screens/myninja_design_screen.dart';

class Mt2App extends StatelessWidget {
  const Mt2App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'صوت يجمعنا',
        theme: ThemeData.dark(useMaterial3: true),
        home: const Mt2DesignScreen(),
      );
}
