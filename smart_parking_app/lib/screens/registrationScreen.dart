import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:intl/intl.dart';

enum Gender{male,female}

class RegistrationScreen extends StatefulWidget {
  String dob = '';

  static const id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String name;
  String email;
  String password;

  Gender gender ;

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
          Text(
            'REGISTER',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: TextEditingController(),
              decoration: kInputDecoration.copyWith(hintText: 'Name'),
              keyboardType: TextInputType.name,
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: TextEditingController(),
              decoration: kInputDecoration.copyWith(hintText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: TextEditingController(),
              obscureText: true,
              decoration: kInputDecoration.copyWith(hintText: 'Password'),
              onChanged: (value) {
                password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(

              children: [
                Text('Date of Birth'),
                SizedBox(
                  width: 50.0,
                ),
                ElevatedButton(
                  child: Text(
                    'SELECT',
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    ).then((d) {
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      String date = formatter.format(d);
                      widget.dob = date;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Gender : '
                ),
                Radio<Gender>(value: Gender.male, groupValue: gender, onChanged: (Gender value){
                  setState(() {
                    gender = value;
                  });
                }),
                Text('Male'),
                SizedBox(
                  width: 20.0,
                ),
                Radio<Gender>(value: Gender.female, groupValue: gender, onChanged: (Gender value){
                  setState(() {
                    gender = value;
                  });
                }),
                Text('Female'),
              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.blue,
              elevation: 5.0,
              child: MaterialButton(
                child: Text(
                    'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),

                ),
                height: 40,
                minWidth: 20,
                onPressed: () {
                   //TODO:Registering button on pressed
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
