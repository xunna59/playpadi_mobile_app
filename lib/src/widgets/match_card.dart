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
        elevation: 1,
        color: colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Top half with image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            // Bottom half with icon, title, subtitle, and button
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                        ),
                        child: Icon(icon, color: Colors.white),
                      ),

                      const SizedBox(height: 8),
                      // Title and Subtitle
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      const SizedBox(height: 12),

                      // Action Button
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
