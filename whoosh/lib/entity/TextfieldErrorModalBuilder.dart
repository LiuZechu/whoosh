import 'package:flutter/cupertino.dart';
import 'package:whoosh/commons/Commons.dart';

class TextfieldErrorModalBuilder {
  static final String noRestaurantName = "  *please enter a restaurant name";
  static final String invalidEmail = "  *please enter a valid email";
  static final String invalidPassword = "  *please enter a valid password";

  static Widget generateErrorModal(String trigger, String currentError) {
    var opacity = 0.0;
    if (trigger != null && currentError != null && trigger == currentError) {
      opacity = 1.0;
    }
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Commons.whooshErrorDarkRed,
        ),
        width: 390,
        height: 130,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: new EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 5.0,
            ),
            child: Text(
              currentError ?? "",
              style: TextStyle(
                  fontSize: 20,
                  color: Commons.whooshErrorPink,
                  fontFamily: "VisbyCF"
              ),
            ),
          )
        ),
      ),
    );
  }

}