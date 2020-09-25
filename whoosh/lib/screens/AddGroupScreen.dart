import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/commons/QueueingCommonWidget.dart';
import 'package:whoosh/commons/Commons.dart';
import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/entity/MonsterType.dart';
import 'package:whoosh/entity/WordFactory.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:whoosh/util/UrlUtil.dart';

// http://localhost:${port}/#/joinQueue?restaurant_id=1
class AddGroupScreen extends StatelessWidget {
  final int restaurantId;

  AddGroupScreen(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons.queueingTheme.backgroundColor,
      body: ListView(
        children: [
          QueueingCommonWidget.generateQueueScreenHeader(),
          JoinQueueCard(restaurantId)
        ],
      ),
    );
  }
}

class JoinQueueCard extends StatefulWidget {
  final int restaurantId;

  JoinQueueCard(this.restaurantId);

  @override
  _JoinQueueCardState createState() => _JoinQueueCardState(restaurantId);
}

class _JoinQueueCardState extends State<JoinQueueCard> {
  final int restaurantId;
  bool shouldDisplayErrorMessage = false;
  bool areMonstersVisible = false;
  bool hasJoinedQueue = false;
  String restaurantName = 'Loading...';
  String restaurantIconUrl = "";
  int newGroupSize = 1;
  String phoneNumber = '';
  double buttonOpacity = 1.0;
  List<MonsterType> monsterTypes = [MonsterType.generateRandomType()];
  FlareControls poofController = FlareControls();

  _JoinQueueCardState(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    Group newGroup = Group.fromSize(newGroupSize.round(), monsterTypes);
    return Container(
      child: Column(
        children: [
          QueueingCommonWidget.generateRestaurantName(restaurantName, restaurantIconUrl),
          generateJoinQueueGroupImage(newGroup),
          generatePhoneNumberField(),
          SizedBox(height: 20),
          generateGroupSizeSlider(),
          SizedBox(height: 20),
          generateEnterQueueButton(),
        ],
      ),
    );
  }

  void playPoof() {
    poofController.play('poof');
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
    new Timer(Duration(milliseconds: 1200), () {
      setState(() {
        areMonstersVisible = true;
      });
    });
  }

  void fetchRestaurantDetails() async {
    dynamic data = await WhooshService.getRestaurantDetails(restaurantId);
    String currentRestaurantName = data['restaurant_name'];
    String currentRestaurantIconUrl = data['icon_url'];
    setState(() {
      restaurantName = currentRestaurantName;
      restaurantIconUrl = currentRestaurantIconUrl;
    });
  }

  Widget generateJoinQueueGroupImage(Group newGroup) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: areMonstersVisible ? 1 : 0,
          child: newGroup.createJoinQueueGroupImage(),
        ),
        Container(
            width: 400,
            height: 400,
            child: Align(
              alignment: Alignment.topCenter,
              child: FlareActor(
                'images/actors/effect.flr',
                artboard: 'poof',
                animation: 'poof',
                controller: poofController,
                color: Commons.whooshLightBlue,
              ),
            )
        )
      ],
    );
  }

  Widget generateErrorModal() {
    return Opacity(
      opacity: shouldDisplayErrorMessage ? 1 : 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Commons.queueingTheme.errorColor,
        ),
        width: 390,
        height: 160,
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: new EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: Text(
                '*should have 8 digits',
                style: TextStyle(
                    fontSize: 24,
                    color: Commons.whooshErrorDarkRed,
                    fontFamily: Commons.whooshFont
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget generatePhoneNumberLabel() {
    return Container(
      width: 350,
      height: 50,
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'phone number',
          style: TextStyle(
              fontSize: 24,
              color: Commons.queueingTheme.primaryColor,
              fontFamily: Commons.whooshFont
          ),
        ),
      ),
    );
  }

  Widget generateTextField() {
    return Container(
      height: 70,
      width: 350,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Commons.whooshTextWhite,
            ),
            onChanged: (text) {
              phoneNumber = text;
              if (shouldDisplayErrorMessage) {
                setState(() {
                  shouldDisplayErrorMessage = !isValidPhoneNumber();
                });
              }
            },
            onSubmitted: (text) {
              setState(() {
                shouldDisplayErrorMessage = !isValidPhoneNumber();
              });
            },
          ),
        ),
      )
    );
  }

  Widget generatePhoneNumberTextField() {
    return Column(
      children: [
        generatePhoneNumberLabel(),
        generateTextField(),
      ],
    );
  }

  Widget generatePhoneNumberField() {
    return Container(
      width: 390,
      child: Stack(
        children: [
          generateErrorModal(),
          generatePhoneNumberTextField()
        ],
      )
    );
  }

  Widget generateSliderLabel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'group size',
        style: TextStyle(
            fontSize: 24,
            color: Commons.queueingTheme.primaryColor,
            fontFamily: Commons.whooshFont
        ),
      ),
    );
  }

  Widget generateSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Commons.whooshTextWhite,
        inactiveTrackColor: Commons.whooshTextWhite,
        inactiveTickMarkColor: Commons.whooshTextWhite,
      ),
      child: Slider(
        value: newGroupSize.roundToDouble(),
        min: 1,
        max: 5,
        divisions: 4,
        onChanged: (double value) async {
          if (value.round() > newGroupSize && value.round() - 1 != monsterTypes.length) {
            return;
          }
          if (value.round() < newGroupSize && value.round() + 1 != monsterTypes.length) {
            return;
          }
          if (value.round() == newGroupSize) {
            return;
          }
          if (value == newGroupSize.roundToDouble()) {
            return;
          }
          playPoof();
          setState(() {
            monsterTypes = getUpdatedMonsterType(value.round() > newGroupSize, monsterTypes);
            newGroupSize = value.round();
            areMonstersVisible = false;
          });
          new Timer(Duration(milliseconds: 900), () {
            setState(() {
              areMonstersVisible = true;
            });
          });
        },
      ),
    );
  }

  Widget generateGroupSizeLabel() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        newGroupSize.round().toString(),
        style: TextStyle(
          fontSize: 36,
          color: Commons.queueingTheme.primaryColor,
          fontFamily: Commons.whooshFont,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget generateGroupSizeSlider() {
    return Container(
      width: 350,
      child: Column(
        children: [
          generateSliderLabel(),
          generateSlider(),
          generateGroupSizeLabel(),
        ],
      ),
    );
  }

  List<MonsterType> getUpdatedMonsterType(bool didAddMonster, List<MonsterType> monsterTypes) {
    if (didAddMonster) {
      monsterTypes.add(MonsterType.generateRandomType());
    } else {
      monsterTypes.removeLast();
    }
    return monsterTypes;
  }

  void setButtonOpacityTo(double opacity) {
    setState(() {
      buttonOpacity = opacity;
    });
  }

  Widget generateEnterQueueButton() {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setButtonOpacityTo(0.5);
      },
      onTapCancel: () {
        setButtonOpacityTo(1.0);
      },
      onTap: hasJoinedQueue ? null : () {
        joinQueue();
      },
      child: Opacity(
        opacity: buttonOpacity,
        child: Commons.enterQueueButton,
      )
    );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  bool isValidPhoneNumber() {
    return isNumeric(phoneNumber) && phoneNumber.length == 8;
  }
  
  void joinQueue() async {
    if (!isValidPhoneNumber()) {
      setState(() {
        hasJoinedQueue = false;
        setButtonOpacityTo(1.0);
        shouldDisplayErrorMessage = true;
      });
      return;
    }
    hasJoinedQueue = true;
    String monsterTypesString = MonsterType.generateMonsterTypesString(monsterTypes);
    List<dynamic> allGroups = await WhooshService.getAllGroupsInQueue(restaurantId);
    List<String> allGroupNames = allGroups
        .map((group) => group['group_name'].toString())
        .toList();
    String groupName = WordFactory.getRandomWordNotInList(allGroupNames);
    dynamic data = await WhooshService.joinQueue(
      restaurantId,
      groupName,
      newGroupSize,
      monsterTypesString,
      phoneNumber
    );
    int groupId = data['group_id'];
    String groupKey = data['group_key'];
    Navigator.pushNamed(
        context,
        UrlUtil.generateQueueUrl(restaurantId, groupId, groupKey)
    );
  }

}
