import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/entity/CommonWidget.dart';
import 'package:whoosh/entity/Commons.dart';

import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/entity/MonsterType.dart';
import 'package:whoosh/entity/Restaurant.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:whoosh/route/route_names.dart';
import 'package:whoosh/screens/LoadingModal.dart';

// http://localhost:${port}/#/queue?restaurant_id=1&group_id=1&group_key=${group_key}
class QueueScreen extends StatelessWidget {
  final int restaurantId;
  final int groupId;
  final String groupKey;

  QueueScreen(this.restaurantId, this.groupId, this.groupKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons.whooshOffWhite,
      body: ListView(
        children: [
          generateHeader(),
          QueueCard(restaurantId, groupId, groupKey),
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
         icon: Commons.whooshLogo,
         onPressed: () {},
       ),
     ),
     actions: [
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 16),
         child: Icon(Icons.menu),
       ),
     ],
     backgroundColor: Commons.whooshLightBlue,
   );
  }

}

class QueueCard extends StatefulWidget {
  final int restaurantId;
  final int currentGroupId;
  final String groupKey;

  QueueCard(this.restaurantId, this.currentGroupId, this.groupKey);

  @override
  _QueueCardState createState() => _QueueCardState(restaurantId, currentGroupId, groupKey);
}

class _QueueCardState extends State<QueueCard> {
  final int restaurantId;
  final int currentGroupId;
  final String groupKey;
  List<Group> groups = [];
  Restaurant restaurant = Restaurant(0, 'Loading...', 0, '', '');
  String estimatedWait = "-";
  bool screenIsPresent = true;
  FlareControls poofController = FlareControls();

  _QueueCardState(this.restaurantId, this.currentGroupId, this.groupKey);

  @override void initState() {
    super.initState();
    checkConsistencyOfGroupKey(); // directs to home page for invalid group key
    fetchRestaurantDetails();
    fetchQueue();
    new Timer.periodic(Duration(seconds: 10), (Timer t) => refresh());
  }

  void fetchRestaurantDetails() async {
    dynamic data = await WhooshService.getRestaurantDetails(restaurantId);
    String currentRestaurantName = data['restaurant_name'];
    int currentUnitQueueTime = data['unit_queue_time'];
    String currentRestaurantMenuUrl = data['menu_url'];
    String currentRestaurantIconUrl = data['icon_url'];
    if (this.mounted) {
      Restaurant currentRestaurant = Restaurant(
          restaurantId,
          currentRestaurantName,
          currentUnitQueueTime,
          currentRestaurantMenuUrl,
          currentRestaurantIconUrl
      );
      setState(() {
        restaurant = currentRestaurant;
      });
    }
  }

  Future<bool> fetchQueue() async {
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
          MonsterType.generateMonsterTypes(group['monster_type']),
          group['phone_number'])
        ).toList();
    bool currentGroupIsInside =
        allGroups.where((group) => group.id == currentGroupId).length == 1;
    if (!currentGroupIsInside && context != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(welcomeRoute, (Route<dynamic>route) => false);
      return false;
    }
    Group currentGroup =
        allGroups.where((group) => group.id == currentGroupId).single;

    DateTime currentGroupArrivalTime = currentGroup.timeOfArrival;

    List<Group> groupsInFront = allGroups.where(
            (group) => group.timeOfArrival.isBefore(currentGroupArrivalTime)
    ).toList();

    groupsInFront.add(currentGroup);
    groupsInFront.sort((a, b) => b.timeOfArrival.compareTo(a.timeOfArrival));

    if (this.mounted) {
      setState(() {
        groups = groupsInFront;
        estimatedWait = generateEstimatedWaitTime(groupsInFront.length - 1, restaurant.unitQueueTime);
      });
    }
    return true;
  }

  // directs to home page if group key is invalid
  void checkConsistencyOfGroupKey() async {
    dynamic group = await WhooshService.getOneQueueGroupDetails(restaurantId, currentGroupId);
    if (group == null || group["group_key"] != groupKey) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(welcomeRoute, (Route<dynamic>route) => false);
    }
    // else do nothing
  }

  String generateEstimatedWaitTime(int numberOfGroups, int unitQueueTime) {
    int timeToWait = numberOfGroups * unitQueueTime;
    return timeToWait.toString()
            + '-'
            + (timeToWait + unitQueueTime).toString()
            + ' min';
  }

  Widget generateQueue() {
    if (groups.isEmpty || restaurant.unitQueueTime == 0) {
      fetchQueue();
    }
    return Column(
        children: groups.map((e) => createGroupImage(e)).toList()
    );
  }

  Widget createGroupImage(Group group) {
    if (group.id == currentGroupId) {
      return Stack(
        alignment: Alignment(0, -0.9),
        children: [
          group.createCurrentGroupImage(
              groups.length - 1,
              restaurant,
              refresh,
              displayCopiedMessage,
              playPoof,
          ),
          Container(
            width: 330,
            height: 330,
            child: Align(
              alignment: Alignment.topCenter,
              child: FlareActor(
                Commons.effectFlareActorPath,
                artboard: 'poof',
                animation: 'poof',
                controller: poofController,
                color: Commons.whooshLightBlue,
              ),
            )
          )
        ],
      );
    } else {
      return group.createOtherGroupImage();
    }
  }


  Widget generateWaitTime() {
    Widget estimatedWaitLabel = Text(
      'estimated wait:',
      style: TextStyle(
        fontSize: 18,
        fontFamily: Commons.whooshFont,
        color: Commons.whooshDarkBlue,
      ),
    );

    Widget estimatedWaitTime = Align(
      alignment: Alignment.center,
      child: Container(
        height: 70,
        width: 250,
        constraints: BoxConstraints(minWidth: 0, maxWidth: 250),
        child: FittedBox(
          child: Text(
            estimatedWait,
            style: TextStyle(
              fontSize: 64,
              fontFamily: Commons.whooshFont,
              fontWeight: FontWeight.w700,
              color: Commons.whooshDarkBlue,
            ),
          ),
        ),
      ),
    );

    Widget refreshButton = Container(
      height: 70,
      child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 35,
            child: GestureDetector(
              onTap: () async {
                LoadingModal waves = LoadingModal(context);
                waves.start();
                await refresh();
                waves.dismiss();
              },
              child: Commons.refreshButton
            ),
          )
      ),
    );

    return Container(
      child: Column(
        children: [
          estimatedWaitLabel,
          Container(
            width: 350,
            child: Stack(
              children: [
                estimatedWaitTime,
                refreshButton
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget generateCounter() {
    return Container(
      width: 300,
      height: 220,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Commons.queueLine,
          ),
          CommonWidget.generateMask(300, 80, Alignment.bottomCenter),
          Commons.counter,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CommonWidget.generateRestaurantName(restaurant.name, restaurant.iconUrl),
          generateWaitTime(),
          generateQueue(),
          generateCounter(),
        ]
      )
    );
  }

  Future<bool> refresh() async {
    return fetchQueue();
  }

  void displayCopiedMessage() {
    showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Commons.whooshOffWhite,
            ),
            alignment: Alignment.center,
            child: Text(
              'Link copied to clipboard!',
              style: TextStyle(
                fontSize: 24,
                fontFamily: Commons.whooshFont,
                fontWeight: FontWeight.w700,
                color: Commons.whooshDarkBlue,
              ),
            ),
          ),
        )
    );
  }

  void playPoof() {
    poofController.play('poof');
  }
}

