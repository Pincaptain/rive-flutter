import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MapPageState();

}

class MapPageState extends State<MapPage> {

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          'Rive'
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
      ),
      floatingActionButton: Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(left: 30),
        child: RaisedButton(
          onPressed: () {},
          child: Text(
            'Ride',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          color: Colors.teal[400],
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

}