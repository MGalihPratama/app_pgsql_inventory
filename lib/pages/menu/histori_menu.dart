import 'package:flutter/material.dart';
import 'package:inventori/pages/home_page.dart';
import 'package:inventori/pages/menu/page_histori/pembelian.dart';
import 'package:inventori/pages/menu/page_histori/penjualan.dart';
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
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: Text("Histori"),
        backgroundColor: orangeColors,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistoriPembelian()));
                },
                splashColor: orangeLightColors,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.add_business,
                        color: Colors.blue,
                        size: 70.0,
                      ),
                      Text("Pembelian", style: new TextStyle(fontSize: 17.0))
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistoriPenjualan()));
                },
                splashColor: orangeLightColors,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.grey,
                        size: 70.0,
                      ),
                      Text("Penjualan", style: new TextStyle(fontSize: 17.0))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
