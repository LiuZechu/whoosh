
import 'dart:convert';
import 'package:http/http.dart';
import 'package:whoosh/requests/PutRequestBuilder.dart';
import 'GetRequestBuilder.dart';
import 'PostRequestBuilder.dart';

class WhooshService {
  static Future<List<dynamic>> getAllGroupsInQueue(int restaurantId) async {
    Response response = await GetRequestBuilder()
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .addPath('groups')
        .addParams('status', '0')
        .sendRequest();
    List<dynamic> data = json.decode(response.body);
    return data;
  }

  static Future<dynamic> getRestaurantDetails(int restaurantId) async {
    Response response = await GetRequestBuilder()
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .sendRequest();
    List<dynamic> data = json.decode(response.body);
    return data.single;
  }

  static Future<dynamic> joinQueue(int restaurantId, String groupName, int groupSize,
      String monsterTypes, String phoneNumber) async {
    Response response = await PostRequestBuilder()
        .addBody(<String, String>{
          "group_name": groupName, // need to add word bank
          "group_size": groupSize.toString(),
          "monster_type": monsterTypes,
          "queue_status": "0",
          "phone_number": phoneNumber,
        })
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .addPath('groups')
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }

  static Future<dynamic> registerRestaurant(String restaurantName, int estimatedWaitingTime, String menuUrl, String iconUrl) async {
    Response response = await PostRequestBuilder()
        .addBody(<String, String>{
          "restaurant_name": restaurantName,
          "unit_queue_time": estimatedWaitingTime.toString(),
          "menu_url": menuUrl,
          "icon_url": iconUrl,
        })
        .addPath('restaurants')
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }

  static Future<dynamic> updateGroupTypes(int groupId, int restaurantId, String monsterType) async {
    Response response = await PutRequestBuilder()
        .addBody(<String, String>{
          "monster_type": monsterType
        })
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .addPath('groups')
        .addPath(groupId.toString())
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }

  static Future<dynamic> updateQueueStatus(int statusCode, int groupId, int restaurantId) async {
    Response response = await PutRequestBuilder()
        .addBody(<String, String>{
      "queue_status": statusCode.toString()
    })
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .addPath('groups')
        .addPath(groupId.toString())
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }

  static Future<dynamic> sendSmsToGroup(String phone_number, String text) async {
    Response response = await PostRequestBuilder()
        .addBody(<String, String>{
      "phone_number": phone_number,
      "text": text
    })
        .addPath('sms')
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }

}