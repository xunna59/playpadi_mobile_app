import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../controllers/academy_controller.dart';
import '../../../../core/constants.dart';
import '../../../../models/class_model.dart';
import '../../../../widgets/currency_primary_button.dart';
import 'widgets/date_card.dart';
import 'widgets/player_list.dart';
import 'widgets/registration_info.dart';
import 'widgets/coach_info.dart';

class ClassDetailsScreen extends StatelessWidget {
  final ClassModel classData;

  const ClassDetailsScreen({super.key, required this.classData});

  void addToFavorites(int? classData) async {
    //   if (classData == null) return;

    //   print(eventCenter);

    Map<String, String> payload = {'academy_id': classData.toString()};
    print(payload);
    try {
      final addToFavouriteStatus = await AcademyController().joinAcademy(
        payload,
      );
    } catch (e) {
      // handle error
      print('Error Joining Class: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    ).format(classData.sessionPrice);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    text:
                        'PlayPadi Upcoming ${classData.title} visit https://playpadi.com to Book Place',
                  ),
                );
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    '${imageBaseUrl}${classData.coverImage}',
                  ),
                  maxRadius: 35,
                  minRadius: 35,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hurry Up! Limited Slots Available",
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    Text(
                      classData.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  classData.sessionActivity,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 15),
                Text(
                  classData.academyType,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DateCard(classData: classData),
            const SizedBox(height: 16),
            RegistrationInfo(classData: classData),
            const SizedBox(height: 16),
            CoachInfo(classData: classData),
            const SizedBox(height: 16),
            PlayersList(classData: classData),
            const SizedBox(height: 32),
            const Text(
              "Proceed to Pay",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            CurrencyPrimaryButton(
              text: 'Book Place - ${formatted}',
              onPressed: () {
                addToFavorites(classData!.id);
              },
            ),
            const SizedBox(height: 16), // Optional spacing at the bottom
          ],
        ),
      ),
    );
  }
}
