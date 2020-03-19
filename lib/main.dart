import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;

void main() async {
  _data = await getEarthquakeJsonApi();
  _features = _data['features'];
  runApp(MaterialApp(
    title: "Earthquakes",
    home: new EarthQuakes(),
  ));
}

class EarthQuakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Earthquakes around the world"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return Divider();
              final index = position ~/ 2;
              var format = new DateFormat.yMMMd("en_US").add_jm();
              var _date = format.format(DateTime.fromMillisecondsSinceEpoch(
                _features[index]['properties']['time'],
                isUtc: true,
              ));
              return ListTile(
                title: new Text(
                  "At: "
                  "$_date",
                  style: new TextStyle(
                      fontSize: 19.5,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: new Text(
                  "${_features[index]["properties"]["place"]}",
                  style: new TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  child: new Text(
                    "${_features[index]['properties']['mag']}",
                    style: new TextStyle(
                      fontSize: 16.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: (){_showAlertMessege(context, "${_features[index]['properties']['title']}");},
              );
            }),
      ),
    );
  }

  void _showAlertMessege(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text("Quakes"),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Text("OK")),
      ],
    );
    showDialog(context: context , child: alert);
  }
}

Future<Map> getEarthquakeJsonApi() async {
  final String URL =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(URL);
  return json.decode(response.body);
}
