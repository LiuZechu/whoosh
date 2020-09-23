import 'package:flutter/material.dart';
import 'package:whoosh/entity/Commons.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/screens/RestaurantQueueScreen.dart';
import 'package:whoosh/requests/WhooshService.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/string_extensions.dart';

class RestaurantLoginScreen extends StatefulWidget {
  _RestaurantLoginScreenState createState() => _RestaurantLoginScreenState("", "", "");
}

class _RestaurantLoginScreenState extends State<RestaurantLoginScreen> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  bool _is_logged_in = false;

  var email;
  var password;
  var errorText;
  var restaurantId = -1;
  var restaurantName = "";

  _RestaurantLoginScreenState(this.email, this.password, this.errorText);

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
        backgroundColor: Commons.whooshDarkBlue,
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    children: [
                      generateWhooshHeading(),
                      generateField("email address", (text) { email = text; }, false),
                      generateField("password", (text) { password = text; }, true),
                      generateErrorText(errorText),
                      SizedBox(height: 30),
                      generateLoginButton(context),
                      generateSignupButton(context),
                      SizedBox(height: 100),
                      Commons.bottomSea
                    ]
                )
            )
        )
    );
  }

  Widget generateWhooshHeading() {
    return Column(
        children: [
          Commons.whooshHeading,
          Container(
              width: 350,
              margin: const EdgeInsets.all(20.0),
              child: Text(
                'log in',
                style: TextStyle(
                  color: Commons.whooshTextWhite,
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
                    fontFamily: "VisbyCF",
                    fontSize: 25,
                    color: Commons.whooshDarkBlue
                ),
                onChanged: onChanged,
                obscureText: isObscureText,
              ),
            ),
          ]
      ),
    );
  }

  Widget generateErrorText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "VisbyCF",
        fontSize: 25,
        color: Colors.red,
      ),
    );
  }

  Widget generateLoginButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ButtonTheme(
            minWidth: 350,
            height: 40,
            child: FlatButton(
              color: Commons.whooshLightBlue,
              textColor: Commons.whooshTextWhite,
              onPressed: () async {
                await loginOnFirebase(email, password);
                if (_is_logged_in) {
                  // get restaurant ID
                  FirebaseAuth auth = FirebaseAuth.instance;
                  if (auth.currentUser != null) {
                    var uid = auth.currentUser.uid;
                    dynamic data = await WhooshService.getRestaurantDetailsWithUid(uid);
                    restaurantId = data["restaurant_id"];
                    restaurantName = data["restaurant_name"];
                  }
                  // go to view queue screen
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RestaurantQueueScreen(restaurantName, restaurantId)
                      )
                  );
                }
              },
              child: Text(
                  "enter",
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

  Widget generateSignupButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ButtonTheme(
            minWidth: 350,
            height: 40,
            child: FlatButton(
              color: Commons.whooshTextWhite,
              textColor: Commons.whooshDarkBlue,
              onPressed: () => {
                Navigator.of(context).pushNamed('/restaurant/signup')
              },
              child: Text(
                  "i don't have an account",
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

  void loginOnFirebase(String email, String password) async {
    if (email == null || email.length == 0 || !email.isValidEmailAddress) {
      setState(() {
        errorText = "Please enter a valid email address.";
      });
      return;
    }

    if (password == null || password.length == 0) {
      setState(() {
        errorText = "Please enter your password.";
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      setState(() {
        errorText = 'Log in successful!';
      });
      _is_logged_in = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorText = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorText = 'Wrong password provided for that user.';
        });
      }
    }

  }

}