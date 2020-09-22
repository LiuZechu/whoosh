import 'package:flutter/cupertino.dart';

class CommonWidget {
  static Widget generateQueuingForLabel() {
    return Text(
      'you\'re queueing for',
      style: TextStyle(
          fontSize: 18,
          fontFamily: "VisbyCF"
      ),
    );
  }

  static Widget generateRestaurantNameLabel(String restaurantName) {
    return Container(
        height: 50,
        constraints: BoxConstraints(minWidth: 0, maxWidth: 250),
        child: FittedBox(
          child: Text(
            restaurantName,
            style: TextStyle(
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
    return Image(image: AssetImage('images/static/restaurant_icon.png'),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }

  static Widget generateRestaurantIconAndName(String restaurantName) {
    return Container(
      width: 400,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          generateRestaurantIcon('dummy url'),
          SizedBox(width: 10),
          generateRestaurantNameLabel(restaurantName),
        ],
      ),
    );
  }

  static Widget generateRestaurantName(String restaurantName) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          generateQueuingForLabel(),
          generateRestaurantIconAndName(restaurantName),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}