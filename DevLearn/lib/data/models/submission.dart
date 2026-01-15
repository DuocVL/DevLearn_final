class SubmissionResult {
  final int passedCount;
  final int totalCount;

  SubmissionResult({required this.passedCount, required this.totalCount});

  factory SubmissionResult.fromJson(Map<String, dynamic> json) {
    return SubmissionResult(
      passedCount: json['passedCount'] as int,
      totalCount: json['totalCount'] as int,
    );
  }
}

class Submission {
  final String id;
  final String problemId;
  final String userId;
  final String language;
  final String code;
  final String status;
  final SubmissionResult result;
  final int runtime;
  final int memory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Submission({
    required this.id,
    required this.problemId,
    required this.userId,
    required this.language,
    required this.code,
    required this.status,
    required this.result,
    required this.runtime,
    required this.memory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['_id'] as String,
      problemId: json['problemId'] as String,
      userId: json['userId'] as String,
      language: json['language'] as String,
      code: json['code'] as String,
      status: json['status'] as String,
      result: SubmissionResult.fromJson(json['result'] as Map<String, dynamic>),
      runtime: json['runtime'] as int,
      memory: json['memory'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
