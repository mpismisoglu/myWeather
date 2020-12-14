import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import 'city.dart';

void main() {
  runApp(Weather());
}

class Weather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final Geolocator geolocator = Geolocator();
  var minTemperatureForecast = new List(7);
  var maxTemperatureForecast = new List(7);
  var abbreviationForecast = new List(7);
  Position _currentPosition;
  String _currentAddress;
  int temperature;
  String location = "San Francisco";
  int woeid = 2487956;
  String weather = "clear";
  String abbreviation = "";
  String errorMessage = "";
  String searchApiUrl =
      "https://www.metaweather.com/api/location/search/?query=";
  String locationApiUrl = "https://www.metaweather.com/api/location/";

  @override
  void initState() {
    super.initState();
    fetchLocation();
    fetchLocationDay();
  }

  void fetchSearch(String input) async {
    try {
      var searchResult = await http.get(searchApiUrl + input);
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMessage = "";
      });
    } catch (error) {
      setState(() {
        errorMessage = "Sorry, we don't have data about this city";
      });
    }
  }

  void fetchLocation() async {
    var locationResult = await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];

    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(" ", "").toLowerCase();
      abbreviation = data["weather_state_abbr"];
    });
  }

  void fetchLocationDay() async {
    var today = new DateTime.now();
    for (var i = 0; i < 7; i++) {
      var locationDayResult = await http.get(locationApiUrl +
          woeid.toString() +
          "/" +
          new DateFormat("y/M/d")
              .format(today.add(new Duration(days: i + i)))
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

  void onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
    await fetchLocationDay();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      setState(() {
        _currentAddress =
            "${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].country}";
      });
      onTextFieldSubmitted(placemarks[0].locality);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'images/$weather.png',
            ),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop)),
      ),
      child: temperature == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.location_city),
                          onPressed: () {
                            _getCurrentLocation();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => City(
                                      name: location,
                                      temp: temperature,
                                    )));
                          },
                        ),
                      ],
                    ),
                  )
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Center(
                        child: Image.network(
                          "https://www.metaweather.com/static/img/weather/png/" +
                              abbreviation +
                              ".png",
                          width: 100,
                        ),
                      ),
                      Center(
                        child: Text(
                          temperature.toString() + " ˚C",
                          style: TextStyle(color: Colors.white, fontSize: 62),
                        ),
                      ),
                      Center(
                        child: Text(
                          location,
                          style: TextStyle(color: Colors.white, fontSize: 38),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (var i = 0; i < 4; i++)
                          forecastElement(
                              i + 1,
                              abbreviationForecast[i],
                              minTemperatureForecast[i],
                              maxTemperatureForecast[i]),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: TextField(
                          onSubmitted: (String input) {
                            onTextFieldSubmitted(input);
                          },
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          decoration: InputDecoration(
                              hintText: "Search another location...",
                              hintStyle: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

Widget forecastElement(
    daysFromNow, abbreviation, minTemperature, maxTemperature) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
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
