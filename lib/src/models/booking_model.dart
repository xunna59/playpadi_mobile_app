class BookingTime {
  final String time;
  final String status;

  BookingTime({required this.time, required this.status});

  // Factory method to create a BookingTime from JSON
  factory BookingTime.fromJson(Map<String, dynamic> json) {
    return BookingTime(time: json['time'], status: json['status']);
  }
}

class BookingDate {
  final String weekday;
  final String day;
  final String month;
  final String date; // New field
  final List<BookingTime> availableTimes;

  BookingDate({
    required this.weekday,
    required this.day,
    required this.month,
    required this.date, // New field
    required this.availableTimes,
  });

  // Factory method to create a BookingDate from JSON
  factory BookingDate.fromJson(Map<String, dynamic> json) {
    var timesList =
        (json['times'] as List)
            .map((timeJson) => BookingTime.fromJson(timeJson))
            .toList();

    return BookingDate(
      weekday: json['weekday'],
      day: json['day'],
      month: json['month'],
      date: json['date'], // New field
      availableTimes: timesList,
    );
  }
}

class BookingInfo {
  final List<BookingDate> dates;

  BookingInfo({required this.dates});

  // Factory method to create a BookingInfo from JSON
  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    var datesList =
        (json['slots'] as List)
            .map((dateJson) => BookingDate.fromJson(dateJson))
            .toList();

    return BookingInfo(dates: datesList);
  }
}
