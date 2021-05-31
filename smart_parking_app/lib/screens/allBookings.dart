import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/components/drawerScreen.dart';
import 'package:smart_parking_app/services/networking.dart';

class BookingScreen extends StatefulWidget {

  final Map body;
  BookingScreen({this.body});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  SharedPreferences prefs;
  Networking net = Networking();

  Future<List> getUserBookings() async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.Response res =
        await net.getRequest(urlLabel: 'myorders', token: token, params: '');
    var detailsArray = jsonDecode(res.body);
    List details = detailsArray['body'];
    return details;

  }

  void initState() {
    super.initState();
    getUserBookings();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        drawer: DrawerScreen(
          data: widget.body,
        ),
        body: FutureBuilder(
          future: getUserBookings(),
          builder: (context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting : return new SpinKitDoubleBounce(
                color: Colors.blue,
              );
              default : if(snapshot.hasError){
                print(snapshot.error);
                return null;
              }else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
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
                                    Text(snapshot.data[index]['spot_number'].toString(),
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue
                                      ),
                                    ),

                                    Text(snapshot.data[index]['code'].toString(),
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
                                    Text(snapshot.data[index]['createdAt'].toString().substring(0,10),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Text(snapshot.data[index]['createdAt'].toString().substring(11,16),
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
                );
              }
            }
          },
        ),

      ),
    );
  }
}
