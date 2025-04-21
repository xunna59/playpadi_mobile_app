class EventCenter {
  final String name;
  final String location;
  final String price;
  final List<String> availableTimes;

  EventCenter({
    required this.name,
    required this.location,
    required this.price,
    required this.availableTimes,
  });

  factory EventCenter.fromJson(Map<String, dynamic> json) {
    return EventCenter(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? '',
      availableTimes: List<String>.from(json['available_times'] ?? []),
    );
  }
}
