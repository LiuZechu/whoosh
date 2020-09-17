
import 'dart:convert';
import 'package:http/http.dart';
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
      String monsterTypes, String emailAddress) async {
    Response response = await PostRequestBuilder()
        .addBody(<String, String>{
          "group_name": groupName, // need to add word bank
          "group_size": groupSize.toString(),
          "monster_type": monsterTypes,
          "queue_status": "0",
          "email": emailAddress,
        })
        .addPath('restaurants')
        .addPath(restaurantId.toString())
        .addPath('groups')
        .sendRequest();
    dynamic data = jsonDecode(response.body);
    return data;
  }
}