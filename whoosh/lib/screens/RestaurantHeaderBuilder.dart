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
          child: _generateDropDownButton(context, waitlistCallBack, settingsCallBack, qrCodeCallBack),
        ),
      ],
      backgroundColor: Commons.whooshLightBlue,
    );
  }

  static Widget _generateDropDownButton(BuildContext context, Function() waitlistCallBack,
      Function() settingsCallBack, Function() qrCodeCallBack) {
    return DropdownButton<String>(
        icon: Icon(Icons.menu),
        iconSize: 35,
        iconEnabledColor: Commons.whooshTextWhite,
        style: TextStyle(
          color: Commons.whooshTextWhite,
          fontSize: 35,
          fontFamily: Commons.whooshFont,
          fontWeight: FontWeight.bold,
        ),
        dropdownColor: Commons.whooshDarkBlue,
        underline: Container(
          height: 2,
          color: Commons.whooshLightBlue,
        ),
        onChanged: (String newValue) {},
        items: [
          _generateMenuItem("waitlist", waitlistCallBack),
          _generateMenuItem("settings", settingsCallBack),
          _generateMenuItem("QR code", qrCodeCallBack),
        ]
    );
  }

  static DropdownMenuItem<String> _generateMenuItem(String text, Function() callBack) {
    return DropdownMenuItem<String>(
        value: text,
        child: FlatButton(
          onPressed: callBack,
          child: Text(
            text,
            style: TextStyle(
              color: Commons.whooshTextWhite,
              fontSize: 35,
              fontFamily: Commons.whooshFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
    );
  }

}