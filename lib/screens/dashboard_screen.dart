import 'package:flutter/material.dart';
import 'package:navaveda/models/dashboard_data.dart';
import 'package:navaveda/services/api_service.dart';

class DashboardScreen extends StatelessWidget {
  final String firebaseUid;  // changed from int userId

  const DashboardScreen({Key? key, required this.firebaseUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<DashboardData>(
        future: ApiService.fetchDashboard(firebaseUid ),  // updated
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildStatCard(
                  'Today',
                  '${data.todayMinutes} min',
                  Icons.today,
                  const Color(0xFF5F9DF2),
                ),
                _buildStatCard(
                  'Weekly',
                  '${data.weeklyMinutes} min',
                  Icons.date_range,
                  Colors.green,
                ),
                _buildStatCard(
                  'Monthly',  // new card for monthly minutes
                  '${data.monthlyMinutes} min',
                  Icons.calendar_month,
                  Colors.purple,
                ),
                _buildStatCard(
                  'Completion',
                  '${data.completionPercentage.toStringAsFixed(1)}%',
                  Icons.check_circle,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Accuracy',
                  '${data.accuracyPercentage.toStringAsFixed(1)}%',
                  Icons.verified,
                  Colors.pink,
                ),
                _buildStatCard(
                  'Streak',
                  '${data.streak} days',
                  Icons.whatshot,
                  Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}