
import 'dart:convert';
import 'package:http/http.dart';
import 'GetRequestBuilder.dart';

class Service {
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
}