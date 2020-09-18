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
          'images/whoosh_heading.png',
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
          Navigator.of(context).pushNamed('/restaurant/settings')
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
    String mainText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus elementum nunc in leo convallis, sed dapibus lectus sagittis. Duis justo est, accumsan non vestibulum a, commodo at lorem.";
    return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container( // place holder for image
                width: 120,
                height: 210,
                color: Color(0xFFEDF6F6),
                margin: const EdgeInsets.symmetric(horizontal: 20.0)),
            Column(
              children: [
                Container(
                  width: 200,
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: "VisbyCF", fontSize: 25, color: Color(0xFFEDF6F6))
                  )
                ),
                Container(
                  width: 200,
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
    String mainText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus elementum nunc in leo convallis, sed dapibus lectus sagittis. Duis justo est, accumsan non vestibulum a, commodo at lorem.";
    return Container(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
                children: [
                  Container(
                      width: 200,
                      child: Text(
                        title,
                        style: TextStyle(fontFamily: "VisbyCF", fontSize: 25, color: Color(0xFFEDF6F6)),
                        textAlign: TextAlign.right,
                      )
                  ),
                  Container(
                      width: 200,
                      child: Text(
                        mainText,
                        style: TextStyle(fontFamily: "VisbyCF", fontSize: 18, color: Color(0xFFEDF6F6)),
                        textAlign: TextAlign.right,
                        softWrap: true
                      )
                  )
                ]
            ),
            Container( // place holder for image
                width: 120,
                height: 210,
                color: Color(0xFFEDF6F6),
                margin: const EdgeInsets.symmetric(horizontal: 20.0)
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(vertical: 30.0),
    );
  }

  Widget generateBottomImage() {
    return new Image.asset(
      'images/bottom_sea.png',
    );
  }
}
