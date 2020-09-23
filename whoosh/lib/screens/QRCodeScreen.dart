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
      backgroundColor: Commons.whooshDarkBlue,
      body: ListView(
        children: [
          RestaurantHeaderBuilder.generateHeader(context, _waitlistCallBack,
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
              SizedBox(height: 50),
              generateQrCode(),
              generateViewQueueButton(context),
            ]
        )
    );
  }

  Widget generateQrCode() {
    return Image.network(
        WhooshService.generateQrCodeUrl(restaurantId)
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