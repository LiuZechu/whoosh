import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Commons {
  static List<Color> monsterColors = [
    Color(0xFF376ADB),
    Color(0xFF398EB2),
    Color(0xFF415AB2),
    Color(0xFF44AB92),
    Color(0xFF4B41BB),
    Color(0xFF4C7FBA),
    Color(0xFF4EB57D),
    Color(0xFF4FB99F),
    Color(0xFF52AA5B),
    Color(0xFF57A5C7),
    Color(0xFF5B70BA),
    Color(0xFF5DAEBF),
    Color(0xFF62E0C9),
    Color(0xFF64B049),
    Color(0xFF655CCF),
    Color(0xFF6990BE),
    Color(0xFF6C3FCB),
    Color(0xFF6FC1D2),
    Color(0xFF6FC597),
    Color(0xFF756B6B),
    Color(0xFF7ABC81),
    Color(0xFF81C7E4),
    Color(0xFF83B049),
    Color(0xFF83EF8E),
    Color(0xFF8660D8),
    Color(0xFF87C771),
    Color(0xFF8A81ED),
    Color(0xFF8D4CAC),
    Color(0xFF8EA2EB),
    Color(0xFF90B8E5),
    Color(0xFF938686),
    Color(0xFF96E2F2),
    Color(0xFF9AE9BE),
    Color(0xFF9BBE37),
    Color(0xFF9E9090),
    Color(0xFFA167BC),
    Color(0xFFA1C771),
    Color(0xFFA4EA8B),
    Color(0xFFAE8DF3),
    Color(0xFFAF63D2),
    Color(0xFFB0A1A1),
    Color(0xFFB44949),
    Color(0xFFB6D65C),
    Color(0xFFBBED7B),
    Color(0xFFBE614C),
    Color(0xFFC14CC3),
    Color(0xFFC277E5),
    Color(0xFFC5C83C),
    Color(0xFFC89B58),
    Color(0xFFCBE878),
    Color(0xFFCD8DEC),
    Color(0xFFCD99E5),
    Color(0xFFCED06C),
    Color(0xFFD07E4F),
    Color(0xFFD1BFBF),
    Color(0xFFD8B252),
    Color(0xFFD96DDB),
    Color(0xFFDA6363),
    Color(0xFFDA7863),
    Color(0xFFDB638E),
    Color(0xFFE5B977),
    Color(0xFFE5C677),
    Color(0xFFE698E8),
    Color(0xFFE7E98A),
    Color(0xFFEA9464),
    Color(0xFFEA95B3),
    Color(0xFFEE76A1),
    Color(0xFFEF8A74),
    Color(0xFFF39090),
    Color(0xFFF9A373),
    Color(0xFFFAB856),
    Color(0xFFFFD15B),
    Color(0xFFAE0707),
    Color(0xFFB1714C),
    Color(0xFFBE6614),
    Color(0xFFC88576),
    Color(0xFFCD4141),
    Color(0xFFCE711B),
    Color(0xFFCE875E),
    Color(0xFFD4563A),
    Color(0xFFDD7439),
    Color(0xFFE29F3A),
    Color(0xFFE45B5B),
    Color(0xFFE78D5A),
    Color(0xFFE7B330),
    Color(0xFFE8C9A4),
    Color(0xFFEF9A87),
    Color(0xFFF3AF89),
    Color(0xFFF5C957),
    Color(0xFFFDEE69),
  ];

  // Group assets
  static final AssetImage queueLine = AssetImage('images/static/queue_line.png');
  static final AssetImage nameBubble = AssetImage('images/static/name_bubble.png');
  static final AssetImage randomizeButton = AssetImage('images/static/randomize_button.png');
  static final AssetImage restaurantMenuButton = AssetImage('images/static/restaurant_menu_button.png');
  static final AssetImage shareQueueButton = AssetImage('images/static/share_queue_button.png');

  // Screen assets
  static final Image whooshLogo = Image.asset('images/static/logo.png');
  static final Image whooshHeading = Image.asset('images/static/whoosh_heading.png');
  static final Image bottomSea = Image.asset('images/static/bottom_sea.png');
  static final Image welcomeMonster1 = Image.asset('images/static/restaurant_welcome_monster1.png');
  static final Image welcomeMonster2 = Image.asset("images/static/restaurant_welcome_monster2.png");
  static final AssetImage enterQueueButton = AssetImage('images/static/enter_queue_button.png');
  static final AssetImage refreshButton = AssetImage('images/static/refresh_button.png');
  static final AssetImage counter = AssetImage('images/static/counter.png');

  // Flare actor paths
  static final String bodyFlareActorPath = 'images/actors/body.flr';
  static final String eyesFlareActorPath = 'images/actors/eyes.flr';
  static final String mouthsFlareActorPath = 'images/actors/mouths.flr';
  static final String accessoriesFlareActorPath = 'images/actors/accessories.flr';
  static final String waveFlareActorPath = 'images/actors/wave.flr';

  // Colors
  static final Color whooshDarkBlue = Color(0xFF2B3148);
  static final Color whooshTextWhite = Color(0xFFEDF6F6);
  static final Color whooshLightBlue = Color(0xFF376ADB);
  static final Color whooshOffWhite = Color(0xFFD1E6F2);
  static final Color whooshErrorPink = Color(0xFFF3C2C2);
  static final Color whooshErrorRed = Color(0xFF9A0000);
}