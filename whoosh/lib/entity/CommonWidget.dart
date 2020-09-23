import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Commons.dart';

class CommonWidget {
  static Widget generateQueuingForLabel() {
    return Text(
      'you\'re queueing for',
      style: TextStyle(
          fontSize: 18,
          fontFamily: Commons.whooshFont,
          color: Commons.whooshDarkBlue,
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
          generateRestaurantIconAndName(restaurantName, iconUrl, Commons.whooshDarkBlue),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  static generateField(String fieldName, Function(String text) onChanged,
      bool isObscureText, String prefillText) {
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
                  fontFamily: Commons.whooshFont,
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
                    fontFamily: Commons.whooshFont,
                    fontSize: 25,
                    color: Commons.whooshDarkBlue
                ),
                onChanged: onChanged,
                obscureText: isObscureText,
                controller: TextEditingController()..text = prefillText,
              ),
            ),
          ]
      ),
    );
  }

  static Widget generateWhooshHeading(String heading) {
    return Column(
        children: [
          Commons.whooshHeading,
          heading == ""
              ? Container(
                margin: const EdgeInsets.all(50.0),
                child: FittedBox(
                  child: Text(
                      'queueing made serene.',
                      style: TextStyle(
                        color: Commons.whooshTextWhite,
                        fontSize: 30,
                        fontFamily: Commons.whooshFont,
                      )
                  )
                )
              )
              : Container(
                width: 350,
                margin: const EdgeInsets.all(20.0),
                child: Text(
                  heading,
                  style: TextStyle(
                    color: Commons.whooshTextWhite,
                    fontSize: 40,
                    fontFamily: Commons.whooshFont,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                )
              )
        ]
    );
  }

}