import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventori/pages/regi_page.dart';
import 'package:inventori/pages/home_page.dart';
import 'package:inventori/widgets/btn_widget.dart';
import 'package:inventori/widgets/herder_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;

  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(
        "http://inv-api-pgsql.herokuapp.com/api/login",
        body: {'email': email, 'password': password});
    //final data = jsonEncode(response.body);
    final Map<String, dynamic> data = json.decode(response.body);
    //print(data);
    print(data);

    if (data["message"] == "Invalid Credentials") {
      // return "gagal";
      Fluttertoast.showToast(
        msg: "Email atau Password salah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('access_token', data['access_token']);
      localStorage.setString('user', json.encode(data['user']));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
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
              HeaderContainer("Login"),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Masukkan Email";
                              }
                            },
                            onSaved: (e) => email = e,
                            decoration: InputDecoration(
                                hintText: "Email",
                                icon: Icon(Icons.mail),
                                border: OutlineInputBorder())),
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Masukkan Password";
                            }
                          },
                          obscureText: _obscureText,
                          onSaved: (e) => password = e,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(Icons.vpn_key),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: _toggle,
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                        ),
                        // MaterialButton(
                        //   onPressed: () {
                        //     check();
                        //   },
                        //   child: Text("Login"),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ButtonWidget(
                            onClick: () {
                              check();
                            },
                            btnText: "Login",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Belum punya akun? silahkan"),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegPage()));
                              },
                              child: Text("Registrasi",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
