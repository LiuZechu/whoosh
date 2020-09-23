import 'package:flutter/material.dart';

import 'package:whoosh/entity/Commons.dart';
import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/screens/QRCodeScreen.dart';
import 'package:whoosh/screens/RestaurantHeaderBuilder.dart';
import '../entity/CommonWidget.dart';


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
              builder: (context) =>
                  RestaurantSettingsScreen(restaurantName, restaurantId)
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
      backgroundColor: Commons.whooshDarkBlue,
      body: ListView(
        children: [
          RestaurantHeaderBuilder.generateHeader(context, (){},
              _settingsCallBack, _qrCodeCallBack),
          RestaurantQueueCard(restaurantName, restaurantId),
        ],
      ),
    );
  }

}

class RestaurantQueueCard extends StatefulWidget {
  final int restaurantId;
  final String restaurantName;

  RestaurantQueueCard(this.restaurantName, this.restaurantId);

  @override
  _RestaurantQueueCardState createState() =>
      _RestaurantQueueCardState(restaurantName, restaurantId);
}

class _RestaurantQueueCardState extends State<RestaurantQueueCard> {
  final int restaurantId;
  String restaurantName;
  List<Group> groups = [];
  String iconUrl = "";

  _RestaurantQueueCardState(this.restaurantName, this.restaurantId);

  @override void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  void fetchRestaurantDetails() async {
    dynamic data = await WhooshService.getRestaurantDetails(restaurantId);
    String currentRestaurantName = data['restaurant_name'];
    String currentIconUrl = data['icon_url'];
    if (this.mounted) {
      setState(() {
        restaurantName = currentRestaurantName;
        iconUrl = currentIconUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              SizedBox(height: 20),
              CommonWidget.generateRestaurantIconAndName(restaurantName,
                  iconUrl, Commons.whooshTextWhite),
              CommonWidget.generateRestaurantScreenHeading("waitlist"),
              generateQueue(),
            ]
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
          group['group_key'],
          group['group_name'],
          group['group_size'],
          DateTime.parse(group['arrival_time']).toLocal(),
          [], // monster types are not needed on the restaurant side
          group['phone_number'])
        ).toList();
    allGroups.sort((a, b) => a.timeOfArrival.compareTo(b.timeOfArrival));
    if (this.mounted) {
      setState(() {
        groups = allGroups;
      });
    }
  }

}