import 'package:devlearn/data/models/submission.dart';
import 'package:devlearn/data/repositories/submission_repository.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SubmissionHistoryTab extends StatefulWidget {
  final String problemId;
  const SubmissionHistoryTab({super.key, required this.problemId});

  @override
  SubmissionHistoryTabState createState() => SubmissionHistoryTabState();
}

class SubmissionHistoryTabState extends State<SubmissionHistoryTab> {
  late Future<List<Submission>> _submissionsFuture;
  final SubmissionRepository _submissionRepository = SubmissionRepository();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    refresh(); // Tải dữ liệu lần đầu
  }

  void refresh() {
    setState(() {
      _submissionsFuture = 
          _submissionRepository.getSubmissions(problemId: widget.problemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Submission>>(
      future: _submissionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Lỗi tải lịch sử: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Chưa có lần nộp bài nào.', 
                    textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tải lại'),
                    onPressed: refresh,
                  )
                ],
              ),
            ),
          );
        }

        final submissions = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final submission = submissions[index];
              return _buildSubmissionTile(context, submission);
            },
          ),
        );
      },
    );
  }

  Widget _buildSubmissionTile(BuildContext context, Submission submission) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(submission.status);

    return ListTile(
      leading: Icon(_getStatusIcon(submission.status), color: statusColor, size: 30),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            submission.status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
          Text(
            submission.language.toUpperCase(),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(
        'Nộp ${timeago.format(submission.createdAt, locale: 'vi')}',
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.submissionDetail,
          arguments: submission.id,
        );
      },
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Accepted':
        return Icons.check_circle;
      case 'Wrong Answer':
      case 'Runtime Error':
        return Icons.cancel;
      case 'Time Limit Exceeded':
        return Icons.timer_off;
      case 'Pending':
      case 'Running':
        return Icons.hourglass_top;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green.shade600;
      case 'Wrong Answer':
      case 'Runtime Error':
        return Colors.red.shade600;
      case 'Time Limit Exceeded':
        return Colors.orange.shade800;
      case 'Pending':
      case 'Running':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
