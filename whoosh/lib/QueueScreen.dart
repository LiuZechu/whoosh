import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:http/http.dart';

class QueueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E6F2),
      body: ListView(
        children: [
          generateHeader(),
          generateRestaurantName(),
          generateWaitTime(),
          QueueCard(),
        ],
      ),
    );
  }

  Widget generateHeader() {
   return AppBar(
     leading: Transform.scale(
       scale: 3,
       alignment: Alignment.centerLeft,
       child: IconButton(
         icon: new Image.asset(
           'images/logo.png',
         ),
         tooltip: 'return to homepage',
         onPressed: () {},
       ),
     ),
     actions: [
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 16),
         child: Icon(Icons.menu),
       ),
     ],
     backgroundColor: Color(0xFF376ADB),
   );
  }

  Widget generateRestaurantName() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'you\'re queueing for',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "VisbyCF"
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('images/restaurant-icon.png'),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Text(
                  'Genki Sushi',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "VisbyCF",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget generateWaitTime() {
    return Container(
      child: Column(
        children: [
          Text(
            'estimated wait:',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "VisbyCF"
            ),
          ),
          Text(
            '10 - 15 min',
            style: TextStyle(
              fontSize: 42,
              fontFamily: "VisbyCF",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class QueueCard extends StatefulWidget {
  @override
  _QueueCardState createState() => _QueueCardState();
}

class _QueueCardState extends State<QueueCard> {
  List<int> groups = [];

  void fetchQueue() async {
    Response response = await http.get('https://whoosh-server.herokuapp.com/queue');
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> allGroups = data['results'];
    List<int> result = allGroups
        .map((e) => e['status'] as int)
        .toList();
    setState(() {
      groups = result;
    });
  }

  Widget generateQueue() {
    var allGroups = fetchQueue();
    return Column(
        children: groups
            .map((e) =>
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
                ),
                alignment: Alignment.center,
                child: Text(e.toString() + ' person')
              )
            ).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateQueue(),
    );
  }

}

