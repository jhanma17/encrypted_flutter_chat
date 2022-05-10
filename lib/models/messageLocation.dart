class MessageLocation {
  final double lat;
  final double lng;

  MessageLocation(this.lat, this.lng);

  factory MessageLocation.fromJson(dynamic json) {
    return MessageLocation(
      json['lat'] as double,
      json['lng'] as double,
    );
  }
}
