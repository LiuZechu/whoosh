import 'dart:async';

import 'package:flutter/material.dart';

import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/entity/MonsterType.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:whoosh/route/route_names.dart';
import 'package:whoosh/screens/LoadingModal.dart';

// http://localhost:${port}/#/queue?restaurant_id=1&group_id=1
class QueueScreen extends StatelessWidget {
  final int restaurantId;
  final int groupId;
  QueueScreen(this.restaurantId, this.groupId);

  @override
  Widget build(BuildContext context) {
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
           'images/static/logo.png',
         ),
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
  final int restaurantId;
  final int currentGroupId;
  List<Group> groups = [];
  String restaurantName = 'Loading...';
  int unitQueueTime = 0;
  String estimatedWait = "-";
  bool screenIsPresent = true;

  _QueueCardState(this.restaurantId, this.currentGroupId);

  @override void initState() {
    super.initState();
    fetchRestaurantDetails();
    fetchQueue();
    new Timer.periodic(Duration(seconds: 10), (Timer t) => refresh());
  }

  void fetchRestaurantDetails() async {
    dynamic data = await WhooshService.getRestaurantDetails(restaurantId);
    String currentRestaurantName = data['restaurant_name'];
    int currentUnitQueueTime = data['unit_queue_time'];
    if (this.mounted) {
      setState(() {
        restaurantName = currentRestaurantName;
        unitQueueTime = currentUnitQueueTime;
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
          group['group_name'],
          group['group_size'],
          DateTime.parse(group['arrival_time']),
          MonsterType.generateMonsterTypes(group['monster_type']))
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
        estimatedWait = generateEstimatedWaitTime(groupsInFront.length - 1, unitQueueTime);
      });
    }
    return true;
  }

  String generateEstimatedWaitTime(int numberOfGroups, int unitQueueTime) {
    int timeToWait = numberOfGroups * unitQueueTime;
    return timeToWait.toString()
            + '-'
            + (timeToWait + unitQueueTime).toString()
            + ' min';
  }

  Widget generateQueue() {
    if (groups.isEmpty || unitQueueTime == 0) {
      fetchQueue();
    }
    return Column(
        children: groups.map(
                (e) => e.id == currentGroupId
                    ? e.createCurrentGroupImage(groups.length - 1, refresh, restaurantId)
                    : e.createOtherGroupImage()
        ).toList()
    );
  }

  Widget generateRestaurantName() {
    Widget restaurantIcon = Image(image: AssetImage('images/static/restaurant_icon.png'),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
    Widget restaurantNameContainer = Container(
        height: 50,
        constraints: BoxConstraints(minWidth: 0, maxWidth: 250),
        child: FittedBox(
          child: Text(
            restaurantName,
            style: TextStyle(
              fontSize: 36,
              fontFamily: "VisbyCF",
              fontWeight: FontWeight.w700,
            ),
          ),
        )
    );
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
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                restaurantIcon,
                SizedBox(width: 10),
                restaurantNameContainer
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
          Container(
            width: 350,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    estimatedWait,
                    style: TextStyle(
                      fontSize: 64,
                      fontFamily: "VisbyCF",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        LoadingModal waves = LoadingModal(context);
                        showDialog(
                            context: context,
                            builder: (_) => waves
                        );
                        await refresh();
                        waves.dismiss();
                      },
                      child: Image(
                          alignment: Alignment.centerRight,
                          image: AssetImage('images/static/refresh_button.png')
                      ),
                    ),
                  )
                ),
              ],
            ),
          )
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

  Future<bool> refresh() async {
    return fetchQueue();
  }
}

