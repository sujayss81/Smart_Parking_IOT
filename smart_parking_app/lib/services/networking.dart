import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/constants.dart';

class Networking {
  Future<http.Response> getRequest(
      {@required String urlLabel, String token, String params}) async {
    String url = '$hostUrl/$urlLabel?$params';
    http.Response res = await http.get(Uri.parse(url),
        headers: {'x-auth-token': token, 'Content-Type': 'application/json'});
    return res;
  }

  Future<http.Response> postRequest(
      {@required String urlLabel, Map body}) async {
    String sendingBody = jsonEncode(body);
    print(sendingBody);
    String token;
    http.Response res = await http.post(Uri.parse('$hostUrl/$urlLabel'),
        body: sendingBody, headers: {'Content-Type': 'application/json'});
    var resBodyString = jsonDecode(res.body);
    return res;
  }
}
