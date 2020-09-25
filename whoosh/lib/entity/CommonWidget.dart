import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/entity/TextfieldErrorModalBuilder.dart';

import 'Commons.dart';

class CommonWidget {
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
        image: Commons.queueLineMask,
        width: width,
        height: height,
      ),
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

  static Widget generateFieldName(String fieldName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      width: 350,
      child: Text(
        fieldName,
        style: TextStyle(
          fontFamily: "VisbyCF",
          fontSize: 20,
          color: Commons.whooshTextWhite,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  static Widget generateFieldInput(
      Function(String text) onChanged, bool isObscureText, String prefillText) {
    return Container(
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
            fontFamily: "VisbyCF",
            fontSize: 25,
            color: Commons.restaurantTheme.primaryColor
        ),
        onChanged: onChanged,
        obscureText: isObscureText,
        controller: TextEditingController()
          ..text = prefillText
          ..selection = TextSelection.fromPosition(TextPosition(offset: prefillText.length)),
      ),
    );
  }

  static Widget generateField(String fieldName, Function(String text) onChanged,
      bool isObscureText, String prefillText, [String trigger, String currentError]) {
    return Container(
      width: 390,
      child: Stack(
        children: [
          TextfieldErrorModalBuilder.generateErrorModal(trigger, currentError),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  generateFieldName(fieldName),
                  generateFieldInput(onChanged, isObscureText, prefillText),
                ]
              ),
            )
          )
        ],
      )
    );
  }

  static Widget generateWhooshHeading() {
    return Column(
      children: [
        Commons.whooshHeading,
        Container(
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
      ]
    );
  }

  static Widget generateHeading(String heading) {
    return Column(
        children: [
          Commons.whooshHeading,
          Container(
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

  static Widget generateRestaurantScreenHeading(String heading) {
    return Container(
      width: 350,
      margin: const EdgeInsets.all(30.0),
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
    );
  }

  static Widget generateAuthenticationErrorText(String text) {
    return Container(
        width: 350,
        height: 30,
        child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: Commons.whooshFont,
                fontSize: 25,
                color: Commons.restaurantTheme.errorColor,
              ),
            )
        )
    );
  }

  static Widget generateRestaurantScreenButton(Widget image, Function() onPressed) {
    return Container (
      width: 400,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: FlatButton(
        onPressed: onPressed,
        child: image,
      )
    );
  }

}