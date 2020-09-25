import 'package:flutter/material.dart';
import 'package:whoosh/entity/CommonWidget.dart';
import 'package:whoosh/entity/Commons.dart';
import 'package:whoosh/requests/WhooshService.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/screens/RestaurantQueueScreen.dart';
import 'package:whoosh/screens/RestaurantHeaderBuilder.dart';


class QRCodeScreen extends StatelessWidget {
  final String restaurantName;
  final int restaurantId;

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
      backgroundColor: Commons.restaurantTheme.backgroundColor,
      body: ListView(
        children: [
          RestaurantHeaderBuilder.generateRestaurantScreenHeader(context, _waitlistCallBack,
              _settingsCallBack, (){}),
          Column(
              children: [
                CommonWidget.generateRestaurantScreenHeading("QR code"),
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
              SizedBox(height: 30),
              generateQrCode(),
              SizedBox(height: 30),
              generateViewQueueButton(context),
            ]
        )
    );
  }

  Widget generateQrCode() {
    return Image.network(
      WhooshService.generateQrCodeUrl(restaurantId),
      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: FittedBox(
            child: Text(
              "it's being generated.\njust give us a moment.\n How's your day?",
              style: TextStyle(
                color: Commons.whooshTextWhite,
                fontSize: 30,
                fontFamily: Commons.whooshFont,
              )
            )
          )
        );
      }
    );
  }

  Widget generateViewQueueButton(BuildContext context) {
    if (restaurantId == null) {
      return null;
    } else {
      return CommonWidget.generateRestaurantScreenButton(Commons.viewWaitlistButton,
        () {
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => RestaurantQueueScreen(restaurantName, restaurantId)
              )
          );
        }
      );
    }
  }

}