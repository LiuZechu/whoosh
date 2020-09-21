import 'package:flutter/material.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/screens/RestaurantQueueScreen.dart';
import 'package:whoosh/requests/WhooshService.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        backgroundColor: Color(0xFF2B3148),
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
                'log in',
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
            minWidth: 400,
            height: 40,
            child: FlatButton(
              color: Color(0xFF376ADB),
              textColor: Color(0xFFEDF6F6),
              onPressed: () async {
                await loginOnFirebase(email, password);
                if (_is_logged_in) {
                  // get restaurant ID
                  FirebaseAuth auth = FirebaseAuth.instance;
                  if (auth.currentUser != null) {
                    var uid = auth.currentUser.uid;
                    dynamic data = await WhooshService.getRestaurantDetailsWithUid(uid);
                    restaurantId = data["restaurant_id"];
                  }
                  // go to view queue screen
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RestaurantQueueScreen(restaurantId)
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
            minWidth: 400,
            height: 40,
            child: FlatButton(
              color: Color(0xFFEDF6F6),
              textColor: Color(0xFF2B3148),
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

  Widget generateBottomImage() {
    return new Image.asset(
      'images/static/bottom_sea.png',
    );
  }

  void loginOnFirebase(String email, String password) async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (email == null || email.length == 0 || !emailValid) {
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