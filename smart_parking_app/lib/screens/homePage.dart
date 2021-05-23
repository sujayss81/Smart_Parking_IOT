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
  //
  // void sharedPrefDemo() {
  //   String token = prefs.getString('token');
  //   print(token);
  // }

  Widget getAvatar() {
    Map userDetails = widget.body;
    String gender = userDetails['gender'];
    if (gender == 'male') {
      return Image(
        image: AssetImage('images/male.jpg'),
        height: 190.0,
        width: 200,
      );
    } else {
      return Image(
        image: AssetImage('images/female.jpg'),
        height: 140.0,
        width: 140,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userDetails = widget.body;
    print('This is from homePage = ${widget.body}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerScreen(data: userDetails),
      body: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFFF2F2F2),
                child: getAvatar(),
                radius: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
