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
  Networking net = Networking();

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.Response res =
        await net.getRequest(urlLabel: 'test', token: token, params: '');
    var details = jsonDecode(res.body)['body'];
    updateState(details);
  }

  void updateState(var details) {
    for (int i = 0; i < 5; i++) {
      slotsColor[i] = details[i]['reserved']
          ? kReserved
          : details[i]['value']
              ? kParked
              : kAvailable;
      print(' slot $i = ${slotsColor[i]}');
    }
    setState(() {});
  }

  void dynamicUpdate() {
    getData();
    widget.timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getData();
      // widget.timer = timer;
      print('Running');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Payment();
                    }),);
                  },
                ),
                SizedBox(
                  width: 100,
                ),
                GestureDetector(
                  child: Container(
                    width: 120,
                    height: 80,
                    decoration:
                        kParkingLotSlotRightDesign.copyWith(color: slotsColor[1]),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Payment();
                    }),);
                  },
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
                    decoration:
                        kParkingLotSlotLeftDesign.copyWith(color: slotsColor[3]),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Payment();
                    }),);
                  },
                ),
                SizedBox(
                  width: 100,
                ),
                GestureDetector(
                  child: Container(
                    width: 120,
                    height: 80,
                    decoration:
                        kParkingLotSlotRightDesign.copyWith(color: slotsColor[0]),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Payment();
                    }),);
                  },
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
                    decoration:
                        kParkingLotSlotLeftDesign.copyWith(color: slotsColor[4]),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Payment();
                    }),);
                  },
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
