import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/post_repository.dart';
import 'package:devlearn/data/repositories/problem_repository.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/features/home/widgets/welcome_card.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:devlearn/widgets/post_item.dart';
import 'package:devlearn/widgets/problem_item.dart';
import 'package:devlearn/features/tutorial/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DashboardData> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() {
    _dashboardDataFuture = _getDashboardData();
  }

  Future<DashboardData> _getDashboardData() async {
    // Sử dụng Future.wait để tải dữ liệu song song
    final results = await Future.wait([
      TutorialRepository().getTutorials(limit: 4),
      ProblemRepository().getProblems(page: 1, limit: 3),
      PostRepository().getPosts(page: 1, limit: 3),
    ]);

    return DashboardData(
      tutorials: results[0] as List<TutorialSummary>,
      problems: results[1] as List<ProblemSummary>,
      posts: results[2] as List<Post>,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _fetchDashboardData();
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
      body: FutureBuilder<DashboardData>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildErrorState(); // Hiển thị lỗi
          }
          if (!snapshot.hasData) {
            return _buildEmptyState(); // Hiển thị khi không có dữ liệu
          }

          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(child: WelcomeCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                
                _buildSectionHeader(context, 'Hướng dẫn nổi bật', () => Navigator.pushNamed(context, RouteName.tutorial)),
                _buildTutorialsSection(data.tutorials),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                _buildSectionHeader(context, 'Thử thách đáng chú ý', () => Navigator.pushNamed(context, RouteName.problem)),
                _buildProblemsSection(data.problems),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                
                _buildSectionHeader(context, 'Từ cộng đồng', () => Navigator.pushNamed(context, RouteName.post)),
                _buildPostsSection(context, data.posts),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onViewAll) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: onViewAll,
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialsSection(List<TutorialSummary> tutorials) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tutorials.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.75,
              margin: const EdgeInsets.only(right: 12),
              child: TutorialCard(tutorial: tutorials[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProblemsSection(List<ProblemSummary> problems) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ProblemItem(problemSummary: problems[index]),
          ),
          childCount: problems.length,
        ),
      ),
    );
  }

  Widget _buildPostsSection(BuildContext context, List<Post> posts) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SliverList.separated(
      itemBuilder: (context, index) => PostItem(post: posts[index]),
      separatorBuilder: (context, index) => Divider(
        height: 1, 
        thickness: 1, 
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        indent: 16,
        endIndent: 16,
      ),
      itemCount: posts.length,
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
              const Text('Không thể tải dữ liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
    // Tương tự Error State nhưng với thông báo khác
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Không có dữ liệu để hiển thị', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Tải lại trang'),
          ),
        ],
      ),
    );
  }
}

// Lớp helper để chứa dữ liệu từ các API
class DashboardData {
  final List<TutorialSummary> tutorials;
  final List<ProblemSummary> problems;
  final List<Post> posts;

  DashboardData({required this.tutorials, required this.problems, required this.posts});
}