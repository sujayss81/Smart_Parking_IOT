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
  }

  void initState() {
    super.initState();
    initSharedPref();
  }


  Widget getAvatar() {
    userDetails = widget.body;
    String gender = userDetails['gender'];
    if (gender.toLowerCase() == 'male') {
      return Image(
        image: AssetImage('images/male.jpg'),
        height: 140.0,
        width: 140,
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        drawer: DrawerScreen(data: userDetails),
        body: Card(
          color: Colors.blue,
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    userDetails['name'],
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.mail,
                    color: Colors.grey,
                  ),
                  title: Text(
                    userDetails['email'],
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  title: Text(
                    'Birthdate : ${userDetails['dob']}',
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
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
