import 'package:flutter/material.dart';
import 'package:inventori/utils/color.dart';
import 'package:inventori/widgets/btn_widget.dart';
import 'package:inventori/widgets/herder_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  String username, email, password, password_confirmation;

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
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation
    });
    final data = jsonEncode(response.body);
    print(data);
  }

  bool _secureText = true;
  showHide() {
    _secureText = !_secureText;
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
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Masukkan Username";
                          }
                        },
                        onSaved: (e) => username = e,
                        decoration: InputDecoration(hintText: "username"),
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Masukkan Email";
                          }
                        },
                        onSaved: (e) => email = e,
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Masukkan Password";
                          }
                        },
                        obscureText: _secureText,
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Konfirmasi Password";
                          }
                        },
                        obscureText: _secureText,
                        onSaved: (e) => password_confirmation = e,
                        decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                      MaterialButton(
                        onPressed: () {
                          check();
                        },
                        child: Text("Registrasi"),
                      ),
                    ],
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
