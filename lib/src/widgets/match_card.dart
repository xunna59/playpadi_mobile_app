import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width:
              (MediaQuery.of(context).size.width - 48) /
              2, // Divide space equally
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl), // Display image from URL
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon placed at the top-left
              Padding(
                padding: const EdgeInsets.all(12),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(icon, color: colorScheme.primary),
                ),
              ),
              // Title and Subtitle
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(color: colorScheme.onBackground),
                    ),
                  ],
                ),
              ),
              // Action Button (bottom of card)
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(icon),
                  label: const Text('Action'),
                  onPressed: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
