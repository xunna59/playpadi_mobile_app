import 'package:flutter/material.dart';
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.share),
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
                const CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
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
            const PlayersList(),
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
