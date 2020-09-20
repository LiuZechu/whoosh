class QueueCache {
  final Map queue = new Map();

  void addGroupsInQueue(int restaurantId, List<dynamic> data) {
    queue[restaurantId] = data;
  }

  List<dynamic> getAllGroupsInQueue(int restaurantId) {
    if (!queue.containsKey(restaurantId)) {
      List<dynamic> emptyList = [];
      return emptyList;
    }
    List<dynamic> groups = queue[restaurantId];
    return groups;
  }
}