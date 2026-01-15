import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/services/tutorial_service.dart';
import 'package:devlearn/features/tutorial/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late final TutorialService _tutorialService;
  late Future<List<TutorialSummary>> _tutorialsFuture;

  @override
  void initState() {
    super.initState();
    _tutorialService = TutorialService();
    _tutorialsFuture = _tutorialService.getTutorials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: FutureBuilder<List<TutorialSummary>>(
        future: _tutorialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có bài hướng dẫn nào.'));
          }

          final tutorials = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: tutorials.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return TutorialCard(tutorial: tutorials[index]);
            },
          );
        },
      ),
    );
  }
}
