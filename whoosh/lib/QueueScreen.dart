import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' show json;

import 'package:whoosh/Group.dart';

class QueueScreen extends StatelessWidget {
  final int restaurantId;
  final int groupId;
  // http://localhost:54138/#/queue?restaurant_id=&group_id=1
  QueueScreen(this.restaurantId, this.groupId);

  @override
  Widget build(BuildContext context) {
    log(restaurantId.toString());
    log(groupId.toString());
    return Scaffold(
      backgroundColor: Color(0xFFD1E6F2),
      body: ListView(
        children: [
          generateHeader(),
          QueueCard(restaurantId, groupId),
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

}

class QueueCard extends StatefulWidget {
  final int restaurantId;
  final int currentGroupId;

  QueueCard(this.restaurantId, this.currentGroupId);

  @override
  _QueueCardState createState() => _QueueCardState(restaurantId, currentGroupId);
}

class _QueueCardState extends State<QueueCard> {
  List<Group> groups = [];
  final int restaurantId;
  final int currentGroupId;

  _QueueCardState(this.restaurantId, this.currentGroupId);

  @override void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchQueue() async {
    // TODO:
    // Take current queue, exclude me
    // remove all groups later than me (identify by id)
    // sort all groups from last to join to first to join (reversed)
    // add me to the front of the list (back of the queue)
    String url = 'https://whoosh-server.herokuapp.com/restaurants/'
        + restaurantId.toString()
        +'/groups';
    Response response = await http.get(url);
    List<dynamic> data = json.decode(response.body);
    List<Group> result = data
        .where((group) => group['group_size'] <= 5 && group['queue_status'] == 0)
        .toList()
        .map((group) => new Group(
          group['group_id'],
          group['group_name'],
          group['group_size'],
          //DateTime.parse("1969-07-20 20:18:04Z")))
          DateTime.parse(group['arrival_time']))
        ).toList();
    setState(() {
      groups = result;
    });
  }

  Widget generateQueue() {
    fetchQueue();
    return Column(
        children: groups.map(
                (e) => e.id == currentGroupId
                    ? e.createCurrentGroupImage(groups.length - 1)
                    : e.createOtherGroupImage()
        ).toList()
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
                fontSize: 18,
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
                    fontSize: 36,
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
                fontSize: 18,
                fontFamily: "VisbyCF"
            ),
          ),
          Text(
            '10-15 min',
            style: TextStyle(
              fontSize: 64,
              fontFamily: "VisbyCF",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          generateRestaurantName(),
          generateWaitTime(),
          generateQueue(),
        ]
      )
    );
  }
}

