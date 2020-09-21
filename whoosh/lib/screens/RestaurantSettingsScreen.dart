import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:whoosh/screens/QRCodeScreen.dart';
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
//    // fetch restaurantId
//    var data = await WhooshService.getRestaurantDetailsWithUid(uid);
//    if (data.toList().length != 0) {
//      restaurantId = data.single['restaurant_id'];
//    } else {
//      restaurantId = -1;
//    }
//
//    // register restaurant if id = -1
//    await registerRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    if (!_user_found) {
      return Text("user not found!");
    }

    return Scaffold(
      backgroundColor: Color(0xFF2B3148),
      body: ListView(
        children: [
          generateHeader(),
          Column(
            children: [
              generateSettingsHeading(),
              //Text("UID is : " + uid),
              //Text("restaurant id is: " + restaurantId.toString()),
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
              // generateQRCodeButton(context),
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

  Widget generateField(String fieldName, Function(String text) onChanged, String prefillText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              width: 400,
              child: Text(
                fieldName,
                style: TextStyle(
                  fontFamily: "VisbyCF",
                  fontSize: 20,
                  color: Color(0xFFEDF6F6),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 400,
              child: TextField(
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 10, top: 10, left: 20),
                  fillColor: Color(0xFFEDF6F6),
                  filled: true,
                ),
                style: TextStyle(
                    fontFamily: "VisbyCF",
                    fontSize: 25,
                    color: Color(0xFF2B3148)
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
            minWidth: 400,
            height: 40,
            child: FlatButton(
              color: Color(0xFF376ADB),
              textColor: Color(0xFFEDF6F6),
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

//  void registerRestaurant() async {
//    dynamic data = await WhooshService.registerRestaurant(restaurantName, estimatedWaitingTime, menuUrl, iconUrl, uid);
//    int currentRestaurantId = data['restaurant_id'];
//    if (this.mounted) {
//      setState(() {
//        restaurantId = currentRestaurantId;
//      });
//    }
//  }
//
//  Widget generateQRCodeButton(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.only(top: 50.0),
//      child: ButtonTheme(
//        minWidth: 350,
//        height: 40,
//        child: FlatButton(
//          color: Color(0xFF376ADB),
//          textColor: Color(0xFFEDF6F6),
//          onPressed: () async {
//            if (restaurantName == null || restaurantName.length == 0) {
//              return; // TODO: provide message that Name cannot be null
//            }
//            Navigator.pushReplacement(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) => QRCodeScreen(restaurantName, estimatedWaitingTime, menuUrl, iconUrl)
//                )
//            );
//          },
//          child: Text(
//              'generate QR code',
//              style: TextStyle(
//                fontFamily: "VisbyCF",
//                fontSize: 25,
//              )
//          ),
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(18.0),
//          ),
//        )
//      )
//    );
//  }

}