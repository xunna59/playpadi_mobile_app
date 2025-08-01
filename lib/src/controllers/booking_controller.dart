import '../../playpadi_library.dart';
import '../models/booking_model.dart';
import '../models/court_model.dart';

class BookingController {
  final APIClient client = APIClient();

  Future<BookingInfo?> fetchBookingInfoById(Map<String, dynamic> data) async {
    //   Map<String, String> data = {'id': id.toString()};

    try {
      final response = await client.fetchSlots(data);
      //  print('Raw API response in controller: $response');

      if (response is Map<String, dynamic>) {
        return BookingInfo.fromJson(response);
      }

      return null;
    } catch (e) {
      print('Error fetching booking info: $e');
      return null;
    }
  }

  // Future<BookingInfo?> fetchBookingInfoById(id) async {
  //   Map<String, String> data = {'id': id.toString()};

  //   try {
  //     final response = await client.fetchSlots(data);

  //     if (response is Map<String, dynamic>) {
  //       if (response['slots'] is List<dynamic>) {
  //         final rawBookingInfo = response['slots'];
  //         List<BookingDate> bookingDates = [];

  //         for (var date in rawBookingInfo) {
  //           List<BookingTime> availableTimes = [];

  //           for (var time in date['times']) {
  //             availableTimes.add(
  //               BookingTime(
  //                 time: time['time'],
  //                 court_status: time['court_status'],
  //                 totalAvailableCourts: time['total_available_courts'] ?? 0,
  //                 courts:
  //                     (time['courts'] as List).map((courtJson) {
  //                       final courtData = courtJson['court'];
  //                       return CourtModel.fromJson(
  //                         courtData,
  //                       );
  //                     }).toList(),
  //               ),
  //             );
  //           }

  //           bookingDates.add(
  //             BookingDate(
  //               weekday: date['weekday'],
  //               day: date['day'],
  //               month: date['month'],
  //               date: date['date'],
  //               availableTimes: availableTimes,
  //             ),
  //           );
  //         }

  //         return BookingInfo(dates: bookingDates);
  //       }
  //     }

  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
