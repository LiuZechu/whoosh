import 'package:flutter/material.dart';
import 'package:whoosh/AddGroupScreen.dart';
import 'package:whoosh/QueueScreen.dart';
import 'package:whoosh/main.dart';
import 'package:whoosh/route_names.dart';
import 'string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData; // Get the routing Data
  switch (routingData.route) {
    case welcomeRoute:
      return _getPageRoute(WelcomeScreen(), settings);
    case queueRoute:
      int restaurantId = int.tryParse(routingData['restaurant_id']);
      int groupId = int.tryParse(routingData['group_id']);
      return _getPageRoute(QueueScreen(restaurantId, groupId), settings);
    case addGroupRoute:
      int restaurantId = int.tryParse(routingData['restaurant_id']);
      return _getPageRoute(AddGroupScreen(restaurantId), settings);
    default:
      return _getPageRoute(WelcomeScreen(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({this.child, this.routeName})
      : super(
    settings: RouteSettings(name: routeName),
    pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,) =>
    child,
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}
