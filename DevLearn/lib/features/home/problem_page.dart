import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/data/repositories/problem_repository.dart';
import 'package:devlearn/widgets/problem_item.dart';
import 'package:flutter/material.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  final _repo = ProblemRepository();
  final _scrollController = ScrollController();

  final List<ProblemSummary> _problems = [];

  final List<Map<String, String>> _filters = [
    {"label": "Tất cả", "value": "All"},
    {"label": "Dễ", "value": "Easy"},
    {"label": "Trung bình", "value": "Medium"},
    {"label": "Khó", "value": "Hard"},
  ];
  
  String _selectedFilter = "All";
  bool _isInitialLoading = true;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProblems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProblems({bool isRefreshing = false}) async {
    if (_isMoreLoading) return;
    
    setState(() {
      _isMoreLoading = true;
      if (isRefreshing) {
        _isInitialLoading = true;
      }
    });

    try {
      final list = await _repo.getProblems(
        page: _page,
        limit: 20,
        difficulty: _selectedFilter,
      );

      if (mounted) {
        setState(() {
          if (list.length < 20) {
            _hasMore = false;
          }
          _problems.addAll(list);
          _page++;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isMoreLoading = false;
        });
      }
    }
  }

  void _onScroll() {
    if (!_isMoreLoading && _hasMore && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      _fetchProblems();
    }
  }

  Future<void> _onFilterChanged(String newFilter) async {
    setState(() {
      _selectedFilter = newFilter;
      _problems.clear();
      _page = 1;
      _hasMore = true;
      _error = null;
      _isInitialLoading = true;
    });
    await _fetchProblems(isRefreshing: true);
  }

  Future<void> _refresh() => _onFilterChanged(_selectedFilter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _problems.isEmpty) {
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
    
    if (_problems.isEmpty) {
       return const Center(child: Text('Không tìm thấy bài tập nào phù hợp.'));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: _problems.length + (_isMoreLoading ? 1 : 0),
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == _problems.length) {
            return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24.0), child: CircularProgressIndicator()));
          }
          return ProblemItem(problemSummary: _problems[index]);
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1)),
      ),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter['value'];
            return ChoiceChip(
              label: Text(filter['label']!),
              selected: isSelected,
              onSelected: (_) => _onFilterChanged(filter['value']!),
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              labelStyle: TextStyle(
                color: isSelected 
                  ? theme.colorScheme.primary 
                  : isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              selectedColor: theme.primaryColor.withOpacity(0.15),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? theme.primaryColor.withOpacity(0.5) : Colors.transparent,
                  width: 1,
                ),
              ),
              elevation: 0,
              pressElevation: 0,
            );
          },
        ),
      ),
    );
  }
}