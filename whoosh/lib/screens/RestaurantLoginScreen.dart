import 'package:flutter/material.dart';
import 'package:whoosh/commons/Commons.dart';
import 'package:whoosh/commons/RestaurantCommonWidget.dart';
import 'package:whoosh/entity/TextfieldErrorModalBuilder.dart';
import 'package:whoosh/route/route_names.dart';
import 'package:whoosh/screens/LoadingModal.dart';
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
  bool _isLoggedIn = false;
  bool _shouldDisplayEmailError = false;

  var email;
  var password;
  var currentError;
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
      backgroundColor: Commons.restaurantTheme.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RestaurantCommonWidget.generateHeading("log in"),
              RestaurantCommonWidget.generateField("email address",
                _emailOnChanged, false, email,
                TextfieldErrorModalBuilder.invalidEmail, currentError),
              RestaurantCommonWidget.generateField("password",
                (text) { password = text; }, true, password,
                TextfieldErrorModalBuilder.invalidPassword, currentError),
              RestaurantCommonWidget.generateRestaurantAuthenticationErrorText(errorText),
              SizedBox(height: 10),
              RestaurantCommonWidget.generateRestaurantScreenButton(Commons.enterButton, _loginUser(context)),
              RestaurantCommonWidget.generateRestaurantScreenButton(Commons.noAccountButton,
              () => {
                Navigator.of(context).pushNamed(restaurantSignupRoute)
              }),
              SizedBox(height: 100),
              Commons.bottomSea
            ]
          )
        )
      )
    );
  }

  void _emailOnChanged(String text) {
    email = text;

    bool isEmailValid = text != null && text.isValidEmailAddress;
    if (_shouldDisplayEmailError) {
      setState(() {
        currentError = isEmailValid ? null : TextfieldErrorModalBuilder.invalidEmail;
      });
    }
  }

  Function() _loginUser(BuildContext context) {
    return () async {
      LoadingModal waves = LoadingModal(context);
      showDialog(
        context: context,
        builder: (_) => waves
      );

      await loginOnFirebase(email, password);

      if (_isLoggedIn) {
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
      } else {
        waves.dismiss();
      }
    };
  }

  void loginOnFirebase(String email, String password) async {
    bool isValid = _validateFields(email, password);
    if (!isValid) {
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      setState(() {
        currentError = null;
        errorText = 'Log in successful!';
      });
      _isLoggedIn = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          currentError = null;
          errorText = 'No user found for this email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          currentError = TextfieldErrorModalBuilder.invalidPassword;
          errorText = 'Wrong password provided.';
        });
      }
    }
  }

  bool _validateFields(String email, String password) {
    if (email == null || email.length == 0 || !email.isValidEmailAddress) {
      setState(() {
        _shouldDisplayEmailError = true;
        currentError = TextfieldErrorModalBuilder.invalidEmail;
      });
      return false;
    }

    if (password == null || password.length == 0) {
      setState(() {
        currentError = TextfieldErrorModalBuilder.invalidPassword;
      });
      return false;
    }

    return true;
  }

}