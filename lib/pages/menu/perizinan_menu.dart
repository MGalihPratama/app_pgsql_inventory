import 'package:flutter/material.dart';
import 'package:inventori/utils/color.dart';

class PerizinanMenu extends StatefulWidget {
  @override
  _PerizinanMenuState createState() => _PerizinanMenuState();
}

class _PerizinanMenuState extends State<PerizinanMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Perizinan"),
        backgroundColor: orangeColors,
      ),
      body: Center(child: Text("Coming Soon...")),
    );
  }
}
