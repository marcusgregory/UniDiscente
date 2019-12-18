import 'package:flutter/material.dart';
import 'package:uni_discente/ui/login.ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniDiscente',
      theme: ThemeData(
           accentColor: Color(0x00396A),
      ),
      home: LoginPage(title: 'Login'),
    );
  }
}

