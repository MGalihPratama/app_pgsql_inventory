import 'package:flutter/material.dart';
import 'package:inventori/pages/menu/histori_menu.dart';
import 'package:inventori/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'item_card_hp.dart';

class HistoriPembelian extends StatefulWidget {
  @override
  _HistoriPembelianState createState() => _HistoriPembelianState();
}

class _HistoriPembelianState extends State<HistoriPembelian> {
  StreamController _listController = StreamController();
  String name, stock, price, id;
  TextEditingController sc = TextEditingController();
  String searchString = "";

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Histori Pembelian Barang");
  _getUserID() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    return "$user['user_id']";
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
    var fullUrl = "http://inv-api-pgsql.herokuapp.com/api/transaction";
    //return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
    var response =
        await http.get(Uri.parse(fullUrl), headers: await _setHeaders());

    // final Map<String, dynamic> data = json.decode(response.body);
    Map data = json.decode(response.body);
    _listController.add(data);
    print(data);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: orangeColors,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoriMenu()));
              },
            ),
            title: cusSearchBar,
            actions: <Widget>[
              IconButton(
                icon: cusIcon,
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(Icons.cancel);
                      this.cusSearchBar = TextField(
                        onChanged: (value) {
                          setState(() {
                            searchString = value.toLowerCase();
                          });
                        },
                        textInputAction: TextInputAction.go,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                        decoration: InputDecoration(
                            hintText: "Nama Barang",
                            hintStyle: TextStyle(color: Colors.white)),
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text("Histori Pembelian Barang");
                      this.searchString = "";
                    }
                  });
                },
              ),
            ]),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                StreamBuilder(
                  stream: _listController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var lst = snapshot.data['transactions_in'];
                      return Column(
                        children: lst
                            .map<Widget>((e) => (e['product']['name']
                                    .toLowerCase()
                                    .contains(searchString))
                                ? ItemCardHp(
                                    e['product']['name'],
                                    e['product']['price'].toString(),
                                    e['product']['stock'].toString(),
                                    e['stock'].toString(),
                                    e['created_at'].toString())
                                : Container())
                            .toList(),
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          ],
        ));
  }
}
