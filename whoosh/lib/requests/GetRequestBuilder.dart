import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:whoosh/requests/RequestBuilder.dart';

class GetRequestBuilder extends RequestBuilder {
  @override
  Future<http.Response> sendRequest() async {
    mountRequest();
    log('GET request to:' + finalUrl);
    return http.get(finalUrl);
  }
}