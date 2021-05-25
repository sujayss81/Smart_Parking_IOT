import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:smart_parking_app/screens/homePage.dart';
import 'package:smart_parking_app/screens/registrationScreen.dart';
import 'package:smart_parking_app/services/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  bool flag = false;
  Networking net = new Networking();

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initState() {
    super.initState();
    initSharedPref();
  }

  void loginUser() async {
    Map body = {'email': _email, 'password': _password};
    // print(body);
    String token = prefs.getString('token');
    print(token);
    // prefs.clear();
    // String newTok = prefs.getString('token');
    // print('new token = $newTok');
    if (token == null) {
      http.Response res = await net.postRequest(urlLabel: 'login', body: body);
      print('from login page=$res');
      if (res.statusCode == 200) {
        token = res.headers['x-auth-token'];
        print(token);
        print('hello');
        prefs.setString('token', token);
        // prefs.clear();
        flag = false;
      } else if (res.statusCode == 400) {
        //add a toast specifying that username or password is incorrect
        flag = true;
        print('Authentication failed');
      } else {
        print('server error');
        print(jsonDecode(res.body));
        flag = true;
      }
    }
    if (!flag) {
      http.Response res2 =
          await net.getRequest(urlLabel: 'me', token: token, params: '');
      if (res2.statusCode == 200) {
        // print(res2);
        // print(res2.body);
        var body = jsonDecode(res2.body);
        print(body);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(body: body['body'])));
      } else {
        print('server error');
        print(jsonDecode(res2.body));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  child: Image(
                    image: AssetImage('images/iconCar.png'),
                    height: 190.0,
                    width: 200.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      // controller: emailText,
                      decoration: kInputDecoration.copyWith(
                          hintText: 'Enter your email'),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'Please enter valid email';
                        } else
                          return null;
                      },
                      // onSaved: (email) {
                      //   _email = email;
                      // },
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      // controller: passwordText,
                      obscureText: true,
                      decoration: kInputDecoration.copyWith(
                          hintText: 'Enter your password'),
                      textAlign: TextAlign.center,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        } else
                          return null;
                      },
                      // onSaved: (password) {
                      //   _password = password;
                      // },
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blue,
                    elevation: 5.0,
                    child: MaterialButton(
                      child: Text('Login'),
                      height: 40,
                      minWidth: 250,
                      onPressed: () async {
                        // emailText.clear();
                        // passwordText.clear();
                        // print(_email);
                        // print(_password);
                        if (_formKey.currentState.validate()) {
                          loginUser();
                        } else {
                          print("Incomplete fields");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              child: Text(
                'Create a New Account',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
