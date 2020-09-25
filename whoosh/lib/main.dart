import 'package:flutter/material.dart';
import 'route/Router.dart' as router;
import 'package:pwa/client.dart' as pwa;

void main() {
  new pwa.Client();
  runApp(WhooshApp());
}

class WhooshApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whoosh',
      onGenerateRoute: router.generateRoute
    );
  }
}
