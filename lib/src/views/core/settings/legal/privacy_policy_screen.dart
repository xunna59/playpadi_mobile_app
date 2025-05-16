import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  final String termsText = '''
PRIVACY POLICY

INFORMATION NOTICE PURSUANT SECTION 13 AND 14 OF REGULATION (EU) 2016/679

Dear User, in compliance with Sections 13 and 14 of Regulation (EU) 2016/679 (so called GDPR), Playtomic S.L. informs you about the processing of your personal data.

Who will process your personal data?

Your personal data will be processed by Playtomic S.L. (hereinafter, also “Playtomic”), with registered office at 2801 Madrid (Madrid), Calle Lagasca 88 - 8, Spain, which will act in quality of “Data Controller”; you will be able to contact the Data Controller at the following email address: privacy@playtomic.io.

Personal data can be processed in the name and on behalf of Playtomic also by others subjects who will be duly appointed “Data Processors“, belonging to the following categories: hosting providers, software providers, social networks. The list of the Data processors is at your disposal, under request.

The Data Controller has also appointed a Data Protection Officer (called DPO), contactable to the email address: dpo@playtomic.io.

Who will process your personal data?

Your personal data will be processed by Playtomic S.L. (hereinafter, also “Playtomic”), with registered office at 2801 Madrid (Madrid), Calle Lagasca 88 - 8, Spain, which will act in quality of “Data Controller”; you will be able to contact the Data Controller at the following email address: privacy@playtomic.io.

Personal data can be processed in the name and on behalf of Playtomic also by others subjects who will be duly appointed “Data Processors“, belonging to the following categories: hosting providers, software providers, social networks. The list of the Data processors is at your disposal, under request.

The Data Controller has also appointed a Data Protection Officer (called DPO), contactable to the email address: dpo@playtomic.io.

''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            termsText,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ),
    );
  }
}
