import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventori/pages/menu/item_card.dart';
import 'package:inventori/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../home_page.dart';
import 'item_card_penjualan.dart';

class PenjualanMenu extends StatefulWidget {
  @override
  _PenjualanMenuState createState() => _PenjualanMenuState();
}

class _PenjualanMenuState extends State<PenjualanMenu> {
  StreamController _listController = StreamController();
  String name, stock, price, id;

  final _key = new GlobalKey<FormState>();
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          title: Text('Penjualan'),
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
                            .map<Widget>((e) => ItemCardPenjualan(
                                  e['name'],
                                  e['price'].toString(),
                                  e['stock'].toString(),
                                  jual: () {
                                    AlertJual(context, e).then((onValue) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Hello $onValue")));
                                    });
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return Center(child: Text("Loading...."));
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

  Future<String> AlertJual(BuildContext context, valueE) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _key,
            child: AlertDialog(
              title: Text("Penjualan Barang"),
              content: Container(
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(valueE['stock'].toString() + " - "),
                        Flexible(
                          child: TextFormField(
                            // initialValue: valueE['stock'].toString(),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Masukan jumlah barang";
                              }
                            },
                            onSaved: (e) => name = e,
                            decoration: InputDecoration(
                                hintText: "banyak yang mau dijual"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 140,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.orange,
                          child: Text(
                            'Jual Barang',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            // nameController.text = '';
                            // hargaController.text = '';
                            // stokController.text = '';
                          }),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  height: 25,
                  child: new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Theme.of(context).primaryColor,
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
