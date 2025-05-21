import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  // Replace these with your actual contact details:
  final String _phoneNumber = '+1234567890';
  final String _emailAddress = 'help@example.com';
  final String _whatsAppNumber = '+1234567890';
  final String _instagramHandle = 'your_instagram';
  final String _twitterHandle = 'twitter';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme scheme,
  }) {
    return Card(
      elevation: 0,
      color: scheme.tertiary,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 24),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Help'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          // Phone
          _buildTile(
            icon: Icons.phone,
            label: 'Phone',
            onTap: () => _launchUrl('tel:$_phoneNumber'),
            scheme: colorScheme,
          ),

          // Email
          _buildTile(
            icon: Icons.email,
            label: 'Email',
            onTap: () => _launchUrl('mailto:$_emailAddress'),
            scheme: colorScheme,
          ),

          // WhatsApp
          _buildTile(
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp',
            onTap: () => _launchUrl('https://wa.me/$_whatsAppNumber'),
            scheme: colorScheme,
          ),

          // Instagram
          _buildTile(
            icon: FontAwesomeIcons.instagram,
            label: 'Instagram',
            onTap: () => _launchUrl('https://instagram.com/$_instagramHandle'),
            scheme: colorScheme,
          ),

          // Twitter
          _buildTile(
            icon: FontAwesomeIcons.twitter,
            label: 'Twitter',
            onTap: () => _launchUrl('https://twitter.com/$_twitterHandle'),
            scheme: colorScheme,
          ),
        ],
      ),
    );
  }
}
