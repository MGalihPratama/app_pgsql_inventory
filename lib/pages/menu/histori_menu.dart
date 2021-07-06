import 'package:flutter/material.dart';
import 'package:inventori/utils/color.dart';

class HistoriMenu extends StatefulWidget {
  @override
  _HistoriMenuState createState() => _HistoriMenuState();
}

class _HistoriMenuState extends State<HistoriMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Histori"),
        backgroundColor: orangeColors,
      ),
      body: Text("Hello"),
    );
  }
}
