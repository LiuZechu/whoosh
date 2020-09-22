import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoosh/entity/MonsterFactory.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:whoosh/entity/Restaurant.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'MonsterType.dart';

class Group {
  int id;
  String key;
  String name;
  int groupSize;
  DateTime timeOfArrival;
  List<MonsterType> types;
  String phoneNumber;

  Group(this.id, this.key, this.name, this.groupSize, this.timeOfArrival, this.types, this.phoneNumber);

  Group.fromSize(this.groupSize, this.types) {
    this.id = -1;
    this.key = '';
    this.name = '';
    this.timeOfArrival = DateTime.now();
    this.phoneNumber = '';
  }

  Widget queueLine =
    Align(
      alignment: Alignment.bottomCenter,
      child: Image(
        alignment: Alignment.bottomCenter,
        image: AssetImage('images/static/queue_line.png'),
        width: 13,
        height: 400,
      ),
    );

  Widget nameBubble = Align(
    alignment: Alignment.topRight,
    child: Image(
        image: AssetImage('images/static/name_bubble.png')
    ),
  );

  Widget createJoinQueueGroupImage() {
    return generateContainerWithStack(createNewGroupStackElements(250, 250), 300, 300);
  }

  Widget createCurrentGroupImage(
      int noOfGroupsAhead,
      Restaurant restaurant,
      void Function() refresh,
      void Function() displayMessage,
      void Function() playPoof,
      ) {
    return generateContainerWithStack(
        createCurrentGroupStackElements(
            noOfGroupsAhead,
            restaurant,
            refresh,
            displayMessage,
            playPoof
        ), 500, 400
    );
  }

  Widget createOtherGroupImage() {
    return generateContainerWithStack(createOtherGroupStackElements(), 220, 220);
  }

  // TODO: Should refactor (can use restaurant class)
  Widget createGroupRestaurantView(int restaurantId, String restaurantName) {
    return Container(
      margin: EdgeInsets.all(6.0),
      child: Container(
        width: 350,
        height: 75,
        decoration: BoxDecoration( // with rounded corners
            color: Color(0xFFEDF6F6),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: FocusedMenuHolder(
          onPressed: () {
            // do something
          },
          menuWidth: 300,
          blurSize: 4,
          blurBackgroundColor: Color(0xFF2B3148),
          animateMenuItems: false,
          menuBoxDecoration: BoxDecoration(
            color: Color(0xFFEDF6F6),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          menuItems: <FocusedMenuItem> [
            FocusedMenuItem(title: Text(
              'Alert',
              style: TextStyle(
                color: Color(0xFF2B3148),
                fontSize: 20,
                fontFamily: "VisbyCF",
                fontWeight: FontWeight.bold,
              ),
            ), onPressed: () async {
              String textToSent = "Hi! it's your turn! Please proceed to ${restaurantName}.";
              // UNCOMMENT THIS TO TEST SMS
              // await smsGroup(phoneNumber, textToSent);
            }),
            FocusedMenuItem(title: Text(
              'Confirm Arrival',
              style: TextStyle(
                color: Color(0xFF2B3148),
                fontSize: 20,
                fontFamily: "VisbyCF",
                fontWeight: FontWeight.bold,
              ),
            ), onPressed: () async {
              await changeGroupQueueStatus(1, restaurantId);
            }),
            FocusedMenuItem(title: Text(
              'Kick Out',
              style: TextStyle(
                color: Color(0xFF2B3148),
                fontSize: 20,
                fontFamily: "VisbyCF",
                fontWeight: FontWeight.bold,
              ),
            ), onPressed: () async {
              await changeGroupQueueStatus(2, restaurantId);
            }),
          ],
          child: FlatButton(
            onPressed: () {
              // do something
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeOfArrival.hour.toString().padLeft(2, "0")
                          + ':' + timeOfArrival.minute.toString().padLeft(2, "0"),
                      style: TextStyle(
                        color: Color(0xFF2B3148),
                        fontSize: 25,
                        fontFamily: "VisbyCF",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      phoneNumber ?? "no phone number",
                      style: TextStyle(
                        color: Color(0xFF2B3148),
                        fontSize: 25,
                        fontFamily: "VisbyCF",
                      )
                    )
                  ]
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                            name,
                            style: TextStyle(
                              color: Color(0xFF2B3148),
                              fontSize: 25,
                              fontFamily: "VisbyCF",
                            )
                        ),
                        SizedBox(width: 5),
                        Text(
                            groupSize.toString(),
                            style: TextStyle(
                              color: Color(0xFF2B3148),
                              fontSize: 25,
                              fontFamily: "VisbyCF",
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ]
                    ),
                    SizedBox(height: 10)
                  ]
                )
              ]
            )
          )
        ),
      )
    );
  }

  Widget generateContainerWithStack(List<Widget> stack, double height, double width) {
    return Container(
        height: height,
        width: width,

        alignment: Alignment.center,
        child: Stack(
            children: stack
        )
    );
  }
  
  List<Widget> createNewGroupStackElements(double monsterStackWidth, double monsterStackHeight) {
    return addMonsterStackTo([], monsterStackWidth, monsterStackHeight);
  }
  
  List<Widget> addMonsterStackTo(
      List<Widget> currentStack, monsterStackWidth, monsterStackHeight) {
    List<Widget> monsterWidgets = [];
    List<Monster> monsters = [];
    for (int i = 0; i < groupSize; i++) {
      monsters.add(MonsterFactory.getMonsterById(i, types[i], monsterStackWidth / 2));
    }
    while (monsters.isNotEmpty && monsters.last.id > 2) {
      Monster last = monsters.removeLast();
      monsters.insert(0, last);
    }
    // Add monsters to constrained container
    monsters.forEach((monster) {
      monsterWidgets.add(generateMonsterWidget(monster));
    });
    // Add constrained container to main stack
    currentStack.add(generateMonsterWidgetStack(monsterWidgets, monsterStackWidth, monsterStackHeight));
    return currentStack;
  }

  Widget generateMonsterWidgetStack(List<Widget> monsterWidgets, width, height) {
    return Align(
        alignment: Alignment(0, -0.3),
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: monsterWidgets,
          ),
        )
    );
  }

  Widget generateMonsterWidget(Monster monster) {
    return Align(
        alignment: monster.alignment,
        child: Align(
          alignment: monster.alignment,
          child: monster.actor,
        )
    );
  }

  List<Widget> createCurrentGroupStackElements(
      int noOfGroupsAhead,
      Restaurant restaurant,
      void Function() refresh,
      void Function() displayMessage,
      void Function() playPoof) {
    List<Widget> stackElements = [];
    // Add Queue line
    stackElements.add(queueLine);
    // Block top half of queue line
    stackElements.add(generateMask(400, 200, Alignment.topCenter));
    stackElements = addMonsterStackTo(stackElements, 200, 200);
    // Add group name bubble
    stackElements.add(generateNameBubble());
    // Add button panel
    stackElements.add(
        generateCurrentGroupButtonPanel(restaurant, noOfGroupsAhead, refresh, displayMessage, playPoof)
    );
    return stackElements;
  }

  Widget generateCurrentGroupButtonPanel(
      Restaurant restaurant,
      int noOfGroupsAhead,
      void Function() refresh,
      void Function() displayMessage,
      void Function() playPoof) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 160,
          alignment: Alignment.center,
          child: Column(
            children: [
              generateRandomizeButton(restaurant.id, refresh, playPoof),
              SizedBox(height: 5,),
              generateNumberOfGroupsAheadLabel(noOfGroupsAhead),
              SizedBox(height: 5,),
              generateRestaurantMenuButton(restaurant.menuUrl, () { }),
              SizedBox(height: 5,),
              generateShareQueueButton(restaurant.id, displayMessage),
            ],
          )
      ),
    );
  }

  Widget generateNameBubble() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          width: 243,
          height: 133,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              nameBubble,
              generateNameText(),
            ],
          )
      ),
    );
  }

  Widget generateNameText() {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 200,
          height: 110,
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: TextStyle(
              color: Color(0xFFEDF6F6),
              fontSize: 30,
              fontFamily: "VisbyCF",
              fontWeight: FontWeight.w700,
            ),
          ),
        )
    );
  }

  Widget generateRandomizeButton(
      int restaurantId,
      void Function() refresh,
      void Function() playPoof) {
    return Align(
      child: Container(
        height: 25,
        child: generateButton(
          AssetImage('images/static/randomize_button.png'),
          () async {
            await randomizeMonsterTypes(restaurantId);
            playPoof();
            new Timer(Duration(milliseconds: 600), refresh);
          }
        )
      )
    );
  }
  
  Widget generateRestaurantMenuButton(String restaurantMenuUrl, void Function() redirect) {
    return Align(
      child: Container(
        height: 25,
        child: generateButton(
          AssetImage('images/static/restaurant_menu_button.png'),
            () async {
              if (restaurantMenuUrl.substring(0, 4) != 'http') {
                restaurantMenuUrl = 'http://' + restaurantMenuUrl;
              }
              if (await canLaunch(restaurantMenuUrl)) {
                await launch(restaurantMenuUrl);
              } else {
                throw 'Could not launch $restaurantMenuUrl';
              }
            }
          )
      )
    );
  }

  Widget generateShareQueueButton(int restaurantId, void Function() displayMessage) {
    String queueUrl = WhooshService.generateEntireQueueUrl(restaurantId, id);
    return Align(
      child: Container(
        height: 25,
        child: generateButton(
          AssetImage('images/static/share_queue_button.png'),
          () async {
            FlutterClipboard.copy(queueUrl).then((value) => print('copied'));
            displayMessage();
          }
        )
      )
    );
  }

  Widget generateButton(AssetImage image, void Function() onTap) {
    return GestureDetector(
      onTap: () async { onTap();},
      child: Image(
        alignment: Alignment.center,
        image: image,
      ),
    );
  }

  Widget generateNumberOfGroupsAheadLabel(int noOfGroupsAhead) {
    return Container(
      child: Align(
          alignment: Alignment.center,
          child: Stack(
              children: [
                generateMask(400, 50, Alignment.center),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    noOfGroupsAhead == 0
                        ? 'you\'re next!'
                        : noOfGroupsAhead.toString() + ' groups ahead',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "VisbyCF",
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ]
          )
      ),
    );
  }

  dynamic randomizeMonsterTypes(int restaurantId) async {
    types = types.map((e) => MonsterType.generateRandomType()).toList();
    return await updateGroup(restaurantId);
  }

  dynamic updateGroup(int restaurantId) async {
    String monsterTypesString = MonsterType.generateMonsterTypesString(types);
    dynamic response = await WhooshService.updateGroupTypes(id, restaurantId, monsterTypesString);
    return response;
  }

  List<Widget> createOtherGroupStackElements() {
    List<Widget> stackElements = [];
    stackElements.add(queueLine);
    return addMonsterStackTo(stackElements, 200, 200);
  }

  Widget generateMask(double width, double height, Alignment align) {
    return Align(
      alignment: align,
      child: Image(
        image: AssetImage('images/static/queue_line_mask.png'),
        width: width,
        height: height,
      ),
    );
  }

  void changeGroupQueueStatus(int statusCode, int restaurantId) async {
    if (statusCode < 0 || statusCode > 2) {
      return;
    }
    dynamic data = await WhooshService.updateQueueStatus(statusCode, id, restaurantId); // use this later
    showToast("Queue status updated successfully!");
  }

  void smsGroup(String phone_number, String text) async {
    dynamic data = await WhooshService.sendSmsToGroup(phone_number, text); // use this later
    showToast("SMS sent successfully!");
  }

  // TODO: beautify this.
  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0
    );
  }

}