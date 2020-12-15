import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class City extends StatefulWidget {
  @override
  final String name;
  final int temp;
  final int woeid;
  var temperature = 0;

  City(
      {Key key, @required this.name, @required this.temp, @required this.woeid})
      : super(key: key);

  State<City> createState() {
    return _CityState();
  }
}

class _CityState extends State<City> {
  var minTemperatureForecast = new List(7);
  var maxTemperatureForecast = new List(7);
  var abbreviationForecast = new List(7);
  String locationApiUrl = "https://www.metaweather.com/api/location/";

  @override
  void initState() {
    super.initState();
    fetchLocationDay();
  }

  void fetchLocationDay() async {
    var today = new DateTime.now();
    for (var i = 0; i < 7; i++) {
      var locationDayResult = await http.get(locationApiUrl +
          widget.woeid.toString() +
          "/" +
          new DateFormat("y/M/d")
              .format(today.subtract(new Duration(days: (i + 1) * 365)))
              .toString());
      var result = json.decode(locationDayResult.body);
      var data = result[0];
      setState(() {
        minTemperatureForecast[i] = data["min_temp"].round();
        maxTemperatureForecast[i] = data["max_temp"].round();
        abbreviationForecast[i] = data["weather_state_abbr"];
      });
    }
  }

  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'images/clear.png',
            ),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "fdd",
                  style: TextStyle(fontSize: 26),
                ),
                Text(
                  "fsafa",
                  style: TextStyle(fontSize: 26),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      for (var i = 0; i < 7; i++)
                        forecastElement(
                            (i + 1) * 365,
                            abbreviationForecast[i],
                            minTemperatureForecast[i],
                            maxTemperatureForecast[i]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget forecastElement(
    daysFromNow, abbreviation, minTemperature, maxTemperature) {
  var now = new DateTime.now();
  var oneDayFromNow = now.subtract(new Duration(days: daysFromNow));
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
              new DateFormat.y().format(oneDayFromNow),
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
