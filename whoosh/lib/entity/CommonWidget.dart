import 'package:flutter/cupertino.dart';

class CommonWidget {
  static Widget generateQueuingForLabel() {
    return Text(
      'you\'re queueing for',
      style: TextStyle(
          fontSize: 18,
          fontFamily: "VisbyCF",
          color: Color(0xFF2B3148),
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
              fontFamily: "VisbyCF",
              fontWeight: FontWeight.w700,
            ),
          ),
        )
    );
  }

  static Widget generateMask(double width, double height, Alignment align) {
    return Align(
      alignment: align,
      child: Image(
        image: AssetImage('images/static/queue_line_mask.png'),
        width: width,
        height: height,
      ),
    );
  }

  static Widget generateRestaurantIcon(String iconUrl) {
    var image;
    if (iconUrl == "") {
      image = Image(
        image: AssetImage('images/static/whoosh_icon.png'),
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
          generateRestaurantIconAndName(restaurantName, iconUrl, Color(0xFF2B3148)),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}