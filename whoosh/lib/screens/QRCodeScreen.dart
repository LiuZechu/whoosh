import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:whoosh/requests/WhooshService.dart';
import '../requests/PostRequestBuilder.dart';
import 'package:http/http.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/screens/RestaurantQueueScreen.dart';
import 'package:whoosh/screens/RestaurantHeaderBuilder.dart';


class QRCodeScreen extends StatelessWidget {
  String restaurantName;
  int restaurantId;

  QRCodeScreen(this.restaurantName, this.restaurantId);

  @override
  Widget build(BuildContext context) {
    var _waitlistCallBack = () {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => RestaurantQueueScreen(restaurantName, restaurantId)
          )
      );
    };

    var _settingsCallBack = () {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => RestaurantSettingsScreen(restaurantName, restaurantId)
          )
      );
    };

    return Scaffold(
      backgroundColor: Color(0xFF2B3148),
      body: ListView(
        children: [
          RestaurantHeaderBuilder.generateHeader(context, _waitlistCallBack,
              _settingsCallBack, (){}),
          Column(
              children: [
                QRCodeCard(restaurantName, restaurantId),
              ]
          )
        ],
      ),
    );
  }

}

class QRCodeCard extends StatefulWidget {
  final String restaurantName;
  final int restaurantId;

  QRCodeCard(this.restaurantName, this.restaurantId);

  @override
  _QRCodeCardState createState() => _QRCodeCardState(restaurantName, restaurantId);
}

class _QRCodeCardState extends State<QRCodeCard> {
  final String restaurantName;
  final restaurantId;

  _QRCodeCardState(this.restaurantName, this.restaurantId);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              SizedBox(height: 50),
              generateQrCode(),
              generateViewQueueButton(context),
            ]
        )
    );
  }

  Widget generateQrCode() {
      String hostUrl = 'https%3A%2F%2Fhoholyin.github.io%2Fwhoosh%2F%23%2FjoinQueue%3Frestaurant_id%3D${restaurantId}';
      String googleQrCodeUrl = 'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=';
      String qrCodeUrl = googleQrCodeUrl + hostUrl;
      return Image.network(
        qrCodeUrl,
      );
  }

  Widget generateViewQueueButton(BuildContext context) {
    if (restaurantId == null) {
      return null;
    } else {
      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: ButtonTheme(
              minWidth: 350,
              height: 40,
              child: FlatButton(
                color: Color(0xFF376ADB),
                textColor: Color(0xFFEDF6F6),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RestaurantQueueScreen(restaurantName, restaurantId)
                      )
                  );
                },
                child: Text(
                    'view current queue',
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

}