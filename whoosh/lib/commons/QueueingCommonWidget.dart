import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Commons.dart';

class QueueingCommonWidget {
  static Widget generateQueueScreenHeader() {
    return AppBar(
      leading: Transform.scale(
        scale: 3,
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Commons.whooshLogo,
          onPressed: () {},
        ),
      ),
      backgroundColor: Commons.whooshLightBlue,
    );
  }

  static Widget generateQueuingForLabel() {
    return Text(
      'you\'re queueing for',
      style: TextStyle(
          fontSize: 18,
          fontFamily: Commons.whooshFont,
          color: Commons.queueingTheme.primaryColor,
      ),
    );
  }

  static Widget generateButton(Image image, void Function() onTap) {
    return GestureDetector(
        onTap: () async { onTap();},
        child: image
    );
  }

  static Widget generateMask(double width, double height, Alignment align) {
    return Align(
      alignment: align,
      child: Image(
        image: Commons.queueLineMask,
        width: width,
        height: height,
      ),
    );
  }

  static Widget generateRestaurantNameLabel(String restaurantName, Color color) {
    return Container(
        height: 50,
        constraints: BoxConstraints(minWidth: 0, maxWidth: 250),
        child: FittedBox(
          child: Text(
            restaurantName,
            style: TextStyle(
              color: color,
              fontSize: 36,
              fontFamily: Commons.whooshFont,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
    );
  }

  static Widget generateRestaurantIcon(String iconUrl) {
    var image;
    if (iconUrl == "") {
      image = Image(
        image: Commons.whooshIconAsset,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      image = Image.network(
        iconUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: image
    );
  }

  static Widget generateRestaurantIconAndName(String restaurantName, String iconUrl, Color color) {
    return Container(
      width: 400,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          generateRestaurantIcon(iconUrl),
          SizedBox(width: 10),
          generateRestaurantNameLabel(restaurantName, color),
        ],
      ),
    );
  }

  static Widget generateRestaurantName(String restaurantName, String iconUrl) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          generateQueuingForLabel(),
          generateRestaurantIconAndName(restaurantName, iconUrl, Commons.queueingTheme.primaryColor),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}