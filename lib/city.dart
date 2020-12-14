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
  City({Key key, @required this.name, @required this.temp}) : super(key: key);

  State<City> createState() {
    return _CityState();
  }
}

class _CityState extends State<City> {
  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        height: Height,
        width: Width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/glass.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                widget.name,
                style: TextStyle(fontSize: 26),
              ),
              Text(
                widget.temp.toString(),
                style: TextStyle(fontSize: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
