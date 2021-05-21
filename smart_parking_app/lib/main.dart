import 'package:flutter/material.dart';
import 'package:smart_parking_app/screens/homeScreen.dart';
import 'package:smart_parking_app/screens/registrationScreen.dart';

void main() {
  runApp(SmartParking());
}

class SmartParking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.light(),
      initialRoute: HomeScreen.id,
      routes: {
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
