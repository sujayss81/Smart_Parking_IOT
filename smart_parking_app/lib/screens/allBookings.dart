import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/components/drawerScreen.dart';
import 'package:smart_parking_app/services/networking.dart';

class BookingScreen extends StatefulWidget {
  List<Map> detailsList= [];
  final Map body;
  BookingScreen({this.body});
  List details;
  int count;
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
    // print(jsonDecode(res.body));
    var detailsArray = jsonDecode(res.body);
    List details = detailsArray['body'];
    // widget.count = detailsArray['count'];
    widget.details = details;
    // for(int i=0 ; i<widget.count ; i++)
    //   {
    //     widget.detailsList.add(detailsArray['body'][i]);
    //   }
    print(details);
    // print(detailsArray);
    setState(() {});
  }

  void initState() {
    super.initState();
    getUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    var details = widget.details;
    print(widget.count);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        drawer: DrawerScreen(
          data: widget.body,
        ),
        body: ListView.builder(
          itemCount: widget.details.length,
          itemBuilder: (context, index) {
            print('details=${widget.details}');
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 5,
                color: Colors.grey[200],
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Parking Slot',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                            ),

                            Text('Code',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.details[index]['spot_number'].toString(),
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),
                            ),

                            Text(widget.details[index]['code'].toString(),
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.details[index]['createdAt'].toString().substring(0,10),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                            ),
                            Text(widget.details[index]['createdAt'].toString().substring(11,16),
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
