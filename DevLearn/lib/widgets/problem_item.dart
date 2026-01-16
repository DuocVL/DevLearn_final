import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

class ProblemItem extends StatelessWidget {
  final ProblemSummary problemSummary;

  const ProblemItem({super.key, required this.problemSummary});

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final difficultyColor = _getDifficultyColor(problemSummary.difficulty);

    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.problemDetail, // Sử dụng named route
          arguments: problemSummary.id,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    problemSummary.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                _buildDifficultyChip(theme, problemSummary.difficulty, difficultyColor),
              ],
            ),
            const SizedBox(height: 12),
            if (problemSummary.tags.isNotEmpty)
              Wrap(
                spacing: 6.0,
                runSpacing: 4.0,
                children: problemSummary.tags
                    .map((tag) => _buildTagChip(theme, tag, isDarkMode))
                    .toList(),
              ),
            const SizedBox(height: 12),
            _buildInfoChip(
              theme,
              Icons.check_circle_outline,
              // Định dạng lại tỉ lệ chấp nhận
              '${(problemSummary.acceptance * 100).toStringAsFixed(1)}% giải được',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(ThemeData theme, String difficulty, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        difficulty, // Giữ nguyên chữ hoa/thường từ API (Easy, Medium, Hard)
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTagChip(ThemeData theme, String tag, bool isDarkMode) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          tag,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
            fontSize: 11,
          ),
        ));
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, letterSpacing: 0.2),
        ),
      ],
    );
  }
}
