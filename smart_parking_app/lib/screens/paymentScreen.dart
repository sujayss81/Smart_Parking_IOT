import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_app/services/networking.dart';

class Payment extends StatefulWidget {
  Payment({this.slotNum});
  final int slotNum;
  String name = '';
  int cardNo;

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String name = '';
  Networking net = Networking();
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initState() {
    super.initState();
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Source Sans Pro',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      Text(
                        'Rs.10.00',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        kInputDecoration.copyWith(hintText: 'Name on card'),
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      widget.name = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Enter the valid name";
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
                    decoration:
                        kInputDecoration.copyWith(hintText: 'Card Number'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      widget.cardNo = int.tryParse(value);
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Enter the valid card number";
                      } else if (value.length != 16) {
                        return "Enter the valid card number";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (cardNo) {
                      widget.cardNo = int.tryParse(cardNo);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: kDateCvv.copyWith(
                              hintText: 'Expiry Date(MM-YYYY)'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            widget.cardNo = int.tryParse(value);
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Enter the expiry date";
                            } else if (!RegExp("^[0-9]{2}-[0-9]{4}")
                                .hasMatch(value)) {
                              return "Enter date in format MM-YYYY";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (cardNo) {
                            widget.cardNo = int.tryParse(cardNo);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: TextFormField(
                          decoration: kDateCvv.copyWith(hintText: 'CVV'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            widget.cardNo = int.tryParse(value);
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Enter the CVV";
                            } else if (value.length != 3) {
                              return "Enter valid CVV";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (cardNo) {
                            widget.cardNo = int.tryParse(cardNo);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (true) {
                        String token = prefs.getString('token');
                        http.Response res = await net.getRequest(
                            urlLabel: 'reserve',
                            token: token,
                            params: 'spot=${widget.slotNum}');
                        if (res.statusCode == 200) {
                          var body = jsonDecode(res.body);
                          print(body);
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Reserved'),
                              content: Text(
                                  'Your code for the parking spot is ${body['code']}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
