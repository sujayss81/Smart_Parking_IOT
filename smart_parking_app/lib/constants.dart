import 'package:flutter/material.dart';

const hostUrl = 'http://sujayhome.ddns.net:4000';

//parking slot colors
const kAvailable = Colors.green;
const kReserved = Colors.amberAccent;
const kParked = Colors.red;
const kPageBackground = Color(0xff1A1C22);

const kInputDecoration = InputDecoration(
  hintText: 'value',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      borderSide: BorderSide()),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.0,
      )),
  // focusedBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(32),
  //     ),
  //     borderSide: BorderSide(
  //       color: Colors.blueAccent,
  //       width: 2.0,
  //     )),
);

const kParkingLotEdgeDesign = BoxDecoration(
    borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
    border: Border(
      top: BorderSide(color: Colors.grey, width: 2),
      left: BorderSide(color: Colors.grey, width: 2),
      right: BorderSide(color: Colors.grey, width: 2),
      bottom: BorderSide(color: Colors.grey, width: 2),
    ));

const kParkingLotSlotLeftDesign = BoxDecoration(
    color: null,
    border: Border(
      left: BorderSide(width: 3, color: Colors.grey),
      top: BorderSide.none,
      bottom: BorderSide(width: 3, color: Colors.grey),
    ));

const kParkingLotSlotRightDesign = BoxDecoration(
// borderRadius:
//     BorderRadius.only(topLeft: Radius.circular(80)),
  border: Border(
// left: BorderSide(width: 3, color: Colors.grey),
// top: BorderSide.none,
    bottom: BorderSide(width: 3, color: Colors.grey),
    right: BorderSide(width: 3, color: Colors.grey),
  ),
);

const kDateCvv = InputDecoration(
  hintText: 'value',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      borderSide: BorderSide()),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.0,
      )),
  // focusedBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(32),
  //     ),
  //     borderSide: BorderSide(
  //       color: Colors.blueAccent,
  //       width: 2.0,
  //     )),
);
