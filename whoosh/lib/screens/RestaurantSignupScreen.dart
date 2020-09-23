import 'package:flutter/material.dart';
import 'package:whoosh/entity/Commons.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/requests/WhooshService.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/string_extensions.dart';


class RestaurantSignupScreen extends StatefulWidget {
  _RestaurantSignupScreenState createState() => _RestaurantSignupScreenState(null, null, null, "");
}

class _RestaurantSignupScreenState extends State<RestaurantSignupScreen> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  bool _account_created = false;

  // text field inputs
  var restaurantName;
  var email;
  var password;

  var errorText;

  // for registering restaurant
  var restaurantId;

  _RestaurantSignupScreenState(this.restaurantName, this.email, this.password, this.errorText);

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
                generateField("restaurant name", (text) { restaurantName = text; }, false),
                generateField("email address", (text) { email = text; }, false),
                generateField("password", (text) { password = text; }, true),
                generateErrorText(errorText),
                SizedBox(height: 30),
                generateSignupButton(context),
                generateLoginButton(context),
                SizedBox(height: 100),
                Commons.bottomSea,
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
                'sign up',
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
                        color: Commons.whooshDarkBlue,
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

  Widget generateSignupButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ButtonTheme(
          minWidth: 350,
          height: 40,
          child: FlatButton(
            color: Commons.whooshLightBlue,
            textColor: Commons.whooshTextWhite,
            onPressed: () async {
              await registerNewUserOnFirebase(email, password);
              if (_account_created) {
                FirebaseAuth auth = FirebaseAuth.instance;
                if (auth.currentUser != null) {
                  var uid = auth.currentUser.uid;
                  await registerRestaurant(restaurantName, uid);
                }

                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => RestaurantSettingsScreen(restaurantName, restaurantId)
                    )
                );
              }
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
        minWidth: 350,
        height: 40,
        child: FlatButton(
          color: Commons.whooshTextWhite,
          textColor: Commons.whooshDarkBlue,
          onPressed: () => {
            Navigator.of(context).pushNamed('/restaurant/login')
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

  void registerNewUserOnFirebase(String email, String password) async {
    if (restaurantName == null || restaurantName.length == 0) {
      setState(() {
        errorText = "Please enter your restaurant name.";
      });
      return;
    }

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
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      setState(() {
        errorText = "Account created.";
        _account_created = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorText = 'The password provided is too weak.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          errorText = 'The account already exists for that email.';
        });
      }
    } catch (e) {
      setState(() {
        errorText = e.toString();
      });
    }
  }

  void registerRestaurant(String restaurantName, String uid) async {
    dynamic data = await WhooshService.registerRestaurant(restaurantName, 5, "", "", uid);
    int currentRestaurantId = data['restaurant_id'];
    if (this.mounted) {
      setState(() {
        restaurantId = currentRestaurantId;
      });
    }
  }

}