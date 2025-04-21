class BookingDate {
  final String weekday;
  final String day;
  final String month;
  final List<String> availableTimes;

  BookingDate({
    required this.weekday,
    required this.day,
    required this.month,
    required this.availableTimes,
  });
}

class BookingInfo {
  final List<BookingDate> dates;

  BookingInfo({required this.dates});
}
