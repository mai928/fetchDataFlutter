import 'dart:convert';

import 'package:fetch_data_article/Details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class allData extends StatefulWidget {
const allData({Key? key}) : super(key: key);
@override
State<allData> createState() => _allDataState();
}

class Data {
  String id;
  String title;
  String picture;
  String content;

  Data(this.id, this.title, this.picture, this.content);

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(json['id'], json['title'], json['picture'], json['content']);
  }
}

class _allDataState extends State<allData> {
  late Future<List<Data>> postDate;
  @override
  initState() {
    super.initState();
    postDate = GetAllData().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "All data from api",
            style: TextStyle(fontSize: 20),
          )),
      body: FutureBuilder(
        future: postDate,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _data = (snapshot.data as List<Data>);
            return ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) => DataListItem(_data[index]));
          } else if (snapshot.hasError) {
            return Container(
              child: Center(child: Text('has error')),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class GetAllData {
  Future<List<Data>> fetchData() async {
    var response = await http.get(
        Uri.parse('https://62d4154fcd960e45d452f790.mockapi.io/api/article'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(response.body);

      var list = (jsonResponse as List);
      var newList = list.map((item) => Data.fromJson(item)).toList();
      return newList;
    } else {
      throw Exception('Can not fetch data');
    }
  }
}

class DataListItem extends StatelessWidget {
  var _data;
  DataListItem(this._data);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      child: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(_data.picture),
              title: Text(_data.title),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Details(_data.title, _data.content)));
              },
            ),
          ),
        ),
      ),
    );
  }
}
