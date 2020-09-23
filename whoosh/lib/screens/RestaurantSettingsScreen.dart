import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whoosh/entity/Commons.dart';
import 'dart:convert';
import 'package:whoosh/screens/QRCodeScreen.dart';
import 'package:whoosh/screens/RestaurantQueueScreen.dart';
import 'package:whoosh/screens/RestaurantHeaderBuilder.dart';
import 'package:whoosh/requests/WhooshService.dart';

import 'package:firebase_auth/firebase_auth.dart';


class RestaurantSettingsScreen extends StatefulWidget {
  var restaurantName;
  var restaurantId;
  var estimatedWaitingTime = 5; // default
  var menuUrl = "";
  var iconUrl = "";

  RestaurantSettingsScreen(this.restaurantName, this.restaurantId);

  @override
  _RestaurantSettingsState createState() => _RestaurantSettingsState(restaurantId, restaurantName, estimatedWaitingTime, menuUrl, iconUrl);
}

class _RestaurantSettingsState extends State<RestaurantSettingsScreen> {
  var restaurantId;
  var restaurantName;
  var estimatedWaitingTime;
  var menuUrl;
  var iconUrl;
  var uid;

  bool _user_found = false;

  _RestaurantSettingsState(this.restaurantId, this.restaurantName, this.estimatedWaitingTime, this.menuUrl, this.iconUrl);

  @override void initState() {
    super.initState();
    // fetch uid
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      uid = auth.currentUser.uid;
      _user_found = true;
    } else {
      _user_found = false;
    }

    fetchRestaurantDetails(); // for returning users
  }

  @override
  Widget build(BuildContext context) {
    if (!_user_found) {
      return Text("user not found!");
    }

    return Scaffold(
      backgroundColor: Commons.whooshDarkBlue,
      body: ListView(
        children: [
          RestaurantHeaderBuilder.generateHeader(context,
              _waitlistCallBack, (){}, _qrCodeCallBack),
          Column(
            children: [
              generateSettingsHeading(),
              generateRestaurantPhotoCard(iconUrl),
              generateField("restaurant name",
                      (text) { restaurantName = text; }, restaurantName ?? ""),
              generateField("waiting time per group",
                      (text) { estimatedWaitingTime = int.parse(text); },
                      estimatedWaitingTime.toString() ?? ""),
              generateField("URL to icon",
                      (text) { iconUrl = text; setState(() { iconUrl = text; }); },
                      iconUrl ?? ""),
              generateField("URL to menu",
                      (text) { menuUrl = text; },
                      menuUrl ?? ""),
              SizedBox(height: 100),
              generateSubmitButton(context),
            ]
          )
        ],
      ),
    );
  }

  void _waitlistCallBack() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (context) => RestaurantQueueScreen(restaurantName, restaurantId)
      )
    );
  }

  void _qrCodeCallBack() {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => QRCodeScreen(restaurantName, restaurantId)
        )
    );
  }

  void fetchRestaurantDetails() async {
    if (restaurantId > 0) {
      dynamic data = await WhooshService.getRestaurantDetails(restaurantId);
      if (this.mounted) {
        setState( () {
            estimatedWaitingTime = data["unit_queue_time"];
            menuUrl = data["menu_url"];
            iconUrl = data["icon_url"];
          }
        );
      }
    }
  }

  Widget generateSettingsHeading() {
    return Container(
      width: 350,
      margin: const EdgeInsets.all(30.0),
      child: Text(
        'Settings',
        style: TextStyle(
          color: Commons.whooshTextWhite,
          fontSize: 40,
          fontFamily: "VisbyCF",
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      )
    );
  }

  Widget generateRestaurantPhotoCard(String iconUrl) {
    if (iconUrl == null || iconUrl == "") { // placeholder image
      return Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          color: Commons.whooshTextWhite,
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

  Widget generateField(String fieldName, Function(String text) onChanged, String prefillText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              width: 350,
              child: Text(
                fieldName,
                style: TextStyle(
                  fontFamily: "VisbyCF",
                  fontSize: 20,
                  color: Commons.whooshTextWhite,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 350,
              child: TextField(
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 10, top: 10, left: 20),
                  fillColor: Commons.whooshTextWhite,
                  filled: true,
                ),
                style: TextStyle(
                    fontFamily: "VisbyCF",
                    fontSize: 25,
                    color: Commons.whooshDarkBlue
                ),
                onChanged: onChanged,
                controller: TextEditingController()..text = prefillText,
              ),
            ),
          ]
      ),
    );
  }


  Widget generateSubmitButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ButtonTheme(
            minWidth: 350,
            height: 40,
            child: FlatButton(
              color: Commons.whooshLightBlue,
              textColor: Commons.whooshTextWhite,
              onPressed: () async {
                //print(restaurantId);
                await WhooshService.updateRestaurantDetails(restaurantId,
                    restaurantName, estimatedWaitingTime,
                    iconUrl, menuUrl);

                // go to QR code screen
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => QRCodeScreen(restaurantName, restaurantId)
                  )
                );
              },
              child: Text(
                  "submit",
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