import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'city.dart';

Future getData(url) async {
  Response response = await get(url);
  return response.body;
}

var mins;
var maxs;
var abbrs;

fe() async {
  var data = await getData("http://10.0.2.2:5000/");
  var decodedData = jsonDecode(data);

  mins = (decodedData['min']);
  maxs = (decodedData['max']);
  abbrs = (decodedData['abbr']);
}

Widget forecastElement2(
    daysFromNow, abbreviation, minTemperature, maxTemperature) {
  var now = new DateTime.now();
  var oneYearFromNow = now.add(new Duration(days: daysFromNow));
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
              new DateFormat.y().format(oneYearFromNow),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              new DateFormat.MMMd().format(oneYearFromNow),
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
