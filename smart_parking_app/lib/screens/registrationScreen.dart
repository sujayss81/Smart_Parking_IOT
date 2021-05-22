import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:smart_parking_app/services/networking.dart';

enum Gender { male, female }

class RegistrationScreen extends StatefulWidget {
  String name;
  String email;
  String password;
  String dob = '';
  String gender = '';

  static const id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String dob = 'Select Date';
  SharedPreferences prefs;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Networking net = Networking();




  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initState() {
    super.initState();
    initSharedPref();
  }

  void registerUser() async{
    String token='';
    bool flag = false;
    Map body = {
      'name': widget.name,
      'email': widget.email,
      'password': widget.password,
      'dob': widget.dob,
      'gender': widget.gender,
    };
    print(body);
    http.Response res = await net.postRequest(urlLabel: 'signup', body: body);
    if (res.statusCode == 200) {
      token = res.headers['x-auth-token'];
      print(token);
      prefs.setString('token', token);
      prefs.clear();
    }else {
      print('server error');
      flag = true;
      print(jsonDecode(res.body));
    }
    if(!flag) {
      http.Response res2 = await net.getRequest(
          urlLabel: 'me', token: token, params: '');
      if (res2.statusCode == 200) {
        // print(res2);
        print(res2.body);
        //write navigator push code here
      } else {
        print('server error');
        print(jsonDecode(res2.body));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
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
                child: TextFormField(
                  decoration: kInputDecoration.copyWith(hintText: 'Name'),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    widget.name = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Enter the name";
                    }
                    return null;
                  },
                  onSaved: (String name) {
                    widget.name = name;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: kInputDecoration.copyWith(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    widget.email = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Enter the email";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return 'Please enter valid Email';
                    }
                    return null;
                  },
                  onSaved: (String email) {
                    widget.email = email;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: kInputDecoration.copyWith(hintText: 'Password'),
                  onChanged: (value) {
                    widget.password = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Enter the Password";
                    } else if (value.length < 8) {
                      return "Password should be atleast 8 characters";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String password) {
                    widget.password = password;
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
                      Text('Gender : '),
                      Radio(
                          value: 'male',
                          groupValue: widget.gender,
                          onChanged: (value) {
                            setState(() {
                              widget.gender = value;
                            });
                          }),
                      Text('Male'),
                      SizedBox(
                        width: 20.0,
                      ),
                      Radio(
                          value: 'female',
                          groupValue: widget.gender,
                          onChanged: (value) {
                            setState(() {
                              widget.gender = value;
                            });
                          }),
                      Text('Female'),
                    ],
                  )),
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
                      if (_formkey.currentState.validate() && widget.dob!='' && widget.gender!='') {
                        registerUser();
                      } else {
                        print('Incomplete field');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
