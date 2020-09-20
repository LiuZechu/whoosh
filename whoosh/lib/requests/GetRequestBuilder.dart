import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:whoosh/requests/RequestBuilder.dart';

class GetRequestBuilder extends RequestBuilder {
  @override
  Future<http.Response> sendRequest() async {
    mountRequest();
    log(DateTime.now().toString() + ' GET request to:' + finalUrl);
    return http.get(finalUrl);
  }
}