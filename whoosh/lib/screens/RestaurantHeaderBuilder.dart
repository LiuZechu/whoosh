import 'package:flutter/material.dart';

class RestaurantHeaderBuilder {

  static Widget generateHeader(BuildContext context, Function() waitlistCallBack,
      Function() settingsCallBack, Function() qrCodeCallBack) {
    return AppBar(
      leading: Transform.scale(
        scale: 3,
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: new Image.asset(
            'images/static/logo.png',
          ),
          tooltip: 'return to homepage',
          onPressed: () {},
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: generateDropDownButton(context, waitlistCallBack, settingsCallBack, qrCodeCallBack),
        ),
      ],
      backgroundColor: Color(0xFF376ADB),
    );
  }

  static Widget generateDropDownButton(BuildContext context, Function() waitlistCallBack,
      Function() settingsCallBack, Function() qrCodeCallBack) {
    return DropdownButton<String>(
        icon: Icon(Icons.menu),
        iconSize: 35,
        iconEnabledColor: Color(0xFFEDF6F6),
        style: TextStyle(
          color: Color(0xFFEDF6F6),
          fontSize: 35,
          fontFamily: "VisbyCF",
          fontWeight: FontWeight.bold,
        ),
        dropdownColor: Color(0xFF2B3148),
        underline: Container(
          height: 2,
          color: Color(0xFF376ADB),
        ),
        onChanged: (String newValue) {},
        items: [
          DropdownMenuItem<String>(
              value: "waitlist",
              child: FlatButton(
                onPressed: waitlistCallBack,
                child: Text(
                  "waitlist",
                  style: TextStyle(
                    color: Color(0xFFEDF6F6),
                    fontSize: 35,
                    fontFamily: "VisbyCF",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ),
          DropdownMenuItem<String>(
              value: "settings",
              child: FlatButton(
                onPressed: settingsCallBack,
                child: Text(
                  "settings",
                  style: TextStyle(
                    color: Color(0xFFEDF6F6),
                    fontSize: 35,
                    fontFamily: "VisbyCF",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ),
          DropdownMenuItem<String>(
              value: "QR code",
              child: FlatButton(
                onPressed: qrCodeCallBack,
                child: Text(
                  "QR code",
                  style: TextStyle(
                    color: Color(0xFFEDF6F6),
                    fontSize: 35,
                    fontFamily: "VisbyCF",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ),
        ]
    );
  }

}