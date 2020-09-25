class UrlUtil {
  static String generateQueueUrl(int restaurantId, int groupId, String groupKey) {
    return '/queue?restaurant_id='
        + restaurantId.toString()
        + '&group_id='
        + groupId.toString()
        + '&group_key='
        + groupKey;
  }

  static String generateEntireQueueUrl(int restaurantId, int groupId, String groupKey) {
    return 'https://hoholyin.github.io/whoosh/#' + generateQueueUrl(restaurantId, groupId, groupKey);
  }

  static String generateQrCodeUrl(int restaurantId) {
    String googleQrCodeUrl = 'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=';
    String hostUrl = 'https%3A%2F%2Fhoholyin.github.io%2Fwhoosh%2F%23%2FjoinQueue%3Frestaurant_id%3D${restaurantId}';
    String qrCodeUrl = googleQrCodeUrl + hostUrl;
    return qrCodeUrl;
  }

}