import 'package:flutter/material.dart';

class RestaurantWelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B3148),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
                  children: [
                    generateWhooshHeading(),
                    generateStartButton(context),
                    generateTopTextBox(),
                    generateBottomTextBox(),
                    generateBottomImage(),
                  ]
            )
        )
      )
    );
  }

  Widget generateWhooshHeading() {
    return Column(
      children: [
        new Image.asset(
          'images/static/whoosh_heading.png',
        ),
        Container(
          margin: const EdgeInsets.all(50.0),
          child: Text(
            'queueing made serene.',
            style: TextStyle(
                color: Color(0xFFEDF6F6),
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
        color: Color(0xFF376ADB),
        textColor: Color(0xFFEDF6F6),
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
              child: new Image.asset(
                'images/static/restaurant_welcome_monster1.png',
              ),
            ),
            Column(
              children: [
                Container(
                  width: 188,
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: "VisbyCF", fontSize: 25, color: Color(0xFFEDF6F6))
                  )
                ),
                Container(
                  width: 188,
                  child: Text(
                    mainText,
                    style: TextStyle(fontFamily: "VisbyCF", fontSize: 18, color: Color(0xFFEDF6F6)),
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
                        style: TextStyle(fontFamily: "VisbyCF", fontSize: 25, color: Color(0xFFEDF6F6)),
                        textAlign: TextAlign.right,
                      )
                  ),
                  Container(
                      width: 188,
                      child: Text(
                        mainText,
                        style: TextStyle(fontFamily: "VisbyCF", fontSize: 18, color: Color(0xFFEDF6F6)),
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
              child: new Image.asset(
                "images/static/restaurant_welcome_monster2.png"
              ),
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(vertical: 30.0),
    );
  }

  Widget generateBottomImage() {
    return new Image.asset(
      'images/static/bottom_sea.png',
    );
  }
}
