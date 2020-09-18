import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:whoosh/screens/QRCodeScreen.dart';

class RestaurantSettingsScreen extends StatelessWidget {

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
              generateRestaurantPhotoCard(),
              generateRestaurantNameField(),
              //generateRestaurantMenuField(),
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
            'images/logo.png',
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

  Widget generateRestaurantPhotoCard() {
    return Container(
      margin: const EdgeInsets.all(50.0),
      child: new Image.asset(
        'images/restaurant_icon_big.png'
      )
    );
  }

  Widget generateRestaurantNameField() {
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 50.0),
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
                child: Text(
                  "Genki Sushi",
                  style: TextStyle(
                    fontFamily: "VisbyCF",
                    fontSize: 40,
                    color: Color(0xFFEDF6F6)
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                width: 350,
                child: Text(
                  "Name",
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
            icon: Image.asset('images/edit_button.png'),
            iconSize: 50,
            onPressed: () => {}, // to implement
          )
        ]
      )
    );
  }

//  Widget generateRestaurantMenuField() {
//
//  }

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
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => QRCodeScreen("placeholder")
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