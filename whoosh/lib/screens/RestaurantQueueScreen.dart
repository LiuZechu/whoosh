import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' show json;

import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:whoosh/route/route_names.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/screens/QRCodeScreen.dart';
import 'package:whoosh/screens/RestaurantHeaderBuilder.dart';

import '../requests/GetRequestBuilder.dart';


// http://localhost:${port}/#/view-queue?restaurant_id=1 [OBSOLETE]
class RestaurantQueueScreen extends StatelessWidget {
  final String restaurantName;
  final int restaurantId;

  RestaurantQueueScreen(this.restaurantName, this.restaurantId);

  @override
  Widget build(BuildContext context) {
    var _settingsCallBack = () {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => RestaurantSettingsScreen(restaurantName, restaurantId)
          )
      );
    };

    var _qrCodeCallBack = () {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => QRCodeScreen(restaurantName, restaurantId)
          )
      );
    };

    return Scaffold(
      backgroundColor: Color(0xFF2B3148),
      body: ListView(
        children: [
          RestaurantHeaderBuilder.generateHeader(context, (){}, _settingsCallBack, _qrCodeCallBack),
          RestaurantQueueCard(restaurantId),
        ],
      ),
    );
  }

}

class RestaurantQueueCard extends StatefulWidget {
  final int restaurantId;

  RestaurantQueueCard(this.restaurantId);

  @override
  _RestaurantQueueCardState createState() => _RestaurantQueueCardState(restaurantId);
}

class _RestaurantQueueCardState extends State<RestaurantQueueCard> {
  final int restaurantId;
  String restaurantName;
  List<Group> groups = [];

  _RestaurantQueueCardState(this.restaurantId);

  @override void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  void fetchRestaurantDetails() async {
    Response response = await GetRequestBuilder()
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .sendRequest();
    List<dynamic> data = json.decode(response.body);
    String currentRestaurantName = data.single['restaurant_name'];
    if (this.mounted) {
      setState(() {
        restaurantName = currentRestaurantName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              generateRestaurantHeading(),
              generateWaitListHeading(),
              generateQueue(),
            ]
        )
    );
  }

  Widget generateRestaurantHeading() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('images/static/restaurant_icon.png'),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  constraints: BoxConstraints(minWidth: 0, maxWidth: 340),
                  child: Flexible(
                    child: Text(
                      restaurantName ?? 'Loading...',
                      style: TextStyle(
                        color: Color(0xFFEDF6F6),
                        fontSize: 25,
                        fontFamily: "VisbyCF",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget generateWaitListHeading() {
    return Container(
        width: 350,
        margin: const EdgeInsets.all(30.0),
        child: Text(
          'waitlist',
          style: TextStyle(
            color: Color(0xFFEDF6F6),
            fontSize: 40,
            fontFamily: "VisbyCF",
          ),
          textAlign: TextAlign.left,
        )
    );
  }

  Widget generateQueue() {
    fetchQueue();
    return Column(
        children: groups.map(
                (e) => e.createGroupRestaurantView(restaurantId, restaurantName)
        ).toList()
    );
  }

  void fetchQueue() async {
    List<dynamic> data = await WhooshService.getAllGroupsInQueue(restaurantId);
    List<Group> allGroups = data
        .where((group) => group['group_size'] <= 5)
        .toList()
        .map((group) => new Group(
          group['group_id'],
          group['group_name'],
          group['group_size'],
          DateTime.parse(group['arrival_time']),
          []) //TODO: change this
        ).toList();
    allGroups.sort((a, b) => a.timeOfArrival.compareTo(b.timeOfArrival));
    if (this.mounted) {
      setState(() {
        groups = allGroups;
      });
    }
  }

}