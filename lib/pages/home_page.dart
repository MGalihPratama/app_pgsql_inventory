import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:inventori/utils/color.dart';
import 'menu/kelola_menu.dart';
import 'menu/histori_menu.dart';
import 'menu/penjualan_menu.dart';
import 'menu/perizinan_menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Sistem Inventori"),
        backgroundColor: orangeColors,
      ),
      drawer: new Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [orangeLightColors, orangeColors]),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  )
                ]),
            accountName: new Text(
              "Mr. X",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            accountEmail: new Text("x@admin.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://image.freepik.com/free-icon/important-person_318-10744.jpg"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profil"),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Tentang"),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Keluar"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      )),
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
                        color: Colors.orange,
                        size: 70.0,
                      ),
                      Text("Kelola Barang",
                          style: new TextStyle(fontSize: 17.0))
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
            Card(
              margin: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PerizinanMenu()));
                },
                splashColor: orangeLightColors,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.admin_panel_settings,
                        color: Colors.lightGreen,
                        size: 70.0,
                      ),
                      Text("Perizinan", style: new TextStyle(fontSize: 17.0))
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
                      MaterialPageRoute(builder: (context) => HistoriMenu()));
                },
                splashColor: orangeLightColors,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.history_outlined,
                        color: Colors.blue,
                        size: 70.0,
                      ),
                      Text("Histori", style: new TextStyle(fontSize: 17.0))
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
