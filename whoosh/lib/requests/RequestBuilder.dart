
import 'package:http/http.dart';

abstract class RequestBuilder {
  static final String baseUrl = 'https://whoosh-server.herokuapp.com/';
  static final authorisationToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
      + "eyJ1c2VybmFtZSI6Indob29zaCIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTYwMDc0MzcxM30."
      + "_PEM8wazmqZGcgRsX-SH2pxFpIoFQzvXdxBLc6ny-y8";
  List<String> paths = [];
  Map<String, String> params = new Map();
  String finalUrl = baseUrl;

  RequestBuilder addPath(String pathname) {
    paths.add(pathname);
    return this;
  }

  RequestBuilder addParams(String param, String value) {
    params[param] = value;
    return this;
  }

  void mountRequest() async {
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
    finalUrl = url;
  }

  Future<Response> sendRequest();
}