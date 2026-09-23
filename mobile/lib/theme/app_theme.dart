import 'package:flutter/material.dart';
class AppTheme{
  static const bg=Color(0xFF0D0718),surface=Color(0xFF181027),purple=Color(0xFF8B5CF6),gold=Color(0xFFFFD66B);
  static ThemeData get dark=>ThemeData(
    useMaterial3:true,brightness:Brightness.dark,scaffoldBackgroundColor:bg,
    colorScheme:ColorScheme.fromSeed(seedColor:purple,brightness:Brightness.dark),
    navigationBarTheme:const NavigationBarThemeData(backgroundColor:Color(0xFF120B20),indicatorColor:Color(0xFF39205A),height:70),
    appBarTheme:const AppBarTheme(backgroundColor:Colors.transparent,elevation:0),
    cardTheme:CardThemeData(color:surface,margin:EdgeInsets.zero,shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20)))),
  );
}