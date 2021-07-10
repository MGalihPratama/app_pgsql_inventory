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

class KelolaMenu extends StatefulWidget {
  @override
  _KelolaMenuState createState() => _KelolaMenuState();
}

class _KelolaMenuState extends State<KelolaMenu> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController hargaController = TextEditingController();

  final TextEditingController stokController = TextEditingController();
  StreamController _listController = StreamController();

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
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // CollectionReference users = firestore.collection('user');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: orangeColors,
          title: Text('Kelola Barang'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                createAlertDialog(context).then((onValue) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Hello $onValue")));
                });
              },
            )
          ],
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
                            .map<Widget>((e) => ItemCard(
                                  e['name'],
                                  e['price'].toString(),
                                  e['stock'].toString(),
                                  onDelete: () {
                                    // users.doc(e.id).delete();
                                  },
                                  onUpdate: () {
                                    // users
                                    //     .doc(e.id)
                                    //     .update({'stok': e.data()['stok'] + 1});
                                    // AlertUpdate(context).then((onValue) {
                                    //   Scaffold.of(context).showSnackBar(
                                    //       SnackBar(
                                    //           content: Text("Hello $onValue")));
                                    // });
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return Text("Loading....");
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

  String name, stock, price;

  final _key = new GlobalKey<FormState>();
  TambahBarang() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      tambah();
    }
  }

  tambah() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    var userdc = jsonDecode(user);
    var msg = jsonEncode({
      'user_id': userdc['id'],
      'name': name,
      'stock': stock,
      'price': int.parse(price)
    });
    final response = await http.post(
        "http://inv-api-pgsql.herokuapp.com/api/product",
        headers: await _setHeaders(),
        body: msg);

    Map data = json.decode(response.body);
    print(data);
  }

  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _key,
            child: AlertDialog(
              title: Text("Tambah Barang Baru"),
              content: Container(
                height: 200,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukan nama Barang";
                        }
                      },
                      onSaved: (e) => name = e,
                      decoration: InputDecoration(hintText: "Nama Barang"),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukkan stok barang";
                        }
                      },
                      onSaved: (e) => stock = e,
                      decoration: InputDecoration(hintText: "Stok Barang"),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukkan harga barang";
                        }
                      },
                      onSaved: (e) => price = e,
                      decoration: InputDecoration(hintText: "Harga Barang"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        TambahBarang();
                      },
                      child: Text("Tambah"),
                    ),
                    // Container(
                    //   width: 100,
                    //   child: RaisedButton(
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8)),
                    //       color: Colors.orange,
                    //       child: Text(
                    //         'Tambah',
                    //         style: GoogleFonts.poppins(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       onPressed: () {
                    //         TambahBarang();
                    //       }),
                    // ),
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

  Future<String> AlertUpdate(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('user');
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ubah Data Barang"),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "Nama Barang "),
                  ),
                  TextField(
                    controller: hargaController,
                    decoration: InputDecoration(hintText: "harga (ex. 2000)"),
                  ),
                  TextField(
                    controller: stokController,
                    decoration: InputDecoration(hintText: "stok (ex. 10)"),
                  ),
                  Container(
                    width: 100,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.orange,
                        child: Text(
                          'Ubah',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          //// ADD DATA HERE
                          users.add({
                            'name': nameController.text,
                            'harga': int.tryParse(hargaController.text) ?? 0,
                            'stok': int.tryParse(stokController.text) ?? 0
                          });
                          nameController.text = '';
                          hargaController.text = '';
                          stokController.text = '';
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
          );
        });
  }
}
