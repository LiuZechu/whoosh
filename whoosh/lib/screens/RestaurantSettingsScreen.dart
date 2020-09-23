import 'package:flutter/material.dart';
import 'package:whoosh/entity/CommonWidget.dart';
import 'package:whoosh/entity/Commons.dart';
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

  bool _userFound = false;

  _RestaurantSettingsState(this.restaurantId, this.restaurantName, this.estimatedWaitingTime, this.menuUrl, this.iconUrl);

  @override void initState() {
    super.initState();
    fetchUid();
    fetchRestaurantDetails(); // for returning users
  }

  @override
  Widget build(BuildContext context) {
    if (!_userFound) {
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
              CommonWidget.generateRestaurantScreenHeading("settings"),
              generateRestaurantPhotoCard(iconUrl),
              CommonWidget.generateField("restaurant name",
                      (text) { restaurantName = text; },
                      false, restaurantName ?? ""),
              CommonWidget.generateField("waiting time per group",
                      (text) { estimatedWaitingTime = int.parse(text); },
                      false, estimatedWaitingTime.toString() ?? ""),
              CommonWidget.generateField("URL to icon",
                      (text) { iconUrl = text; setState(() { iconUrl = text; }); },
                      false, iconUrl ?? ""),
              CommonWidget.generateField("URL to menu", (text) { menuUrl = text; },
                      false, menuUrl ?? ""),
              SizedBox(height: 100),
              CommonWidget.generateRestaurantScreenButton(Commons.confirmButton, _submitSettings),
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

  void fetchUid() {
    // fetch uid
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      uid = auth.currentUser.uid;
      _userFound = true;
    } else {
      _userFound = false;
    }
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

  Widget generateRestaurantPhotoCard(String iconUrl) {
    if (iconUrl == null || iconUrl == "") { // placeholder image
      return _generatePlaceholderImage();
    } else {
      return _generateRestaurantIcon(iconUrl);
    }
  }

  Widget _generatePlaceholderImage() {
    return Container(
      height: 200,
      width: 200,
      margin: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Image.asset('images/static/whoosh_icon.png'),
    );
  }

  Widget _generateRestaurantIcon(String iconUrl) {
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

  void _submitSettings() async {
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
  }

}