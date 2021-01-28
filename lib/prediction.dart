import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String locationApiUrl = "https://www.metaweather.com/api/location/";
var minTemperatureForecast = new List(60);
var maxTemperatureForecast = new List(60);

void predict(woeid) async {
  var today = new DateTime.now();
  for (var i = 0; i < 60; i++) {
    var locationDayResult = await http.get(locationApiUrl +
        woeid.toString() +
        "/" +
        new DateFormat("y/M/d")
            .format(today.subtract(new Duration(days: (i + 1) * 30)))
            .toString());
    var result = json.decode(locationDayResult.body);
    var data = result[0];

    minTemperatureForecast[i] = data["min_temp"].round();
    maxTemperatureForecast[i] = data["max_temp"].round();
  }
  print(minTemperatureForecast);
}

Future<http.Response> createAlbum(String title) {
  return http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
}

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> createAlbum1(String title) async {
  final http.Response response = await http.post(
    'https://60089720309f8b0017ee62d5.mockapi.io/ID',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "id": "42",
      'woeid': title,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print("oldu");
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
