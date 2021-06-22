import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

void main() async {
  Map<String, dynamic> data;
  data = await getData();
  List<dynamic> quakeData = data['features'];
  var format = DateFormat.yMMMMd().add_jm();
  print(quakeData[1]['properties']['title']);

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Quakes'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.separated(
        itemCount: quakeData.length,
        padding: EdgeInsets.only(top: 16.0, left: 2.0),
        itemBuilder: (BuildContext context, index) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              quakeData[index]['properties']['time'],
              isUtc: false);
          return ListTile(
            onTap: () {
              showAlert(context, quakeData[index]['properties']['title']);
            },
            title: Text(format.format(date)),
            subtitle: Text(quakeData[index]['properties']['place']),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black54,
              child: Text(
                quakeData[index]['properties']['mag'].toString(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.black,
          );
        },
      ),
    ),
  ));
}

Future<Map<String, dynamic>> getData() async {
  var url =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response res = await http.get(Uri.parse(url));
  return jsonDecode(res.body);
}

void showAlert(BuildContext context, String title) {
  var alert = AlertDialog(
    title: Text('Quakes'),
    content: Text(title),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'))
    ],
  );
  showDialog(builder: (context) => alert, context: context);
}
