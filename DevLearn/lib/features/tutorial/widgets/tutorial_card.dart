import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  final TutorialSummary tutorial;

  const TutorialCard({super.key, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.tutorialDetail,
          arguments: tutorial,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tutorial.title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                tutorial.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Text(
                        (tutorial.author?.username.isNotEmpty ?? false)
                            ? tutorial.author!.username[0].toUpperCase()
                            : 'A',
                        style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(tutorial.author?.username ?? 'Anonymous', style: theme.textTheme.labelLarge),
                  ],
                ),
                _buildInfoChip(theme, Icons.library_books_outlined, '${tutorial.lessonCount} bài học'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
      ],
    );
  }
}
