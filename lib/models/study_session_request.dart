class StudySessionRequest {
  final String firebaseUid;
  final int subtopicId;
  final DateTime startTime;
  final DateTime endTime;

  StudySessionRequest({
    required this.firebaseUid,
    required this.subtopicId,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'subtopicId': subtopicId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}