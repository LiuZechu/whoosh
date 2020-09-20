import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:whoosh/screens/QRCodeScreen.dart';

class RestaurantSettingsScreen extends StatefulWidget {
  var restaurantName;
  var estimatedWaitingTime;
  var menuUrl;
  var iconUrl;

  @override
  _RestaurantSettingsState createState() => _RestaurantSettingsState(restaurantName, estimatedWaitingTime, menuUrl, iconUrl);
}

class _RestaurantSettingsState extends State<RestaurantSettingsScreen> {
  var restaurantName;
  var estimatedWaitingTime;
  var menuUrl;
  var iconUrl;

  _RestaurantSettingsState(this.restaurantName, this.estimatedWaitingTime, this.menuUrl, this.iconUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B3148),
      body: ListView(
        children: [
          generateHeader(),
          Column(
            children: [
              generateSettingsHeading(),
              generateRestaurantPhotoCard(iconUrl),
              generateField("Name", 'please enter restaurant name...',
                      (text) { restaurantName = text; }),
              generateField("Estimated waiting time per group (min)", 'please enter est. wait time...',
                      (text) { estimatedWaitingTime = int.parse(text); }),
              generateField("Menu URL", 'please enter menu URL...',
                      (text) { menuUrl = text; }),
              generateField("Icon URL", 'please enter icon URL...',
                      (text) { setState(() { iconUrl = text; });}),
              generateQRCodeButton(context),
            ]
          )
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

  Widget generateSettingsHeading() {
    return Container(
      width: 400,
      margin: const EdgeInsets.all(30.0),
      child: Text(
        'Settings',
        style: TextStyle(
          color: Color(0xFFEDF6F6),
          fontSize: 40,
          fontFamily: "VisbyCF",
        ),
        textAlign: TextAlign.left,
      )
    );
  }

  Widget generateRestaurantPhotoCard(String iconUrl) {
    if (iconUrl == null) { // placeholder image
      return Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(50.0),
        decoration: BoxDecoration(
            color: Color(0xFFEDF6F6),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      );
    } else {
      return Container(
          height: 200,
          width: 200,
          margin: const EdgeInsets.all(50.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              iconUrl,
            )
          )
      );
    }
  }

  Widget generateField(String fieldName, String hintText, Function(String text) onChanged) {
    return Container(
        decoration: BoxDecoration(
            border: new Border(
              top: new BorderSide(
                  color: Color(0xFF376ADB),
                  width: 1.0,
                  style: BorderStyle.solid
              ),
              bottom: new BorderSide(
                  color: Color(0xFF376ADB),
                  width: 1.0,
                  style: BorderStyle.solid
              ),
            )
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                  children: [
                    Container(
                      width: 350,
                      child: TextField(
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 10, top: 10),
                            hintText: hintText,
                            hintStyle: TextStyle(
                              color: Color(0x55EDF6F6),
                              fontSize: 20,
                              fontFamily: "VisbyCF",
                            )
                        ),
                        style: TextStyle(
                            fontFamily: "VisbyCF",
                            fontSize: 35,
                            color: Color(0xFFEDF6F6)
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                    Container(
                      width: 350,
                      child: Text(
                        fieldName,
                        style: TextStyle(
                            fontFamily: "VisbyCF",
                            fontSize: 20,
                            color: Color(0xFFEDF6F6)
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]
              ),
              IconButton(
                icon: Image.asset('images/static/edit_button.png'),
                iconSize: 50,
                onPressed: () => {}, // to implement
              )
            ]
        )
    );
  }

  Widget generateQRCodeButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      child: ButtonTheme(
        minWidth: 350,
        height: 40,
        child: FlatButton(
          color: Color(0xFF376ADB),
          textColor: Color(0xFFEDF6F6),
          onPressed: () async {
            if (restaurantName == null || restaurantName.length == 0) {
              return; // TODO: provide message that Name cannot be null
            }
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => QRCodeScreen(restaurantName, estimatedWaitingTime, menuUrl, iconUrl)
                )
            );
          },
          child: Text(
              'generate QR code',
              style: TextStyle(
                fontFamily: "VisbyCF",
                fontSize: 25,
              )
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        )
      )
    );
  }

}