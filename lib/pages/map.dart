import 'package:flutter/material.dart';

import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

@override
initState() {
  _getLocation();
}

_getLocation() async {
  var location = new Location();

  if (await location.requestPermission()) {
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });
  }
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rive'
        ),
      ),
    );
  }
}