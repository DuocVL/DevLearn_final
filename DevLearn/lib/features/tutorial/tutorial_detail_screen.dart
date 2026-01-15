import 'package:devlearn/data/models/lesson_summary.dart';
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
  late Future<List<LessonSummary>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách các bài học (chỉ tóm tắt)
    _lessonsFuture = _tutorialRepository.getLessonsForTutorial(widget.tutorialSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tutorialSummary.title),
      ),
      body: FutureBuilder<List<LessonSummary>>(
        future: _lessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có bài học nào trong khóa này.'));
          }

          final lessons = snapshot.data!;

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lessonSummary = lessons[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(lessonSummary.title),
                // Có thể thêm icon nếu lessonSummary có trường isPreviewable
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Điều hướng đến màn hình chi tiết, truyền đối tượng tóm tắt
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LessonDetailScreen(
                        lessonSummary: lessonSummary,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
