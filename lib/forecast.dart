import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class forecastWidget extends StatelessWidget {
  @override
  final int daysFromNow;
  final String abbreviation;
  final int minTemperature;
  final int maxTemperature;

  forecastWidget(
      {Key key,
      @required this.daysFromNow,
      @required this.abbreviation,
      @required this.minTemperature,
      @required this.maxTemperature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final oneDayFromNow = now.add(new Duration(days: daysFromNow));
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
                new DateFormat.E().format(oneDayFromNow),
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Text(
                new DateFormat.MMMd().format(oneDayFromNow),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Image.network(
                  "https://www.metaweather.com/static/img/weather/png/" +
                      abbreviation +
                      ".png",
                  width: 50,
                ),
              ),
              Text(
                "High: " + maxTemperature.toString() + " ˚C",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "Low: " + minTemperature.toString() + " ˚C",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
