class QuizQuestion {
  final int questionId;
  final String questionText;
  final List<QuizOption> options;

  QuizQuestion({required this.questionId, required this.questionText, required this.options});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List;
    List<QuizOption> optionsList = list.map((i) => QuizOption.fromJson(i)).toList();
    return QuizQuestion(
      questionId: json['questionId'],
      questionText: json['questionText'],
      options: optionsList,
    );
  }
}

class QuizOption {
  final int optionId;
  final String optionText;

  QuizOption({required this.optionId, required this.optionText});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      optionId: json['optionId'],
      optionText: json['optionText'],
    );
  }
}