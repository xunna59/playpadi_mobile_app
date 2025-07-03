import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  final String termsText = '''
Effective Date: 01/07/2025

Welcome to PlayPadi! These Terms of Use ("Terms") govern your use of the PlayPadi mobile application, website, and related services (“Services”). By accessing or using PlayPadi, you agree to be bound by these Terms.


1. Acceptance of Terms

By creating an account, downloading, or using the PlayPadi app, you confirm that you are at least 18 years old (or have parental consent if under 18) and agree to abide by these Terms and our Privacy Policy.


2. Our Services

PlayPadi allows users to:

- Discover and book sports courts (e.g., padel tennis)
- Pay for reservations securely within the app
- Join or host open matches with other players
- Explore sports centers and connect with other users

We may update, modify, or discontinue some or all of the Services at any time.


3. User Accounts

To use certain features, you must create an account. You agree to:

- Provide accurate and complete information
- Keep your login credentials secure
- Be responsible for any activity under your account

PlayPadi is not responsible for any loss resulting from unauthorized access to your account.


4. Bookings and Payments

All court reservations made through PlayPadi are subject to availability and the terms set by individual sports centers. Users are responsible for:

- Reviewing the booking and cancellation policy before confirming
- Making timely payments
- Arriving on time for reservations


5. Cancellations and Refunds

Cancellation policies are determined by individual sports centers. PlayPadi is not liable for refunds unless specifically stated. Please review the terms shown during the booking process.


6. User Conduct

You agree not to:

- Misuse the app or disrupt its operation
- Upload false, harmful, or abusive content
- Attempt to exploit, reverse-engineer, or hack any part of the Service
- Use PlayPadi for any illegal or unauthorized purpose

Violation of these terms may lead to suspension or termination of your account.


7. Content Ownership

PlayPadi retains all rights to the app, branding, design, and related content. You may not copy, reproduce, or redistribute any part of our platform without written permission.


8. Third-Party Services

We may display or integrate third-party services (like payment processors or social logins). We are not responsible for third-party content, services, or privacy practices.


9. Limitation of Liability

PlayPadi is provided "as is." We are not liable for:

- Inaccuracies in sports center information
- Injuries or disputes arising during games or court usage
- Interruptions in service

Your use of the app is at your own risk.


10. Termination

We reserve the right to suspend or terminate your access if you violate these Terms or misuse the Service.


11. Changes to Terms

We may update these Terms periodically. Continued use of PlayPadi means you accept any updated Terms.


12. Contact Us

For questions or support, please contact us at: support@playpadi.com
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of use',
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
