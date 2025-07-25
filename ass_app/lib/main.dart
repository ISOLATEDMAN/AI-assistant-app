import 'package:ass_app/constants/ColorConstants.dart';
import 'package:ass_app/screens/ChatScreen.dart';
import 'package:ass_app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: Homescreen(),
        );
      },
    );
  }
}