import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String searchString = "";
  TextEditingController sc = TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Penjualan");

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

  JualStok(valueE) {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      transaksi(valueE['id']);
    }
  }

  Future transaksi(productID) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    var fullUrl = "http://inv-api-pgsql.herokuapp.com/api/transaction";
    var userdc = jsonDecode(user);
    var msg = jsonEncode({
      'user_id': userdc['id'],
      'product_id': productID,
      'stock': int.parse(stock),
      'type': "pengeluaran",
    });
    var response = await http.post(Uri.parse(fullUrl),
        body: msg, headers: await _setHeaders());

    // final Map<String, dynamic> data = json.decode(response.body);
    Map data = json.decode(response.body);
    _listController.add(data);
    print(data);
    if (data["message"] == "Created Successfully") {
      // return "gagal";

      Fluttertoast.showToast(
        msg: "Stok diJualkan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PenjualanMenu()));
    } else {
      Fluttertoast.showToast(
        msg: "Stok barang kurang",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PenjualanMenu()));
    }
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
                    MaterialPageRoute(builder: (context) => HomePage()));
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
                      this.cusSearchBar = Text("Penjualan");
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
                      var lst = snapshot.data['products'];
                      return Column(
                        children: lst
                            .map<Widget>((e) => (e['name']
                                    .toLowerCase()
                                    .contains(searchString))
                                ? ItemCardPenjualan(
                                    e['name'],
                                    e['price'].toString(),
                                    e['stock'].toString(),
                                    jual: () {
                                      AlertJual(context, e).then((onValue) {});
                                    },
                                  )
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
                            onSaved: (e) => stock = e,
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
                            JualStok(valueE);
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
