import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/entity/MonsterFactory.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class Group {
  int id;
  String name;
  int groupSize;
  DateTime timeOfArrival;

  Group(this.id, this.name, this.groupSize, this.timeOfArrival);

  Group.fromSize(this.groupSize);

  Widget createJoinQueueGroupImage() {
    return generateContainerWithStack(createNewGroupStackElements(), 300);
  }

  Widget createCurrentGroupImage(int noOfGroupsAhead) {
    return generateContainerWithStack(
        createCurrentGroupStackElements(noOfGroupsAhead), 400
    );
  }

  Widget createOtherGroupImage() {
    return generateContainerWithStack(createOtherGroupStackElements(), 400);
  }

  Widget createGroupRestaurantView() {
    return Container(
      margin: EdgeInsets.all(6.0),
      child: Container(
        width: 400,
        height: 75,
        decoration: BoxDecoration( // with rounded corners
            color: Color(0xFFEDF6F6),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: FocusedMenuHolder(
          onPressed: () {
            // do something
          },
          menuWidth: 250,
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
            ), onPressed: () {}),
            FocusedMenuItem(title: Text(
              'Confirm Arrival',
              style: TextStyle(
                color: Color(0xFF2B3148),
                fontSize: 20,
                fontFamily: "VisbyCF",
                fontWeight: FontWeight.bold,
              ),
            ), onPressed: () {}),
            FocusedMenuItem(title: Text(
              'Kick Out',
              style: TextStyle(
                color: Color(0xFF2B3148),
                fontSize: 20,
                fontFamily: "VisbyCF",
                fontWeight: FontWeight.bold,
              ),
            ), onPressed: () {}),
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
                      "91234567", //TODO: change this later
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

  Widget generateContainerWithStack(List<Widget> stack, double height) {
    return Container(
        height: height,
        width: 400,
        alignment: Alignment.center,
        child: Stack(
            children: stack
        )
    );
  }
  
  List<Widget> createNewGroupStackElements() {
    return addMonsterStackTo([]);
  }
  
  List<Widget> addMonsterStackTo(List<Widget> currentStack) {
    List<Widget> monsterWidgets = [];
    List<Monster> monsters = [];
    for (int i = 0; i < groupSize; i++) {
      monsters.add(MonsterFactory.getMonsterById(i));
    }
    while (monsters.isNotEmpty && monsters.last.id > 2) {
      Monster last = monsters.removeLast();
      monsters.insert(0, last);
    }
    // Add monsters to constrained container
    for (int i = 0; i < groupSize; i++) {
      Monster monster = monsters[i];
      monsterWidgets.add(
          Align(
              alignment: monster.alignment,
              child: Image(
                alignment: monster.alignment,
                image: monster.asset,
              )
          )
      );
    }
    // Add constrained container to main stack
    currentStack.add(
        Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 200,
              child: Stack(
                children: monsterWidgets,
              ),
            )
        )
    );
    return currentStack;
  }

  List<Widget> createCurrentGroupStackElements(int noOfGroupsAhead) {
    List<Widget> stackElements = [];
    // Add Queue line
    stackElements.add(
        Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/queue_line.png'),
            width: 13,
            height: 400,
          ),
        )
    );
    // Block top half of queue line
    stackElements.add(generateMask(400, 200, Alignment.topCenter));
    stackElements = addMonsterStackTo(stackElements);
    // Add group name bubble
    stackElements.add(
      Align(
        alignment: Alignment.topRight,
          child: Container(
            width: 266,
            height: 160,
            child: Stack(
            alignment: Alignment.topRight,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Image(
                  image: AssetImage('images/name_bubble.png')
                ),
              ),
              Align(
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
              )
            ],
          )
        ),
      )
    );
    // Add randomize button and no of groups ahead
    stackElements.add(
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 400,
          height: 100,
          child: Stack(
            children: [
              generateMask(400, 50, Alignment(0, 0.4)),
              Align(
                alignment: Alignment.topCenter,
                child: Image(
                  alignment: Alignment.topCenter,
                  image: AssetImage('images/randomize_button.png'),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.4),
                child: Text(
                  noOfGroupsAhead == 0
                      ? 'you\'re next!'
                      : noOfGroupsAhead.toString() + ' groups ahead',
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: "VisbyCF",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
    return stackElements;
  }

  List<Widget> createOtherGroupStackElements() {
    List<Widget> stackElements = [];
    stackElements.add(
        Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/queue_line.png'),
            width: 13,
            height: 400,
          ),
        )
    );
    List<Widget> monsterWidgets = [];
    return addMonsterStackTo(stackElements);
  }

  Widget generateMask(double width, double height, Alignment align) {
    return Align(
      alignment: align,
      child: Image(
        image: AssetImage('images/queue_line_mask.png'),
        width: width,
        height: height,
      ),
    );
  }
}