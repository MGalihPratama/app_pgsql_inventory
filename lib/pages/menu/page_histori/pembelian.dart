import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventori/pages/menu/histori_menu.dart';
import 'package:inventori/pages/menu/page_histori/penjualan.dart';
import 'package:inventori/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    var fullUrl = "http://inv-api-pgsql.herokuapp.com/api/product?user_id=" +
        await _getUserID();
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
          title: Text('Histori Pembelian Barang'),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                StreamBuilder(
                  stream: _listController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var lst = snapshot.data['products'];
                      return Column(
                        children: lst
                            .map<Widget>((e) => ItemCardHp(
                                e['name'],
                                e['price'].toString(),
                                e['stock'].toString(),
                                e['date']))
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
