import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:http/http.dart';
import 'package:whoosh/Group.dart';

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
                Image(image: AssetImage('images/restaurant_icon.png'),
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
  List<Group> groups = [];
  int currentGroupId = 1;

  void fetchQueue() async {
    // TODO:
    // Take current queue, exclude me
    // remove all groups later than me (identify by id)
    // sort all groups from last to join to first to join (reversed)
    // add me to the front of the list (back of the queue)
    // Response response = await http.get('https://whoosh-server.herokuapp.com/queue');
    // Map<String, dynamic> data = json.decode(response.body);
    // List<dynamic> allGroups = data['results'];
    List<int> allGroups = [0, 1, 2, 3, 4, 5];
    List<Group> result = allGroups
        //.map((e) => e['status'] as int)
        .map((groupSize) => new Group(1, 'salmon', groupSize, DateTime.parse("1969-07-20 20:18:04Z")))
        .toList();
    setState(() {
      groups = result;
    });
  }

  Widget generateQueue() {
    fetchQueue();
    return Column(
        children: groups.map((e) => e.createGroupImage(e.id == currentGroupId)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateQueue(),
    );
  }

}

