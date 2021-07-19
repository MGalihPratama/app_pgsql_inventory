import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:inventori/utils/color.dart';
import 'menu/kelola_menu.dart';
import 'menu/histori_menu.dart';
import 'menu/penjualan_menu.dart';
import 'menu/perizinan_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Future<String> getUserID() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("name");
    return "$user";
  }

  String email = "";
  Future checkLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      email = localStorage.getString('email');
    });
  }

  Future logOut(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('email');
    Fluttertoast.showToast(
      msg: "Berhasil keluar",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var access_token = localStorage.getString('access_token');
    return "$access_token";
  }

  _setHeaders() async => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': ' Bearer ' + await _getToken()
      };

  Future getData() async {
    var fullUrl = "http://inv-api-pgsql.herokuapp.com/api/product?user_id=" +
        await getUserID();
    //return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
    var response =
        await http.get(Uri.parse(fullUrl), headers: await _setHeaders());

    // final Map<String, dynamic> data = json.decode(response.body);
    Map data = json.decode(response.body);
    print(data);
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: new AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 30.0,
              ),
              Text("Sistem Inventori")
            ],
          ),
          backgroundColor: orangeColors,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                logOut(context);
              },
            )
          ],
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PenjualanMenu()));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerizinanMenu()));
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
      ),
    );
  }
}
