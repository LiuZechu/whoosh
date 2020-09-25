import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Commons.dart';
import '../entity/TextfieldErrorModalBuilder.dart';

class RestaurantCommonWidget {
  static Widget generateFieldName(String fieldName) {
    return Container(
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
            fontFamily: Commons.whooshFont,
            fontSize: 25,
            color: Commons.restaurantTheme.primaryColor
        ),
        onChanged: onChanged,
        obscureText: isObscureText,
        controller: TextEditingController()..text = prefillText,
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
    return generateHeading('queueing made serene.');
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

  static Widget generateRestaurantAuthenticationErrorText(String text) {
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