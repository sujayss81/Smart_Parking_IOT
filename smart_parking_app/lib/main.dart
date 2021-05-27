import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_parking_app/screens/homePage.dart';
import 'package:smart_parking_app/screens/loginScreen.dart';
import 'package:smart_parking_app/screens/paymentScreen.dart';
import 'package:smart_parking_app/screens/registrationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_app/services/networking.dart';
import 'package:smart_parking_app/screens/paymentScreen.dart';

String token;
Map body;
Map userDetails;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  print(' void main token= $token');
  if (token != null) {
    await getData();
  }
  runApp(SmartParking());
}

Future<void> getData() async {
  Networking net = Networking();
  http.Response res =
      await net.getRequest(urlLabel: 'me', token: token, params: '');
  body = jsonDecode(res.body);
}

class SmartParking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.light(),
      home: (token == null) ? LoginScreen() : HomePage(body: body['body']),
      routes: {
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
