class DailyStat {
  final DateTime date;
  final int minutes;

  DailyStat({required this.date, required this.minutes});

  factory DailyStat.fromJson(Map<String, dynamic> json) {
    return DailyStat(
      date: DateTime.parse(json['date']),
      minutes: json['minutes'],
    );
  }
}