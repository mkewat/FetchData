import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Demo(),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DemoState();
  }
}

class DemoState extends State<Demo> {
  Future<List<ListData>> listDataJSON() async {
    final jsonEndpoint = "https://jsonplaceholder.typicode.com/photos";
    final response = await get(jsonEndpoint);
    if (response.statusCode == 200) {
      List listData = json.decode(response.body);
      return listData
          .map((listData) => new ListData.fromJson(listData))
          .toList();
    } else {
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data/Json'),
      ),
      body: FutureBuilder<List<ListData>>(
          future: listDataJSON(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int currentIndex) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data[currentIndex].thumbnailUrl),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              width: 280.0,
                              child: Text(
                                snapshot.data[currentIndex].title,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    );
                  });
            }
          }),
    );
  }
}

class ListData {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;
  ListData({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  factory ListData.fromJson(Map<String, dynamic> jsonData) {
    return ListData(
      albumId: jsonData['albumId'],
      id: jsonData['id'],
      title: jsonData['title'],
      url: jsonData['url'],
      thumbnailUrl: jsonData['thumbnailUrl'],
    );
  }
}
