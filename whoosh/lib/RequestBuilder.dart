
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RequestBuilder {
  final String baseUrl = 'https://whoosh-server.herokuapp.com/';
  List<String> paths = [];
  Map<String, String> params = new Map();

  RequestBuilder addPath(String pathname) {
    paths.add(pathname);
    return this;
  }

  RequestBuilder addParams(String param, String value) {
    params[param] = value;
    return this;
  }

  Future<Response> sendRequest() async {
    String url = baseUrl;
    for (var path in paths) {
      url += path + '/';
    }
    url = url.substring(0, url.length - 1);
    if (params.isNotEmpty) {
      url += '?';
      params.forEach((key, value) {
        url += key + '=' + value + '&';
      });
      url = url.substring(0, url.length - 1);
    }
    return http.get(url);
  }
}