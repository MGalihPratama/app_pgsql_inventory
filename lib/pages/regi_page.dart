import 'package:flutter/material.dart';
import 'package:inventori/utils/color.dart';
import 'package:inventori/widgets/btn_widget.dart';
import 'package:inventori/pages/login_page.dart';
import 'package:inventori/widgets/herder_container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  String name, email, password, password_confirmation;
  bool _isLoading = false;
  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      register();
    }
  }

  register() async {
    final response = await http
        .post("http://inv-api-pgsql.herokuapp.com/api/register", body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation
    });

    final Map<String, dynamic> data = json.decode(response.body);
    print(data);

    if (data["message"] == "failed") {
      Fluttertoast.showToast(
        msg: "Email telah digunakan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Registrasi Berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              HeaderContainer("Register"),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Masukkan name";
                            }
                          },
                          onSaved: (e) => name = e,
                          decoration: InputDecoration(
                              hintText: "name",
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.people)),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Masukkan Email";
                            }
                          },
                          onSaved: (e) => email = e,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.mail)),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Masukkan Password";
                            }
                          },
                          obscureText: _obscureText1,
                          onSaved: (e) => password = e,
                          decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.vpn_key),
                              suffixIcon: IconButton(
                                onPressed: _toggle1,
                                icon: Icon(_obscureText1
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Konfirmasi Password";
                            }
                          },
                          obscureText: _obscureText2,
                          onSaved: (e) => password_confirmation = e,
                          decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.vpn_key),
                              suffixIcon: IconButton(
                                onPressed: _toggle2,
                                icon: Icon(_obscureText2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        // MaterialButton(
                        //   onPressed: () {
                        //     check();
                        //   },
                        //   child: Text("Registrasi"),
                        // ),
                        ButtonWidget(
                          onClick: () {
                            setState(() {
                              _isLoading = true;
                            });
                            check();
                          },
                          btnText: "Registrasi",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
