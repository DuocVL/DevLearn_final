import 'package:devlearn/data/models/submission.dart';
import 'package:devlearn/data/repositories/submission_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:intl/intl.dart';

class SubmissionDetailScreen extends StatefulWidget {
  final String submissionId;

  const SubmissionDetailScreen({super.key, required this.submissionId});

  @override
  State<SubmissionDetailScreen> createState() => _SubmissionDetailScreenState();
}

class _SubmissionDetailScreenState extends State<SubmissionDetailScreen> {
  final _repo = SubmissionRepository();
  late Future<Submission> _submissionFuture;

  @override
  void initState() {
    super.initState();
    _submissionFuture = _repo.getSubmissionById(widget.submissionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submission Detail')),
      body: FutureBuilder<Submission>(
        future: _submissionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No submission data found.'));
          }

          final submission = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(submission),
                const SizedBox(height: 24),
                Text('Code', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                _buildCodeBlock(submission),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(Submission submission) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow('Status', submission.status, color: _getStatusColor(submission.status)),
            _buildInfoRow('Language', submission.language),
            _buildInfoRow('Test Cases', '${submission.result.passedCount}/${submission.result.totalCount} passed'),
            _buildInfoRow('Runtime', '${submission.runtime} ms'),
            _buildInfoRow('Memory', '${(submission.memory / 1024).toStringAsFixed(2)} MB'),
            _buildInfoRow('Submitted At', DateFormat.yMd().add_jm().format(submission.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(Submission submission) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: githubTheme['root']?.backgroundColor,
      ),
      child: HighlightView(
        submission.code,
        language: submission.language,
        theme: githubTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Wrong Answer':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
