
class Testcase {
  final String input;
  final String output;
  final bool isHidden;

  Testcase({
    required this.input,
    required this.output,
    required this.isHidden,
  });

  factory Testcase.fromJson(Map<String, dynamic> json) {
    return Testcase(
      input: json['input'] as String? ?? '',
      output: json['output'] as String? ?? '',
      isHidden: json['isHidden'] as bool? ?? false,
    );
  }
}

class StarterCode {
  final String language;
  final String code;

  StarterCode({required this.language, required this.code});

  factory StarterCode.fromJson(Map<String, dynamic> json) {
    return StarterCode(
      language: json['language'] as String? ?? 'plaintext',
      code: json['code'] as String? ?? '',
    );
  }
}


class Problem {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String> tags;
  final List<Testcase> testcases; 
  final List<StarterCode> starterCode;
  final int totalSubmissions;   
  final int acceptedSubmissions;  

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.tags,
    required this.testcases,
    required this.starterCode,
    required this.totalSubmissions,
    required this.acceptedSubmissions,
  });


  factory Problem.fromJson(Map<String, dynamic> json) {

    final safeTags = (json['tags'] as List<dynamic>? ?? [])
        .map((tag) => tag as String?)
        .where((tag) => tag != null)
        .cast<String>()
        .toList();

    final safeTestcases = (json['testcases'] as List<dynamic>? ?? [])
        .map((t) => Testcase.fromJson(t))
        .toList();

    final safeStarterCode = (json['starterCode'] as List<dynamic>? ?? [])
        .map((sc) => StarterCode.fromJson(sc))
        .toList();

    return Problem(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Unknown',
      tags: safeTags, 
      testcases: safeTestcases,
      starterCode: safeStarterCode,
      totalSubmissions: json['totalSubmissions'] as int? ?? 0,
      acceptedSubmissions: json['acceptedSubmissions'] as int? ?? 0,
    );
  }
}
