import 'package:flutter/material.dart';
import 'package:whoosh/entity/CommonWidget.dart';
import 'package:whoosh/entity/Commons.dart';

class RestaurantWelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons.whooshDarkBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
                  children: [
                    CommonWidget.generateWhooshHeading(""),
                    CommonWidget.generateRestaurantScreenButton(Commons.getStartedButton,
                      () => {
                        Navigator.of(context).pushNamed('/restaurant/signup')
                    }),
                    generateTopTextBox(),
                    generateBottomTextBox(),
                    Commons.bottomSea
                  ]
            )
        )
      )
    );
  }

  Widget generateTopTextBox() {
    String title = "No more wait.";
    String mainText = "whoosh makes queuing a breeze, both for you and your customers. "
        + "You never have to manage the queue again. Your customers will have "
        + "a great time and be automatically notified to return.";
    return FittedBox(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _generateMonsterImage(true),
              _generateTextBox(title, mainText),
              SizedBox(width: 8),
            ]
          ),
          margin: const EdgeInsets.only(top: 50.0),
      )
    );
  }

  Widget generateBottomTextBox() {
    String title = "Get data.";
    String mainText = "With whoosh, you’ll have real data about your waiting"
        + " times and customer footfall. And data is power. You’ll know exactly "
        + "what’s working well and what’s not working out.";
    return FittedBox(
        child: Container(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              _generateTextBox(title, mainText),
              _generateMonsterImage(false),
            ]
        ),
        margin: const EdgeInsets.symmetric(vertical: 30.0),
      )
    );
  }
  
  Widget _generateTextBox(String title, String mainText) {
    return Column(
        children: [
          Container(
              width: 188,
              child: Text(
                title,
                style: TextStyle(fontFamily: "VisbyCF", fontSize: 25, color: Commons.whooshTextWhite),
                textAlign: TextAlign.right,
              )
          ),
          Container(
              width: 188,
              child: Text(
                  mainText,
                  style: TextStyle(fontFamily: "VisbyCF", fontSize: 18, color: Commons.whooshTextWhite),
                  textAlign: TextAlign.right,
                  softWrap: true
              )
          )
        ]
    );
  }
  
  Widget _generateMonsterImage(bool isTop) {
    return Container(
      width: 160,
      height: 218,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child:  isTop? Commons.welcomeMonster1 : Commons.welcomeMonster2,
    );
  }
  
}
