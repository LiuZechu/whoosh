import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//void main() {
//  runApp(App());
//}

class RestaurantSignupScreen extends StatefulWidget {
  _RestaurantSignupScreenState createState() => _RestaurantSignupScreenState(null, null, null);
}

class _RestaurantSignupScreenState extends State<RestaurantSignupScreen> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // text field inputs
  var restaurantName;
  var email;
  var password;

  _RestaurantSignupScreenState(this.restaurantName, this.email, this.password);

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return Text("error");
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Text("Loading...");
    }

    return Scaffold(
        backgroundColor: Color(0xFF2B3148),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                generateWhooshHeading(),
                generateField("restaurant name", (text) { restaurantName = text; }, false),
                generateField("email address", (text) { email = text; }, false),
                generateField("password", (text) { password = text; }, true),
                SizedBox(height: 30),
                generateSignupButton(context),
                generateLoginButton(context),
                SizedBox(height: 100),
                generateBottomImage(),
              ]
            )
          )
        )
    );
  }

  Widget generateWhooshHeading() {
    return Column(
        children: [
          new Image.asset(
            'images/static/whoosh_heading.png',
          ),
          Container(
              width: 400,
              margin: const EdgeInsets.all(20.0),
              child: Text(
                'sign up',
                style: TextStyle(
                  color: Color(0xFFEDF6F6),
                  fontSize: 40,
                  fontFamily: "VisbyCF",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              )
          )
        ]
    );
  }

  Widget generateField(String fieldName, Function(String text) onChanged, bool isObscureText) {
    return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  width: 400,
                  child: Text(
                    fieldName,
                    style: TextStyle(
                      fontFamily: "VisbyCF",
                      fontSize: 20,
                      color: Color(0xFFEDF6F6),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 400,
                  child: TextField(
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                        ),
                      ),
                      contentPadding: EdgeInsets.only(bottom: 10, top: 10, left: 20),
                      fillColor: Color(0xFFEDF6F6),
                      filled: true,
                    ),
                    style: TextStyle(
                        fontFamily: "VisbyCF",
                        fontSize: 25,
                        color: Color(0xFF2B3148)
                    ),
                    onChanged: onChanged,
                    obscureText: isObscureText,
                  ),
                ),
              ]
            ),
        );
  }

  Widget generateSignupButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ButtonTheme(
          minWidth: 400,
          height: 40,
          child: FlatButton(
            color: Color(0xFF376ADB),
            textColor: Color(0xFFEDF6F6),
            onPressed: () => {

            },
            child: Text(
                "i'm ready",
                style: TextStyle(
                  fontFamily: "VisbyCF",
                  fontSize: 25,
                )
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          )
        )
    );
  }

  Widget generateLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ButtonTheme(
        minWidth: 400,
        height: 40,
        child: FlatButton(
          color: Color(0xFFEDF6F6),
          textColor: Color(0xFF2B3148),
          onPressed: () => {

          },
          child: Text(
              "i already have an account",
              style: TextStyle(
                fontFamily: "VisbyCF",
                fontSize: 25,
              )
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        )
      )
    );
  }

  Widget generateBottomImage() {
    return new Image.asset(
      'images/static/bottom_sea.png',
    );
  }

}