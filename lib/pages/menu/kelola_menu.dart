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

class KelolaMenu extends StatefulWidget {
  @override
  _KelolaMenuState createState() => _KelolaMenuState();
}

class _KelolaMenuState extends State<KelolaMenu> {
  StreamController _listController = StreamController();
  String name, stock, price, id, type;
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

  TambahStok(valueE) {
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
      'type': "pemasukan",
    });
    var response = await http.post(Uri.parse(fullUrl),
        body: msg, headers: await _setHeaders());

    // final Map<String, dynamic> data = json.decode(response.body);
    Map data = json.decode(response.body);
    _listController.add(data);
    print(data);
    Fluttertoast.showToast(
      msg: "Stok ditambahkan",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KelolaMenu()));
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

  hapus(e) async {
    var id = e['id'];
    final response = await http.delete(
      "http://inv-api-pgsql.herokuapp.com/api/product/" + id.toString(),
      headers: await _setHeaders(),
    );

    Map data = json.decode(response.body);
    print(data);
    Fluttertoast.showToast(
      msg: "Barang dihapus",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KelolaMenu()));
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
                                    print(e['id']);
                                    // hapus(e);
                                    DeleteAlert(context, e).then((onValue) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Hello $onValue")));
                                    });
                                  },
                                  stok: () {
                                    AlertStok(context, e).then((onValue) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Hello $onValue")));
                                    });
                                  },
                                  onUpdate: () {
                                    print(e['name']);
                                    AlertUpdate(context, e).then((onValue) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Hello $onValue")));
                                    });
                                  },
                                ))
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

    Fluttertoast.showToast(
      msg: "Barang ditambahkan",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KelolaMenu()));
  }

  update(e) async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
    }
    var id = e.toString();
    var msg = jsonEncode({'name': name, 'price': int.parse(price)});
    final response = await http.patch(
        "http://inv-api-pgsql.herokuapp.com/api/product/" + id,
        headers: await _setHeaders(),
        body: msg);

    Map data = json.decode(response.body);
    print(data);

    Fluttertoast.showToast(
      msg: "Barang diedit",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KelolaMenu()));
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

  Future<String> AlertUpdate(BuildContext context, valueE) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _key,
            child: AlertDialog(
              title: Text("Ubah Data Barang"),
              content: Container(
                height: 200,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: valueE['name'],
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukan nama Barang";
                        }
                      },
                      onSaved: (e) => name = e,
                      // decoration: InputDecoration(hintText: "Nama Barang"),
                    ),
                    TextFormField(
                      initialValue: valueE['price'].toString(),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukkan harga barang";
                        }
                      },
                      onSaved: (e) => price = e,
                      decoration: InputDecoration(hintText: "Harga Barang"),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            update(valueE['id']);

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

  Future<String> AlertStok(BuildContext context, valueE) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _key,
            child: AlertDialog(
              title: Text("Tambah Stok Barang"),
              content: Container(
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(valueE['stock'].toString() + " + "),
                        Flexible(
                          child: TextFormField(
                            // initialValue: valueE['stock'].toString(),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Masukan nama Barang";
                              }
                            },
                            onSaved: (e) => stock = e,
                            decoration: InputDecoration(
                                hintText: "banyak yang mau ditambah"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 150,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.orange,
                          child: Text(
                            'Tambah Stok',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            TambahStok(valueE);

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

  Future<String> DeleteAlert(BuildContext context, valueE) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Barang'),
          content: Text("Yakin ingin hapus barang?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Iya"),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                hapus(valueE);
              },
            ),
            FlatButton(
              child: Text("Tidak"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//alert yes no


