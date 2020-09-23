import 'package:flutter/material.dart';
import 'package:whoosh/entity/CommonWidget.dart';
import 'package:whoosh/entity/Commons.dart';
import 'package:whoosh/screens/LoadingModal.dart';
import 'package:whoosh/screens/RestaurantSettingsScreen.dart';
import 'package:whoosh/requests/WhooshService.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/string_extensions.dart';


class RestaurantSignupScreen extends StatefulWidget {
  _RestaurantSignupScreenState createState() => _RestaurantSignupScreenState("", "", "", "");
}

class _RestaurantSignupScreenState extends State<RestaurantSignupScreen> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  bool _accountCreated = false;

  var restaurantName;
  var email;
  var password;
  var errorText;
  var restaurantId; // for registering restaurant

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
        backgroundColor: Commons.restaurantTheme.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget.generateWhooshHeading("sign up"),
                CommonWidget.generateField("restaurant name",
                        (text) { restaurantName = text; }, false, restaurantName),
                CommonWidget.generateField("email address",
                        (text) { email = text; }, false, email),
                CommonWidget.generateField("password",
                        (text) { password = text; }, true, password),
                CommonWidget.generateAuthenticationErrorText(errorText),
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

  Widget generateSignupButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: FlatButton(
        minWidth: 350,
        height: 40,
        color: Commons.whooshLightBlue,
        textColor: Commons.whooshTextWhite,
        onPressed: signupUser(context),
        child: FittedBox(
          child: Text(
              "i'm ready",
              style: TextStyle(
                fontFamily: Commons.whooshFont,
                fontSize: 25,
              )
          )
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      )
    );
  }

  Function() signupUser(BuildContext context) {
    return () async {
      LoadingModal waves = LoadingModal(context);
      showDialog(
          context: context,
          builder: (_) => waves
      );

      await registerNewUserOnFirebase(email, password);

      if (_accountCreated) {
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
      } else {
        waves.dismiss();
      }
    };
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
          child: FittedBox(
            child: Text(
                "i already have an account",
                style: TextStyle(
                  fontFamily: Commons.whooshFont,
                  fontSize: 25,
                )
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
    bool _isValid = _validateFields(restaurantName, email, password);
    if (!_isValid) {
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      setState(() {
        errorText = "Account created.";
        _accountCreated = true;
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

  bool _validateFields(String restaurantName, String email, String password) {
    if (restaurantName == null || restaurantName.length == 0) {
      setState(() {
        errorText = "Please enter your restaurant name.";
      });
      return false;
    }

    if (email == null || email.length == 0 || !email.isValidEmailAddress) {
      setState(() {
        errorText = "Please enter a valid email address.";
      });
      return false;
    }

    if (password == null || password.length == 0) {
      setState(() {
        errorText = "Please enter your password.";
      });
      return false;
    }
    return true;
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