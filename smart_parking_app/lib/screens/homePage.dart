import 'package:flutter/material.dart';
import 'package:smart_parking_app/components/drawerScreen.dart';
import 'package:smart_parking_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final Map body;
  HomePage({this.body});
  static const id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prefs;
  Map userDetails;
  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // sharedPrefDemo();
  }

  void initState() {
    super.initState();
    initSharedPref();
  }

  void sharedPrefDemo() {
    String token = prefs.getString('token');
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    userDetails = widget.body;
    print('This is from homePage = ${widget.body}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerScreen(),
      body: Scaffold(),
    );
  }
}
