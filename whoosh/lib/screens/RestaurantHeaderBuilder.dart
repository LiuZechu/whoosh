import 'package:flutter/material.dart';
import 'package:whoosh/entity/Commons.dart';

class RestaurantHeaderBuilder {

  static Widget generateHeader(BuildContext context, Function() waitlistCallBack,
      Function() settingsCallBack, Function() qrCodeCallBack) {
    return AppBar(
      leading: Transform.scale(
        scale: 3,
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Commons.whooshLogo,
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
      backgroundColor: Commons.whooshLightBlue,
    );
  }

  static Widget generateDropDownButton(BuildContext context, Function() waitlistCallBack,
      Function() settingsCallBack, Function() qrCodeCallBack) {
    return DropdownButton<String>(
        icon: Icon(Icons.menu),
        iconSize: 35,
        iconEnabledColor: Commons.whooshTextWhite,
        style: TextStyle(
          color: Commons.whooshTextWhite,
          fontSize: 35,
          fontFamily: "VisbyCF",
          fontWeight: FontWeight.bold,
        ),
        dropdownColor: Commons.whooshDarkBlue,
        underline: Container(
          height: 2,
          color: Commons.whooshLightBlue,
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
                    color: Commons.whooshTextWhite,
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
                    color: Commons.whooshTextWhite,
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
                    color: Commons.whooshTextWhite,
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