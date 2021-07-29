import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inventori/pages/home_page.dart';
import 'package:inventori/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var email = localStorage.getString('email');
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);

  runApp(MaterialApp(
    // home: SplashPage(),
    debugShowCheckedModeBanner: false,
    home: email == null ? LoginPage() : HomePage(),
  ));
}
