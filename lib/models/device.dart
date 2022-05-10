class Device {
  final String id;
  final String model;
  final String device;

  Device(this.id, this.model, this.device);

  factory Device.fromJson(dynamic json) {
    return Device(json['id'] as String, json['model'] as String,
        json["device"] as String);
  }
}
