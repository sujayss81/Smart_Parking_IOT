import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/components/drawerScreen.dart';
import 'package:smart_parking_app/services/networking.dart';

class BookingScreen extends StatefulWidget {
  final Map body;
  BookingScreen({this.body});
  var details;
  var count;
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  SharedPreferences prefs;
  Networking net = Networking();

  void getUserBookings() async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.Response res =
        await net.getRequest(urlLabel: 'myorders', token: token, params: '');
    print(jsonDecode(res.body));
    var detailsArray = jsonDecode(res.body);
    // widget.count = detailsArray['count'];
    // widget.details = detailsArray['body'];
    // print(widget.details);
    print(detailsArray);
  }

  void initState() {
    super.initState();
    getUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    var details = widget.details;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        drawer: DrawerScreen(
          data: widget.body,
        ),
        // body: ListView.builder(
        //   itemCount: widget.count,
        //   itemBuilder: (context, index) {
        //     print('count=${widget.count}');
        //     return Card(
        //       child: Text('hello'),
        //     );
        //   },
        // ),
      ),
    );
  }
}
