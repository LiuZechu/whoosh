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
import 'package:whoosh/util/UrlUtil.dart';
import '../util/string_extensions.dart';

import '../commons/QueueingCommonWidget.dart';
import '../commons/Commons.dart';
import 'MonsterType.dart';

class Group {
  int id;
  String key;
  String name;
  int groupSize;
  DateTime timeOfArrival;
  List<MonsterType> types;
  String phoneNumber;

  static final double currentGroupViewHeight = 500;
  static final double currentGroupViewWidth = 400;
  static final double otherGroupViewHeight = 220;
  static final double otherGroupViewWidth = 220;
  static final double joinGroupViewHeight = 300;
  static final double joinGroupViewWidth = 300;

  Group(dynamic data) {
      this.id = data['group_id'];
      this.key = data['group_key'];
      this.name = data['group_name'];
      this.groupSize = data['group_size'];
      this.timeOfArrival = DateTime.parse(data['arrival_time']).toLocal();
      this.types = MonsterType.generateMonsterTypes(data['monster_type']);
      this.phoneNumber = data['phone_number'];
  }

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
      child: Commons.queueLine,
    );

  Widget nameBubble = Align(
    alignment: Alignment.topRight,
    child: Commons.nameBubble
  );

  Widget createJoinQueueGroupImage() {
    return generateContainerWithStack(
      createNewGroupStackElements(250, 250),
      Group.joinGroupViewWidth,
      joinGroupViewHeight
    );
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
      ), Group.currentGroupViewWidth, Group.currentGroupViewHeight
    );
  }

  Widget createOtherGroupImage() {
    return generateContainerWithStack(
      createOtherGroupStackElements(),
      Group.otherGroupViewWidth,
      Group.otherGroupViewHeight,
    );
  }

  Widget createGroupRestaurantView(int restaurantId, String restaurantName) {
    return Container(
      margin: EdgeInsets.all(6.0),
      child: Container(
        width: 350,
        height: 75,
        decoration: BoxDecoration(
          color: Commons.whooshTextWhite,
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: FocusedMenuHolder(
          onPressed: () {},
          menuWidth: 300,
          blurSize: 4,
          blurBackgroundColor: Commons.restaurantTheme.backgroundColor,
          animateMenuItems: false,
          menuBoxDecoration: BoxDecoration(
            color: Commons.whooshTextWhite,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          menuItems: <FocusedMenuItem> [
            _generateFocusedMenuItem('Alert', () async {
              await alertGroup(restaurantId, restaurantName);
            }),
            _generateFocusedMenuItem('Confirm Arrival', () {
              changeGroupQueueStatus(1, restaurantId);
            }),
            _generateFocusedMenuItem('Kick Out', () {
              changeGroupQueueStatus(2, restaurantId);
            }),
          ],
          child: FlatButton(
            onPressed: () {},
            child: _generateWaitListGroupInformation(),
          )
        ),
      )
    );
  }

  FocusedMenuItem _generateFocusedMenuItem(String displayText, Function() onPressed) {
    return FocusedMenuItem(
      title: Text(
        displayText,
        style: TextStyle(
          color: Commons.restaurantTheme.backgroundColor,
          fontSize: 20,
          fontFamily: Commons.whooshFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _generateWaitListGroupInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeOfArrival.hour.toString().padLeft(2, "0")
                  + ':' + timeOfArrival.minute.toString().padLeft(2, "0"),
              style: TextStyle(
                color: Commons.restaurantTheme.primaryColor,
                fontSize: 25,
                fontFamily: Commons.whooshFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              phoneNumber ?? "no phone number",
              style: TextStyle(
                color: Commons.restaurantTheme.primaryColor,
                fontSize: 25,
                fontFamily: Commons.whooshFont,
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
                    color: Commons.whooshDarkBlue,
                    fontSize: 25,
                    fontFamily: Commons.whooshFont,
                  )
                ),
                SizedBox(width: 5),
                Text(
                  groupSize.toString(),
                  style: TextStyle(
                    color: Commons.whooshDarkBlue,
                    fontSize: 25,
                    fontFamily: Commons.whooshFont,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ]
            ),
            SizedBox(height: 10)
          ]
        )
      ]
    );
  }

  Widget generateContainerWithStack(List<Widget> stack, double width, double height) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Stack(children: stack)
    );
  }
  
  List<Widget> createNewGroupStackElements(double monsterStackWidth, double monsterStackHeight) {
    return addMonsterStackTo([], monsterStackWidth, monsterStackHeight, true);
  }
  
  List<Widget> addMonsterStackTo(
      List<Widget> currentStack, monsterStackWidth, monsterStackHeight, bool isCurrentGroup) {
    List<Widget> monsterWidgets = [];
    List<Monster> monsters = [];
    for (int i = 0; i < groupSize; i++) {
      monsters.add(MonsterFactory.getMonsterById(i, types[i], monsterStackWidth / 2, isCurrentGroup));
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
    stackElements.add(QueueingCommonWidget.generateMask(400, 200, Alignment.topCenter));
    stackElements = addMonsterStackTo(stackElements, 200, 200, true);
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
              color: Commons.whooshTextWhite,
              fontSize: 30,
              fontFamily: Commons.whooshFont,
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
        child: QueueingCommonWidget.generateButton(
          Commons.randomizeButton,
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
        child: QueueingCommonWidget.generateButton(
          Commons.restaurantMenuButton,
            () async {
              restaurantMenuUrl = restaurantMenuUrl.prependHttpIfAbsent();
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
    String queueUrl = UrlUtil.generateEntireQueueUrl(restaurantId, id, key);
    return Align(
      child: Container(
        height: 25,
        child: QueueingCommonWidget.generateButton(
          Commons.shareQueueButton,
          () async {
            FlutterClipboard.copy(queueUrl).then((value) => print('copied'));
            displayMessage();
          }
        )
      )
    );
  }

  Widget generateNumberOfGroupsAheadLabel(int noOfGroupsAhead) {
    return generateQueueStatusLabel(
        noOfGroupsAhead == 0
          ? 'you\'re next!'
          : noOfGroupsAhead == 1
            ? '1 group ahead'
            : noOfGroupsAhead.toString() + ' groups ahead'
    );
  }

  Widget generateQueueStatusLabel(String message) {
    return Container(
      child: Align(
          alignment: Alignment.center,
          child: Stack(
              children: [
                QueueingCommonWidget.generateMask(400, 50, Alignment.center),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: Commons.whooshFont,
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
    return addMonsterStackTo(stackElements, 200, 200, false);
  }

  void changeGroupQueueStatus(int statusCode, int restaurantId) async {
    if (statusCode < 0 || statusCode > 2) {
      return;
    }
    await WhooshService.updateQueueStatus(statusCode, id, restaurantId); // use this later
    showToast("Queue status updated successfully!");
  }

  void alertGroup(int restaurantId, String restaurantName) async {
    await WhooshService.alertGroup(restaurantId, id);

    String textToSent = "Hi! it's your turn! Please proceed to ${restaurantName}.";
    // UNCOMMENT TO SEND SMS
    // await WhooshService.sendSmsToGroup(phoneNumber, textToSent); // use this later
    showToast("alerted successfully!");
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Commons.restaurantTheme.backgroundColor,
        textColor: Commons.whooshTextWhite,
        gravity: ToastGravity.BOTTOM,
        fontSize: 30.0
    );
  }

}