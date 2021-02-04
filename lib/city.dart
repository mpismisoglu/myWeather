import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'forecast2.dart';
import "prediction.dart";
import 'forecast3.dart';

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
  var bool = false;
  var month1;
  var month2;
  var month3;

  String locationApiUrl = "https://www.metaweather.com/api/location/";

  @override
  void initState() {
    super.initState();
    fetchLocationDay();
  }

  void predict1() async {
    var result =
        await http.get("https://60089720309f8b0017ee62d5.mockapi.io/flutter");
    var resulted = json.decode(result.body);
    var x = resulted.length;
    var data = resulted[x - 1];

    setState(() {
      month1 = data["temp1"];
      month2 = data["temp2"];
      month3 = data["temp3"];
    });
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
      predict1();
    }

    setState(() {
      bool = true;
    });
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
      child: bool == false
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.woeid == 2344117 ? "Izmir" : widget.name,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            forecastWidget3(
                              predtemp: "$month1",
                              mon: "1",
                            ),
                            forecastWidget3(
                              predtemp: "$month2",
                              mon: "2",
                            ),
                            forecastWidget3(
                              predtemp: "$month3",
                              mon: "3",
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (var i = 0; i < 7; i++)
                              forecastWidget2(
                                  daysFromNow: (i + 1) * 365,
                                  hoursFromNow: (i + 1) * 6,
                                  abbreviation: abbreviationForecast[i],
                                  minTemperature: minTemperatureForecast[i],
                                  maxTemperature: maxTemperatureForecast[i]),
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
