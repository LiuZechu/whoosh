import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' show json;

import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/route/route_names.dart';

import '../requests/GetRequestBuilder.dart';

class RestaurantQueueScreen extends StatelessWidget {
  final int restaurantId;
  RestaurantQueueScreen(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E6F2),
      body: ListView(
        children: [
          generateHeader(),
          RestaurantQueueCard(restaurantId),
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

class RestaurantQueueCard extends StatefulWidget {
  final int restaurantId;

  RestaurantQueueCard(this.restaurantId);

  @override
  _RestaurantQueueCardState createState() => _RestaurantQueueCardState(restaurantId);
}

class _RestaurantQueueCardState extends State<RestaurantQueueCard> {
  final int restaurantId;
  String restaurantName;

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
              Text("placeholder");
//              generateRestaurantHeading(),
//              generateWaitListHeading(),
//              generateQueue(),
            ]
        )
    );
  }
}