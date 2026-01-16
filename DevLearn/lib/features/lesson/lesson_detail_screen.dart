import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/lesson_summary.dart';
import 'package:devlearn/data/repositories/lesson_repository.dart';
import 'package:flutter/material.dart';


class LessonDetailScreen extends StatefulWidget {
  final LessonSummary lessonSummary;

  const LessonDetailScreen({super.key, required this.lessonSummary});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final LessonRepository _lessonRepository = LessonRepository();

  late Future<Lesson> _lessonDetailFuture;

  @override
  void initState() {
    super.initState();

    _lessonDetailFuture = _lessonRepository.getLessonById(widget.lessonSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text(widget.lessonSummary.title),
      ),
   
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
