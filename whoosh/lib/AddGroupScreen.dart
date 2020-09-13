import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:whoosh/Group.dart';

// http://localhost:${port}/#/joinQueue?restaurant_id=1
class AddGroupScreen extends StatelessWidget {
  final int restaurantId;

  AddGroupScreen(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E6F2),
      body: ListView(
        children: [
          generateHeader(),
          JoinQueueCard(restaurantId)
        ],
      ),
    );
  }

  Widget generateHeader() {
    return AppBar(
      leading: Transform.scale(
        scale: 3,
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: new Image.asset(
            'images/logo.png',
          ),
          tooltip: 'return to homepage',
          onPressed: () {},
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.menu),
        ),
      ],
      backgroundColor: Color(0xFF376ADB),
    );
  }

}

class JoinQueueCard extends StatefulWidget {
  final int restaurantId;

  JoinQueueCard(this.restaurantId);

  @override
  _JoinQueueCardState createState() => _JoinQueueCardState(restaurantId);
}

class _JoinQueueCardState extends State<JoinQueueCard> {
  final int restaurantId;
  String restaurantName = 'Loading...';
  double newGroupSize = 1;
  String emailAddress = '';
  double buttonOpacity = 1.0;

  _JoinQueueCardState(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    Group newGroup = Group.fromSize(newGroupSize.round());
    return Container(
      child: Column(
        children: [
          generateRestaurantName(),
          newGroup.createJoinQueueGroupImage(),
          generateEmailAddressField(),
          SizedBox(height: 20),
          generateGroupSizeSlider(),
          SizedBox(height: 20),
          generateEnterQueueButton(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  void fetchRestaurantDetails() async {
    String url = 'https://whoosh-server.herokuapp.com/restaurants/'
        + restaurantId.toString();
    Response response = await http.get(url);
    List<dynamic> data = json.decode(response.body);
    String currentRestaurantName = data[0]['restaurant_name'];
    setState(() {
      restaurantName = currentRestaurantName;
    });
  }

  Widget generateEmailAddressField() {
    return Container(
      width: 350,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'email address',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF2B3148),
                  fontFamily: "VisbyCF"
              ),
            ),
          ),
          Container(
            height: 70,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFEDF6F6),
                  ),
                  onChanged: (text) {
                    emailAddress = text;
                  },
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget generateGroupSizeSlider() {
    return Container(
      width: 350,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'group size',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF2B3148),
                  fontFamily: "VisbyCF"
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFFEDF6F6),
              inactiveTrackColor: Color(0xFFEDF6F6),
              inactiveTickMarkColor: Color(0xFFEDF6F6),
            ),
            child: Slider(
              value: newGroupSize,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (double value) {
                setState(() {
                  newGroupSize = value;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              newGroupSize.round().toString(),
              style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFF2B3148),
                  fontFamily: "VisbyCF",
                  fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void setButtonOpacityTo(double opacity) {
    setState(() {
      buttonOpacity = opacity;
    });
  }

  Widget generateEnterQueueButton() {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setButtonOpacityTo(0.5);
      },
      onTapCancel: () {
        setButtonOpacityTo(1.0);
      },
      onTapUp: (TapUpDetails details) {
        setButtonOpacityTo(1.0);
      },
      onTap: () {
        //add group to queue
        log('adding group of size ' + newGroupSize.toString() + ' to queue');
      },
      child: Opacity(
        opacity: buttonOpacity,
        child: Image(image: AssetImage('images/enter_queue_button.png')),
      )
    );
  }

  Widget generateRestaurantName() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'you\'re queueing for',
            style: TextStyle(
                fontSize: 18,
                fontFamily: "VisbyCF"
            ),
          ),
          Container(
            width: 400,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('images/restaurant_icon.png'),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  constraints: BoxConstraints(minWidth: 0, maxWidth: 340),
                  child: FittedBox(
                    child: Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: "VisbyCF",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
