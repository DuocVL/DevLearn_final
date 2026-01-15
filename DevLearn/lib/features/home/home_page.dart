import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/features/tutorial/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repo = TutorialRepository();
  late Future<List<TutorialSummary>> _tutorialsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
  }

  void _fetchTutorials() {
    _tutorialsFuture = _repo.getTutorials();
  }

  Future<void> _refresh() async {
    setState(() {
      _fetchTutorials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () { /* TODO: Notification screen */ },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<TutorialSummary>>(
          future: _tutorialsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _buildErrorState();
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            final tutorials = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: tutorials.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return TutorialCard(tutorial: tutorials[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState() {
     return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('Không thể tải hướng dẫn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Đã có lỗi xảy ra. Vui lòng kiểm tra kết nối và thử lại.',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Chưa có hướng dẫn nào', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Nội dung mới sẽ sớm được cập nhật.', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
