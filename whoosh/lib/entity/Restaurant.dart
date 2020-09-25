class Restaurant {
  int id;
  String name;
  int unitQueueTime;
  String menuUrl;
  String iconUrl;

  Restaurant(dynamic data) {
    id = data['restaurant_id'];
    name = data['restaurant_name'];
    unitQueueTime = data['unit_queue_time'];
    menuUrl = data['menu_url'];
    iconUrl = data['icon_url'];
  }

  Restaurant.empty(int restaurantId) {
    id = restaurantId;
    name = "-";
    unitQueueTime = 5;
    menuUrl = "";
    iconUrl = "";
  }
}