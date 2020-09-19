import 'dart:convert';
import 'package:flutter/material.dart';
import '../requests/PostRequestBuilder.dart';
import 'package:http/http.dart';

class QRCodeScreen extends StatelessWidget {
  String restaurantName;
  int estimatedWaitingTime;

  QRCodeScreen(this.restaurantName, this.estimatedWaitingTime);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF2B3148),
      body: ListView(
        children: [
          generateHeader(),
          Column(
              children: [
                QRCodeCard(restaurantName, estimatedWaitingTime),
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

}

class QRCodeCard extends StatefulWidget {
  final String restaurantName;
  final int estimatedWaitingTime;

  QRCodeCard(this.restaurantName, this.estimatedWaitingTime);

  @override
  _QRCodeCardState createState() => _QRCodeCardState(restaurantName, estimatedWaitingTime);
}

class _QRCodeCardState extends State<QRCodeCard> {
  final String restaurantName;
  final int estimatedWaitingTime;
  var restaurantId = -1;

  _QRCodeCardState(this.restaurantName, this.estimatedWaitingTime);

  @override void initState() {
    super.initState();
    registerRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              generateQrCode(),
            ]
        )
    );
  }

  void registerRestaurant() async {
    Response response = await PostRequestBuilder()
        .addBody(<String, String>{
      "restaurant_name": restaurantName,
      "unit_queue_time": estimatedWaitingTime.toString(),
      "icon_url":  "www.example.com" // hardcoded; to change later
    })
        .addPath('restaurants')
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    int currentRestaurantId = data['restaurant_id'];
    if (this.mounted) {
      setState(() {
        restaurantId = currentRestaurantId;
      });
    }
  }

  Widget generateQrCode() {
    if (restaurantId == -1) {
      // TODO: make this more aesthatic
      return Text(
        'LOADING',
        style: TextStyle(color: Colors.red, fontSize: 50, fontFamily: "VisbyCF",)
      );
    } else {
      // TODO: change url to actual ones
      String hostUrl = 'https%3A%2F%2Fhoholyin.github.io%2Fwhoosh%2F%23%2FjoinQueue%3Frestaurant_id%3D${restaurantId}';
      String googleQrCodeUrl = 'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=';
      String qrCodeUrl = googleQrCodeUrl + hostUrl;
      return Image.network(
        qrCodeUrl,
      );
    }
  }

}