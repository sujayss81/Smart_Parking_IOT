import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const hostUrl = 'http://sujayhome.ddns.net:4000/';

class Networking {
  Future postRequest({String urlLabel, Map body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token == null) {
      String sendingBody = jsonEncode(body);
      http.Response res =
          await http.post(Uri.parse('$hostUrl/$urlLabel'), body: sendingBody);
      if (res.statusCode == 200) {}
    }
  }
}
