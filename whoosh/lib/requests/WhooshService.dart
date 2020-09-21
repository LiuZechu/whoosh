import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:whoosh/requests/PutRequestBuilder.dart';
import 'package:whoosh/requests/QueueCache.dart';
import 'package:whoosh/requests/RequestBuilder.dart';
import 'GetRequestBuilder.dart';
import 'PostRequestBuilder.dart';

class WhooshService {
  static final QueueCache queueCache = QueueCache();

  static Future<List<dynamic>> getAllGroupsInQueue(int restaurantId) async {
    try {
      bool shouldTry = true;
      Response response;
      new Timer(Duration(seconds: 5), () => shouldTry = false);
      while (shouldTry && (response == null || response.statusCode != 200)) {
        try {
          response = await GetRequestBuilder()
              .addPath('restaurants')
              .addPath(restaurantId.toString())
              .addPath('groups')
              .addParams('status', '0')
              .sendRequest();
        } catch (err) {
          log(err.toString());
        }
      }
      if (response.statusCode != 200) {
        return queueCache.getAllGroupsInQueue(restaurantId);
      }
      List<dynamic> data = json.decode(response.body);
      queueCache.addGroupsInQueue(restaurantId, data);
      return data;
    } catch (err) {
      log(err.toString());
      log('Unable to retrieve queue data from network. Retrieving from cache...');
      return queueCache.getAllGroupsInQueue(restaurantId);
    }
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
          "group_name": groupName,
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

  static Future<dynamic> registerRestaurant(String restaurantName, int estimatedWaitingTime, String menuUrl, String iconUrl, String uid) async {
    Response response = await PostRequestBuilder()
        .addBody(<String, String>{
          "restaurant_name": restaurantName,
          "unit_queue_time": estimatedWaitingTime.toString(),
          "menu_url": menuUrl,
          "icon_url": iconUrl,
          "uid": uid
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

  static Future<dynamic> getRestaurantDetailsWithUid(String uid) async {
    Response response = await GetRequestBuilder()
        .addPath('restaurants')
        .addParams('uid', uid)
        .sendRequest();
    List<dynamic> data = json.decode(response.body);
    return data.single;
  }

  static Future<dynamic> updateRestaurantDetails(int restaurantId, String restaurantName,
      int waitingTime, String iconUrl, String menuUrl) async {
    Response response = await PutRequestBuilder()
        .addBody(<String, String>{
      "restaurant_name": restaurantName,
      "unit_queue_time": waitingTime.toString(),
      "icon_url": iconUrl,
      "menu_url": menuUrl
    })
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }

  static String generateQueueUrl(int restaurantId, int groupId) {
    return '/queue?restaurant_id='
        + restaurantId.toString()
        + '&group_id='
        + groupId.toString();
  }

  static String generateEntireQueueUrl(int restaurantId, int groupId) {
    return 'https://hoholyin.github.io/whoosh/#' + generateQueueUrl(restaurantId, groupId);
  }

}