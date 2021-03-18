import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final url = "https://api.openweathermap.org/data/2.5/weather?";
final apiKey = "2fd384e461c1c6db3ff100aa86d77287";

class _HomeState extends State<Home> {
  bool isLoading = true;
  var weatherData;

  getWeather(lat, lon) async {
    try {
      await http.get(url + "lat=$lat&lon=$lon&appid=$apiKey").then(
            (res) => weatherData = jsonDecode(res.body),
          );
      if (weatherData['cod'] == 200) {
        print(weatherData['weather'][0]['main']); //weather[0].main
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print(weatherData['cod']);
      }
    } catch (error) {
      print(error);
    }
  }

  getLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Permission.location.request().isGranted) {
        LocationData location = await Location().getLocation();
        getWeather(location.latitude, location.longitude);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightGreen,
      home: Scaffold(
        backgroundColor: Colors.lightGreen,
        body: SafeArea(
          child: Container(
            child: Center(
              child: isLoading
                  ? Image.asset("assets/image-1.jpg")
                  : TextButton(
                      onPressed: () {
                        getWeather("9.1485", "77.8321");
                      },
                      child: Text(
                        weatherData == null
                            ? "Click me!"
                            : weatherData['weather'] == null
                                ? weatherData['cod'].toString()
                                : weatherData['weather'][0]['main'].toString(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
