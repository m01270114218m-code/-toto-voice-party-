import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/myninja_design_screen.dart';

class Mt2App extends StatelessWidget {
  const Mt2App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MT2 Voice Party',
        theme: AppTheme.dark,
        home: const Mt2DesignScreen(),
      );
}
