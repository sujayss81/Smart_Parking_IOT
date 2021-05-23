import 'package:flutter/material.dart';

class ParkingSlots extends StatefulWidget {
  const ParkingSlots({Key key}) : super(key: key);

  @override
  _ParkingSlotsState createState() => _ParkingSlotsState();
}

class _ParkingSlotsState extends State<ParkingSlots> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
