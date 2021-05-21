import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image(
                    image: AssetImage('images/iconCar.png'),
                    height: 100.0,
                    // width: 200.0,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              // Text(
              //   'Fill the form',
              //   style: TextStyle(
              //     fontSize: 40,
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
