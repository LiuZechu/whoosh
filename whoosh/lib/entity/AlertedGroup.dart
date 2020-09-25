import 'package:flutter/cupertino.dart';
import 'package:whoosh/entity/Group.dart';

class AlertedGroup extends Group {
  AlertedGroup(data) : super(data);

  @override
  Widget generateNumberOfGroupsAheadLabel(int noOfGroupsAhead) {
    return generateQueueStatusLabel('It\'s your turn!');
  }
}