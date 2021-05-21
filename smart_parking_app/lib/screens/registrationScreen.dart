import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum Gender{male,female}

class RegistrationScreen extends StatefulWidget {
  String name;
  String email;
  String password;
  String dob = '';
  String gender ;



  static const id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String dob = 'Select Date';
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
      prefs.setString('token', token);
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

  void registerUser(){
    Map body={
      'name' : widget.name,
      'email' : widget.email,
      'password' : widget.password,
      'dob' : widget.dob,
      'gender' : widget.gender,
    };
    print(body);
    postRequest(urlLabel: 'register',body: body);
  }

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
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image(
                      image: AssetImage('images/iconCar.png'),
                      height: 100.0,
                      // width: 200.0,
                    ),
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

              decoration: kInputDecoration.copyWith(hintText: 'Name'),
              keyboardType: TextInputType.name,
              onChanged: (value) {
                widget.name = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(

              decoration: kInputDecoration.copyWith(hintText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                widget.email = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(

              obscureText: true,
              decoration: kInputDecoration.copyWith(hintText: 'Password'),
              onChanged: (value) {
                widget.password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(

              children: [
                Text('Date of Birth:'),
                SizedBox(
                  width: 50.0,
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey,
                  child: MaterialButton(
                    child: Text(
                          dob,
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
                        setState(() {
                          dob = date;
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(
                  'Gender : '
                ),
                Radio(value: 'male', groupValue: widget.gender, onChanged: (value){
                  setState(() {
                    widget.gender = value;
                  });
                }),
                Text('Male'),
                SizedBox(
                  width: 20.0,
                ),
                Radio(value: 'female', groupValue: widget.gender, onChanged: (value){
                  setState(() {
                    widget.gender = value;
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
                  registerUser();

                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
