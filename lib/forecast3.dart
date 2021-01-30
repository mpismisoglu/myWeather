import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'prediction.dart';

class forecastWidget3 extends StatelessWidget {
  @override
  final String predtemp;
  final String mon;

  forecastWidget3({Key key, @required this.predtemp, @required this.mon})
      : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(205, 212, 228, 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                "$mon month later",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              ),
              Text(
                "Predicted: " + predtemp + " ˚C",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
