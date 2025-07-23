import 'package:ass_app/constants/ColorConstants.dart';
import 'package:ass_app/screens/ChatScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(
        scaffoldBackgroundColor: AppColors.AppMainBgTheme,

      ),
      home: ChatScreen(),
    );
  }
}