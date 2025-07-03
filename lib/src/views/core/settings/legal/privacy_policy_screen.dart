import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  final String termsText = '''
Effective Date: 01/07/2025

At PlayPadi, your privacy is very important to us. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our mobile app and related services.



1. Information We Collect

a. Personal Information

When you register or use the app, we may collect:

- Full Name
- Email Address
- Phone Number
- Location (for finding nearby sports centers)
- Payment Information (processed securely through third-party services)

b. Usage Information

- Device details (model, OS, unique identifiers)
- IP Address
- App usage data (features used, bookings made, etc.)
- Log data and diagnostics

c. Optional Information

- Profile picture
- Preferred sports and skill level
- Communication preferences



2. How We Use Your Information

We use your information to:

- Enable bookings and payments
- Suggest nearby courts and matches
- Match users with similar skill levels
- Improve app performance and user experience
- Communicate updates, offers, and notifications
- Respond to inquiries and provide support
- Ensure safety, prevent fraud, and comply with legal requirements



3. Sharing Your Information

We do not sell your personal information. We may share data with:

- Service Providers (e.g., payment processors, hosting platforms)
- Sports Centers (to process and manage your bookings)
- Law Enforcement (only if required by law or in case of misuse)
- Analytics & Crash Reporting Tools (for improving the app)



4. Data Security

We implement industry-standard security practices to protect your data, including:

- Encryption of sensitive data
- Secure payment gateways
- Regular security reviews

While we take reasonable precautions, no method of data transmission or storage is 100% secure.



5. Your Rights

You may:

- Access, update, or delete your personal information
- Withdraw consent or deactivate your account
- Opt out of marketing communications
- Request a copy of your stored data

To exercise your rights, contact us at **playpadiapp@gmail.com**.

---

6. Data Retention

We retain user information for as long as necessary:

- To provide services and fulfill bookings
- To comply with legal obligations
- For legitimate business needs such as support and analytics

You can request data deletion at any time.



7. Children’s Privacy

PlayPadi is not intended for users under the age of 13. We do not knowingly collect personal data from children without verified parental consent.



8. Third-Party Links & Services

Our app may contain links to third-party websites or use third-party services. We are not responsible for their privacy practices. Please review their policies before providing your information.



9. Updates to This Policy

We may update this Privacy Policy from time to time. Changes will be posted in-app or on our website with the effective date. Continued use of the app indicates your agreement to the updated terms.



10. Contact Us

If you have questions or concerns about this Privacy Policy, please contact us at:

Email: playpadiapp@gmail.com

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
