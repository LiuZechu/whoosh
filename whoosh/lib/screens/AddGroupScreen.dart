import 'dart:async';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/entity/CommonWidget.dart';
import 'package:whoosh/entity/Group.dart';
import 'package:whoosh/entity/MonsterType.dart';
import 'package:whoosh/entity/WordFactory.dart';
import 'package:whoosh/requests/WhooshService.dart';

// http://localhost:${port}/#/joinQueue?restaurant_id=1
class AddGroupScreen extends StatelessWidget {
  final int restaurantId;

  AddGroupScreen(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E6F2),
      body: ListView(
        children: [
          generateHeader(),
          JoinQueueCard(restaurantId)
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

class JoinQueueCard extends StatefulWidget {
  final int restaurantId;

  JoinQueueCard(this.restaurantId);

  @override
  _JoinQueueCardState createState() => _JoinQueueCardState(restaurantId);
}

class _JoinQueueCardState extends State<JoinQueueCard> {
  final int restaurantId;
  bool shouldDisplayErrorMessage = false;
  String restaurantName = 'Loading...';
  int newGroupSize = 1;
  String phoneNumber = '';
  double buttonOpacity = 1.0;
  List<MonsterType> monsterTypes = [MonsterType.generateRandomType()];
  FlareControls poofController = FlareControls();
  bool areMonstersVisible = true;

  _JoinQueueCardState(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    Group newGroup = Group.fromSize(newGroupSize.round(), monsterTypes);
    print(MonsterType.generateMonsterTypesString(newGroup.types));
    return Container(
      child: Column(
        children: [
          CommonWidget.generateRestaurantName(restaurantName),
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
  }

  void fetchRestaurantDetails() async {
    dynamic data = await WhooshService.getRestaurantDetails(restaurantId);
    String currentRestaurantName = data['restaurant_name'];
    setState(() {
      restaurantName = currentRestaurantName;
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
                color: Color(0xFF376ADB),
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
          color: Color(0xFFF3C2C2),
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
                    color: Color(0xFF9A0000),
                    fontFamily: "VisbyCF"
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
              color: Color(0xFF2B3148),
              fontFamily: "VisbyCF"
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
              fillColor: Color(0xFFEDF6F6),
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
            color: Color(0xFF2B3148),
            fontFamily: "VisbyCF"
        ),
      ),
    );
  }

  Widget generateSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Color(0xFFEDF6F6),
        inactiveTrackColor: Color(0xFFEDF6F6),
        inactiveTickMarkColor: Color(0xFFEDF6F6),
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
          color: Color(0xFF2B3148),
          fontFamily: "VisbyCF",
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
      onTapUp: (TapUpDetails details) {
        setButtonOpacityTo(1.0);
      },
      onTap: () {
        joinQueue();
      },
      child: Opacity(
        opacity: buttonOpacity,
        child: Image(image: AssetImage('images/static/enter_queue_button.png')),
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
        shouldDisplayErrorMessage = true;
      });
      return;
    }
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
    Navigator.pushNamed(
        context,
        WhooshService.generateQueueUrl(restaurantId, groupId)
    );
  }

}
