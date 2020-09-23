import 'package:flutter/material.dart';
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
                    generateWhooshHeading(),
                    generateStartButton(context),
                    generateTopTextBox(),
                    generateBottomTextBox(),
                    Commons.bottomSea
                  ]
            )
        )
      )
    );
  }

  Widget generateWhooshHeading() {
    return Column(
      children: [
        Commons.whooshHeading,
        Container(
          margin: const EdgeInsets.all(50.0),
          child: Text(
            'queueing made serene.',
            style: TextStyle(
                color: Commons.whooshTextWhite,
                fontSize: 30,
                fontFamily: "VisbyCF",
            )
          )
        )
      ]
    );
  }

  Widget generateStartButton(BuildContext context) {
    return ButtonTheme(
      minWidth: 350,
      height: 40,
      child: FlatButton(
        color: Commons.whooshLightBlue,
        textColor: Commons.whooshTextWhite,
        onPressed: () => {
          Navigator.of(context).pushNamed('/restaurant/signup')
        },
        child: Text(
            'get started',
            style: TextStyle(
              fontFamily: "VisbyCF",
              fontSize: 25,
            )
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      )
    );
  }

  Widget generateTopTextBox() {
    String title = "No more wait.";
    String mainText = "whoosh makes queuing a breeze, both for you and your customers. "
        + "You never have to manage the queue again. Your customers will have "
        + "a great time and be automatically notified to return.";
    return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 218,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Commons.welcomeMonster1
            ),
            Column(
              children: [
                Container(
                  width: 188,
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: "VisbyCF", fontSize: 25, color: Commons.whooshTextWhite)
                  )
                ),
                Container(
                  width: 188,
                  child: Text(
                    mainText,
                    style: TextStyle(fontFamily: "VisbyCF", fontSize: 18, color: Commons.whooshTextWhite),
                    softWrap: true)
                )
              ]
            )
          ]
        ),
        margin: const EdgeInsets.only(top: 50.0),
    );
  }

  Widget generateBottomTextBox() {
    String title = "Get data.";
    String mainText = "With whoosh, you’ll have real data about your waiting"
        + " times and customer footfall. And data is power. You’ll know exactly "
        + "what’s working well and what’s not working out.";
    return Container(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
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
            ),
            Container(
              width: 160,
              height: 218,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child:  Commons.welcomeMonster2,
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(vertical: 30.0),
    );
  }
}
