import 'package:flutter/material.dart';
import 'package:whoosh/entity/Commons.dart';
import 'route/Router.dart' as router;

void main() => runApp(WhooshApp());

class WhooshApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whoosh',
      onGenerateRoute: router.generateRoute
    );
  }
}
