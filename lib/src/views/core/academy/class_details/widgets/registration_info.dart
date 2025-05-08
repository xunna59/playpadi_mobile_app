import 'package:flutter/material.dart';
import 'package:playpadi/src/models/class_model.dart';

class RegistrationInfo extends StatelessWidget {
  final ClassModel classData;
  const RegistrationInfo({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: const Text("END OF REGISTRATION", style: TextStyle()),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Wednesday, February 07 | 6:00pm",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Category"),
                    SizedBox(height: 5),
                    Text("Open"),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text("Restrictive level"),
                    SizedBox(height: 5),
                    Text("0.0 - 1.5"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
