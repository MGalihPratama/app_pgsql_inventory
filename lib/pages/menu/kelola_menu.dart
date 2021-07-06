import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventori/pages/menu/item_card.dart';

import 'package:inventori/utils/color.dart';

class KelolaMenu extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('user');
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
                StreamBuilder<QuerySnapshot>(
                  stream: users.orderBy('name').snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map((e) => ItemCard(
                                  e.data()['name'],
                                  e.data()['harga'],
                                  e.data()['stok'],
                                  onDelete: () {
                                    users.doc(e.id).delete();
                                  },
                                  onUpdate: () {
                                    // users
                                    //     .doc(e.id)
                                    //     .update({'stok': e.data()['stok'] + 1});
                                    AlertUpdate(context).then((onValue) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Hello $onValue")));
                                    });
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return Text("Loading");
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

  Future<String> createAlertDialog(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('user');
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Tambah Barang Baru"),
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
                          'Tambah',
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
