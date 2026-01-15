import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/lesson_summary.dart';
import 'package:devlearn/data/repositories/lesson_repository.dart';
import 'package:flutter/material.dart';

// SỬA: Chuyển thành StatefulWidget
class LessonDetailScreen extends StatefulWidget {
  final LessonSummary lessonSummary;

  const LessonDetailScreen({super.key, required this.lessonSummary});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final LessonRepository _lessonRepository = LessonRepository();
  // Giữ Future của lesson chi tiết
  late Future<Lesson> _lessonDetailFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy chi tiết bài học dựa trên ID từ lessonSummary
    _lessonDetailFuture = _lessonRepository.getLessonById(widget.lessonSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Lấy title từ widget ban đầu cho tới khi có dữ liệu
        title: Text(widget.lessonSummary.title),
      ),
      // SỬA: Dùng FutureBuilder để xử lý việc tải dữ liệu
      body: FutureBuilder<Lesson>(
        future: _lessonDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải nội dung bài học: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy nội dung bài học.'));
          }

          // Đã có dữ liệu, gán vào biến `lesson`
          final lesson = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${lesson.views} lượt xem'),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_up_alt_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${lesson.likeCount}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today_outlined, size: 16),
                    const SizedBox(width: 4),
                    // Cân nhắc dùng thư viện intl để định dạng ngày tháng
                    Text(lesson.createdAt.toLocal().toString().split(' ')[0]),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  lesson.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
