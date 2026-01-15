import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/features/tutorials/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final TutorialRepository _repository = TutorialRepository();
  final ScrollController _scrollController = ScrollController();

  final List<TutorialSummary> _tutorials = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_hasMore || _isLoading) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      _fetchTutorials();
    }
  }

  // SỬA: Toàn bộ hàm fetch được làm lại để đơn giản và đúng đắn hơn
  Future<void> _fetchTutorials({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _hasError = false;
      }
    });

    try {
      if (isRefresh) {
        _currentPage = 1;
        _tutorials.clear();
        _hasMore = true;
      }

      // 1. Lấy danh sách các tutorial đã được parse từ repository
      final List<TutorialSummary> newTutorials = await _repository.getTutorials(page: _currentPage);

      setState(() {
        // 2. Nếu danh sách trả về rỗng, tức là đã hết dữ liệu
        if (newTutorials.isEmpty) {
          _hasMore = false;
        } else {
        // 3. Thêm các tutorial mới vào danh sách hiện tại và tăng số trang
          _tutorials.addAll(newTutorials);
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print('Error fetching tutorials: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Học tập'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchTutorials(isRefresh: true),
        child: _buildTutorialsList(),
      ),
    );
  }

  Widget _buildTutorialsList() {
    if (_isLoading && _tutorials.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError && _tutorials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Không thể tải được dữ liệu.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchTutorials(isRefresh: true),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    if (_tutorials.isEmpty) {
      return const Center(child: Text('Không có bài hướng dẫn nào.'));
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: _tutorials.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _tutorials.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return TutorialCard(tutorial: _tutorials[index]);
      },
    );
  }
}
