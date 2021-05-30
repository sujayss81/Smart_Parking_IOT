import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/screens/allBookings.dart';
import 'package:smart_parking_app/screens/homePage.dart';
import 'package:smart_parking_app/screens/loginScreen.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:smart_parking_app/screens/parkingSlots.dart';

class DrawerScreen extends StatefulWidget {
  final Map data;
  DrawerScreen({this.data});
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  SharedPreferences prefs;
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
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  child: Image(
                    image: AssetImage('images/iconCar.png'),
                    height: 190.0,
                    width: 200.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
                leading: Icon(
                  Icons.person,
                  // size: 30,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(
                            body: widget.data,
                          )));
                  // Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('View Parking slots',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ParkingSlots(body: widget.data)));
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text(
                'My Bookings',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BookingScreen(
                          body: widget.data,
                        )));
              },
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new_rounded),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                ),
              ),
              onTap: () {
                prefs.remove('token');
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}