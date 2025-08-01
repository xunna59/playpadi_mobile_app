import 'court_model.dart';

class BookingTime {
  final String time;
  final String court_status;
  final int totalAvailableCourts;
  final List<CourtModel> courts;

  BookingTime({
    required this.time,
    required this.court_status,
    required this.totalAvailableCourts,
    required this.courts,
  });

  factory BookingTime.fromJson(Map<String, dynamic> json) {
    return BookingTime(
      time: json['time'] ?? '',
      court_status: json['court_status'] ?? '',
      totalAvailableCourts: json['total_available_courts'] ?? 0,
      // courts:
      //     (json['courts'] as List)
      //         .map((courtWrapper) => CourtModel.fromJson(courtWrapper['court']))
      //         .toList(),
      courts:
          (json['courts'] as List).map((courtWrapper) {
            final courtJson = courtWrapper['court'];
            courtJson['court_status'] = courtWrapper['court_status'];
            return CourtModel.fromJson(courtJson);
          }).toList(),
    );
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

  factory BookingDate.fromJson(Map<String, dynamic> json) {
    var timesList =
        (json['times'] as List?)
            ?.map((timeJson) => BookingTime.fromJson(timeJson))
            .toList() ??
        [];

    return BookingDate(
      weekday: json['weekday'] ?? '',
      day: json['day'] ?? '',
      month: json['month'] ?? '',
      date: json['date'] ?? '',
      availableTimes: timesList,
    );
  }
}

class BookingInfo {
  final List<BookingDate> dates;

  BookingInfo({required this.dates});

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    // print('Raw booking data response: $json');
    var datesList =
        (json['slots'] as List?)
            ?.map((dateJson) => BookingDate.fromJson(dateJson))
            .toList() ??
        [];
    return BookingInfo(dates: datesList);
  }
}
