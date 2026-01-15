import 'package:devlearn/data/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  // SỬA: Nhận cả object Lesson thay vì chỉ LessonSummary
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title), // SỬA: Lấy title từ lesson
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title, // SỬA: Lấy title từ lesson
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // --- VÍ DỤ: HIỂN THỊ THÊM THÔNG TIN TỪ LESSON ---
            Text(
              'Thời lượng: ${lesson.duration} phút',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Lượt xem: ${lesson.views}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Nội dung bài học:',
              style: Theme.of(src/features/lesson/lesson_detail_screen.dart).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(lesson.content), // SỬA: Lấy content từ lesson
              ),
            ),
            // Bạn có thể thêm trình phát video ở đây bằng `lesson.videoUrl`
          ],
        ),
      ),
    );
  }
}
