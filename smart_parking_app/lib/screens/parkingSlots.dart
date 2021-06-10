import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:smart_parking_app/components/drawerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/screens/paymentScreen.dart';
import 'package:smart_parking_app/services/networking.dart';
import 'package:http/http.dart' as http;

class ParkingSlots extends StatefulWidget {
  ParkingSlots({this.body});
  final Map body;
  Timer timer;
  String code;

  @override
  _ParkingSlotsState createState() => _ParkingSlotsState();
}

class _ParkingSlotsState extends State<ParkingSlots> {
  List<Color> slotsColor = [
    kAvailable,
    kAvailable,
    kAvailable,
    kAvailable,
    kAvailable
  ];
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  Networking net = Networking();

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.Response res = await net.getRequest(
        urlLabel: 'sensorstatus', token: token, params: '');
    var details = jsonDecode(res.body)['body'];
    updateState(details);
    print('from getData');
  }

  void updateState(var details) {
    for (int i = 0; i < 5; i++) {
      slotsColor[i] = details[i]['reserved']
          ? kReserved
          : details[i]['value']
              ? kParked
              : kAvailable;
      // print(' slot $i = ${slotsColor[i]}');
    }
    setState(() {});
  }

  void dynamicUpdate() {
    getData();
    widget.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getData();
      // widget.timer = timer;
      // print('Running');
    });
  }

  void buttonSelection(
      {@required Color color,
      @required int slotNum,
      @required BuildContext context}) {
    if (color == kAvailable) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Reservation'),
          content: const Text(
              'Are you sure you want to reserve this parking spot? '),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Payment(
                      slotNum: slotNum,
                      body: widget.body,
                    );
                  }),
                );
                // Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (color == kReserved) {
      widget.timer.cancel();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Unlock the spot'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration:
                  kInputDecoration.copyWith(hintText: 'Enter your secret code'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.code = value;
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return "Enter the code";
                } else if (value.length != 4) {
                  return "Enter valid code";
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  // print('validated');
                  String token = prefs.getString('token');
                  http.Response res = await net.getRequest(
                      urlLabel: 'release',
                      params: 'spot=${slotNum.toString()}&code=${widget.code}',
                      token: token);
                  print(jsonDecode(res.body));
                  if (res.statusCode == 200) {
                    Navigator.pop(context, 'OK');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Spot released'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              dynamicUpdate();
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else if (res.statusCode == 400) {
                    Navigator.pop(context, 'OK');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Invalid code'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.pop(context, 'OK');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Server error'),
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
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('This parking spot is already occupied'),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
    getData();
    dynamicUpdate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPageBackground,
        actions: [
          MaterialButton(
            onPressed: () {
              getData();
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: DrawerScreen(
        data: widget.body,
      ),
      backgroundColor: kPageBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      color: kAvailable,
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' - Available',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      color: kReserved,
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' - Reserved',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      color: kParked,
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' - Parked',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration: kParkingLotEdgeDesign.copyWith(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(80))),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration: kParkingLotEdgeDesign.copyWith(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(80))),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: kParkingLotSlotLeftDesign.copyWith(
                          color: slotsColor[2]),
                    ),
                    onTap: () {
                      buttonSelection(
                          color: slotsColor[2], context: context, slotNum: 3);
                    }),
                SizedBox(
                  width: 100,
                ),
                GestureDetector(
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: kParkingLotSlotRightDesign.copyWith(
                          color: slotsColor[1]),
                    ),
                    onTap: () {
                      buttonSelection(
                          color: slotsColor[1], context: context, slotNum: 2);
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: kParkingLotSlotLeftDesign.copyWith(
                          color: slotsColor[3]),
                    ),
                    onTap: () {
                      buttonSelection(
                          color: slotsColor[3], context: context, slotNum: 4);
                    }),
                SizedBox(
                  width: 100,
                ),
                GestureDetector(
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: kParkingLotSlotRightDesign.copyWith(
                          color: slotsColor[0]),
                    ),
                    onTap: () {
                      buttonSelection(
                          color: slotsColor[0], context: context, slotNum: 1);
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: kParkingLotSlotLeftDesign.copyWith(
                          color: slotsColor[4]),
                    ),
                    onTap: () {
                      buttonSelection(
                          color: slotsColor[4], context: context, slotNum: 5);
                    }),
                SizedBox(
                  width: 100,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                      // borderRadius:
                      //     BorderRadius.only(topLeft: Radius.circular(80)),
                      border: Border(
                    top: BorderSide.none,
                    bottom: BorderSide(width: 3, color: Colors.grey),
                  )),
                  child: Center(
                      child: Text(
                    'ENTRY',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration: kParkingLotEdgeDesign.copyWith(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(80))),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                      // borderRadius:
                      //     BorderRadius.only(topLeft: Radius.circular(80)),
                      border: Border(
                    top: BorderSide.none,
                    bottom: BorderSide(width: 3, color: Colors.grey),
                  )),
                  child: Center(
                      child: Text(
                    'EXIT',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHOOSE YOUR PARKING SLOT',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
