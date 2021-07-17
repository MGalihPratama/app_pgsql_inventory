import 'package:flutter/material.dart';
import 'package:inventori/pages/menu/kelola_menu.dart';
import 'package:inventori/pages/menu/penjualan_menu.dart';
import 'package:inventori/pages/menu/perizinan_menu.dart';
import 'package:inventori/utils/color.dart';

class HistoriPembelian extends StatefulWidget {
  @override
  _HistoriPembelianState createState() => _HistoriPembelianState();
}

class _HistoriPembelianState extends State<HistoriPembelian> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Histori Tambah Stok Barang"),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => KelolaMenu()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PenjualanMenu()));
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
