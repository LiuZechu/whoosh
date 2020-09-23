import '../route/RoutingData.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }

  String prependHttpIfAbsent() {
    if (this.substring(0, 4) != 'http') {
      String result = 'http://' + this;
      return result;
    }
    return this;
  }

  bool get isValidEmailAddress {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }
}