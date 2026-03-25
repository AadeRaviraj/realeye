class QuizSubmitRequest {
  final String firebaseUid;
  final int subtopicId;
  final int questionId;
  final int selectedOptionId;

  QuizSubmitRequest({
    required this. firebaseUid,
    required this.subtopicId,
    required this.questionId,
    required this.selectedOptionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'subtopicId': subtopicId,
      'questionId': questionId,
      'selectedOptionId': selectedOptionId,
    };
  }
}