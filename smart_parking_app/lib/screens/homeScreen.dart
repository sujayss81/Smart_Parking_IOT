import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:smart_parking_app/screens/registrationScreen.dart';
import 'package:smart_parking_app/services/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = '';
  String password = '';
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  SharedPreferences prefs;

  void postRequest({String urlLabel, Map body}) async {
    String sendingBody = jsonEncode(body);
    print(sendingBody);
    String token;
    http.Response res = await http.post(Uri.parse('$hostUrl/$urlLabel'),
        body: sendingBody, headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      token = res.headers['x-auth-token'];
      print(token);
      http.Response res2 = await http.get(Uri.parse('$hostUrl/me'),
          headers: {'x-auth-token': token, 'Content-Type': 'application/json'});
      if (res2.statusCode == 200) {
        // print(res2);
        print(res2.body);
      } else if (res2.statusCode == 400) {
        print('authentication problem');
        // print(res.body);
      } else {
        print('server error');
      }
    } else if (res.statusCode == 400) {
      print('post request authentication error');
    } else {
      print('post request server error');
      print(res.statusCode);
    }
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initState() {
    super.initState();
    initSharedPref();
  }

  // Networking net = new Networking();

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailText,
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your email'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordText,
                obscureText: true,
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your password'),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.blue,
                elevation: 5.0,
                child: MaterialButton(
                  child: Text('Login'),
                  height: 40,
                  minWidth: 20,
                  onPressed: () {
                    // emailText.clear();
                    // passwordText.clear();
                    Map body = {'email': email, 'password': password};
                    String token = prefs.getString('token');
                    if (token == null) {
                      postRequest(urlLabel: 'login', body: body);
                    }
                  },
                ),
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
