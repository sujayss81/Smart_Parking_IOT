import 'package:flutter/material.dart';

const kInputDecoration = InputDecoration(
  hintText: 'value',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      borderSide: BorderSide()),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.0,
      )),
  // focusedBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(32),
  //     ),
  //     borderSide: BorderSide(
  //       color: Colors.blueAccent,
  //       width: 2.0,
  //     )),
);
