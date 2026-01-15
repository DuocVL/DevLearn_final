import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/features/lesson/lesson_detail_screen.dart';
import 'package:flutter/material.dart';

class TutorialDetailScreen extends StatefulWidget {
  final TutorialSummary tutorialSummary;

  const TutorialDetailScreen({super.key, required this.tutorialSummary});

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  final TutorialRepository _tutorialRepository = TutorialRepository();
  // SỬA: Thay thế Future<Tutorial> bằng Future<List<Lesson>>
  late Future<List<Lesson>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    // SỬA: Gọi hàm getLessonsForTutorial
    _lessonsFuture = _tutorialRepository.getLessonsForTutorial(widget.tutorialSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tutorialSummary.title),
      ),
      body: FutureBuilder<List<Lesson>>(
        future: _lessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có bài học nào.'));
          }

          final lessons = snapshot.data!;

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                // SỬA: Sử dụng các thuộc tính từ `lesson`
                title: Text(lesson.title),
                subtitle: Text('${lesson.duration} phút'), // Ví dụ sử dụng duration
                trailing: lesson.isPreviewable ? const Icon(Icons.visibility) : const Icon(Icons.lock_outline),
                onTap: () {
                  if (lesson.isPreviewable) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LessonDetailScreen(
                          lesson: lesson, // SỬA: Truyền cả object `lesson`
                        ),
                      ),
                    );
                  } else {
                    // Hiển thị thông báo hoặc xử lý logic cho bài học bị khóa
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bạn cần đăng ký để xem bài học này.')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
