import 'package:flutter/material.dart';
import 'package:smart_parking_app/constants.dart';

class ParkingSlots extends StatefulWidget {
  @override
  _ParkingSlotsState createState() => _ParkingSlotsState();
}

class _ParkingSlotsState extends State<ParkingSlots> {
  Color slot1Color = kAvailable;
  Color slot2Color = kAvailable;
  Color slot3Color = kAvailable;
  Color slot4color = kAvailable;
  Color slot5color = kAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration:
                        kParkingLotSlotLeftDesign.copyWith(color: slot1Color),
                  ),
                  onTap: () {
                    setState(() {
                      slot1Color = kParked;
                    });
                  },
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration:
                      kParkingLotSlotRightDesign.copyWith(color: slot4color),
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
                  decoration:
                      kParkingLotSlotLeftDesign.copyWith(color: slot2Color),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  width: 120,
                  height: 80,
                  decoration:
                      kParkingLotSlotRightDesign.copyWith(color: slot5color),
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
                  decoration:
                      kParkingLotSlotLeftDesign.copyWith(color: slot3Color),
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
