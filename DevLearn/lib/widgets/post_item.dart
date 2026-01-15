import 'package:devlearn/data/models/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool isLiked;
  late int localLikeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
    localLikeCount = widget.post.likeCount;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        localLikeCount++;
      } else {
        localLikeCount--;
      }
    });
    // TODO: Call API to update like status
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final timeAgo = _formatTimeAgo(widget.post.createdAt);
    final numberFormat = NumberFormat.compact();

    return InkWell(
      onTap: () {
        // TODO: Navigate to Post Detail Screen
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        color: theme.scaffoldBackgroundColor, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, timeAgo),
            const SizedBox(height: 12),
            Text(
              widget.post.content,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
                height: 1.4,
              ),
              maxLines: 10, 
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _buildFooter(theme, numberFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String timeAgo) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Text(
            widget.post.authorName?.isNotEmpty == true ? widget.post.authorName![0].toUpperCase() : 'A',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.post.authorName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
            ],
          ),
        ),
        IconButton(
          onPressed: () { /* TODO: Show more options */ },
          icon: Icon(Icons.more_horiz_rounded, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, NumberFormat numberFormat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildActionButton(
          theme: theme,
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          text: numberFormat.format(localLikeCount),
          color: isLiked ? Colors.pink : Colors.grey.shade600,
          onTap: _toggleLike,
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          theme: theme,
          icon: Icons.chat_bubble_outline_rounded,
          text: numberFormat.format(widget.post.commentCount),
          color: Colors.grey.shade600,
          onTap: () { /* TODO: Open comments */ },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required ThemeData theme,
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
