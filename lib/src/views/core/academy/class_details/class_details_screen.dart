import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants.dart';
import '../../../../models/class_model.dart';
import '../../../../widgets/primary_button.dart';
import 'widgets/date_card.dart';
import 'widgets/player_list.dart';
import 'widgets/registration_info.dart';
import 'widgets/coach_info.dart';

class ClassDetailsScreen extends StatelessWidget {
  final ClassModel classData;

  const ClassDetailsScreen({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
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
                      "Hurry up! Only 3 places available",
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
              "Payment methods",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            PrimaryButton(
              text: 'Book Place - ${classData.sessionPrice}',
              onPressed: () {},
            ),
            const SizedBox(height: 16), // Optional spacing at the bottom
          ],
        ),
      ),
    );
  }
}
