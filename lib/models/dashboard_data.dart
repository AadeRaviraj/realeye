class DashboardData {
  final int todayMinutes;
  final int weeklyMinutes;
  final int monthlyMinutes;
  final double completionPercentage;
  final double accuracyPercentage;
  final int streak;

  DashboardData({
    required this.todayMinutes,
    required this.weeklyMinutes,
    required this.monthlyMinutes,
    required this.completionPercentage,
    required this.accuracyPercentage,
    required this.streak,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      todayMinutes: json['todayMinutes'],
      weeklyMinutes: json['weeklyMinutes'],
      monthlyMinutes: json['monthlyMinutes'],
      completionPercentage: json['completionPercentage'].toDouble(),
      accuracyPercentage: json['accuracyPercentage'].toDouble(),
      streak: json['streak'],
    );
  }
}