import 'package:flutter/material.dart';
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

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B3149),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 456,
          child: Card(
            child: WelcomeCard(),
          ),
        ),
      ),
    );
  }
}

class WelcomeCard extends StatefulWidget {
  @override
  _WelcomeCardState createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  void showQueueScreen() {
    Navigator.of(context).pushNamed('/queue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF6F7),
      body: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage('images/static/landing.png'),
              width: 400.0,
              height: 400.0,
              fit: BoxFit.cover,
            ),
            ButtonTheme(
              minWidth: 400,
              height: 48,
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: showQueueScreen,
                child: Text('JOIN A QUEUE'),
              ),
            ),
          ],
        )
      ),
    );
  }
}

