import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Config/api_config.dart';
import '../models/DailyStat.dart';
import '../models/course.dart';
import '../models/dashboard_data.dart';
import '../models/quiz_question.dart';
import '../models/quiz_submit_request.dart';
import '../models/study_session_request.dart';
import '../models/topic.dart';
import '../models/subtopic.dart';
import '../models/notes.dart';

class ApiService {

  static Future<List<Course>> getCourses() async{
    // load the Course
    final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/courses"));

    if(response.statusCode == 200){
      List data = json.decode(response.body);
      return data.map((e) => Course.fromJson(e)).toList();
    }else {
      throw Exception("Failed to load courses");
    }
  }

  static Future<List<Topic>> getTopics(int courseId) async {
    //Load Topic
    final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/courses/$courseId/topics"));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Topic.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load topics");
    }
  }

  static Future<List<Subtopic>> getSubtopics(int topicId,String firebaseUid) async {
    //Load Subtopic
    // final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/topics/$topicId/subtopics"));
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/topics/$topicId/subtopics?firebaseUid=$firebaseUid'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Subtopic.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subtopics');
    }
  }

  static Future<Notes> getNotes(int subtopicId) async {
    // Load Notes
    final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/subtopics/$subtopicId/notes"));

    if (response.statusCode == 200) {
      return Notes.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load notes");
    }
  }

  static Future<void> sendStudySession(StudySessionRequest request) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/study-session'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send study session');
    }
  }


  static Future<List<QuizQuestion>> fetchQuiz(int subtopicId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/subtopic/$subtopicId/quiz'),
    );
    if (response.statusCode == 200) {
      final List questionsJson = jsonDecode(response.body); // directly as list
      return questionsJson.map((q) => QuizQuestion.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load quiz');
    }
  }

  //
  // static Future<List<QuizQuestion>> fetchQuiz(int subtopicId) async {
  //
  //   final response = await http.get(
  //     Uri.parse('${ApiConfig.baseUrl}/subtopic/$subtopicId/quiz'),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final List questionsJson = data['questions'];
  //     return questionsJson
  //         .map((q) => QuizQuestion.fromJson(q))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load quiz');
  //   }
  // }

  // static Future<bool> submitQuizAnswer(QuizSubmitRequest request) async {
  //   final response = await http.post(
  //     Uri.parse('${ApiConfig.baseUrl}/subtopic/quiz/submit'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(request.toJson()),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['correct'];
  //   } else {
  //     throw Exception('Failed to submit quiz');
  //   }
  // }

  static Future<bool> submitQuizAnswer(QuizSubmitRequest request) async {
    print('Submitting quiz with: ${request.toJson()}');
    final url = Uri.parse('${ApiConfig.baseUrl}/subtopic/quiz/submit');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      print('Quiz submit response status: ${response.statusCode}');
      print('Quiz submit response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['correct'];
      } else {
        throw Exception('Failed to submit quiz: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Network error in submitQuizAnswer: $e');
      throw Exception('Failed to submit quiz: $e');
    }
  }


  static Future<DashboardData> fetchDashboard(String firebaseUid) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/user/dashboard/$firebaseUid');
    print('Fetching dashboard from: $url'); // log the URL
    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        return DashboardData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchDashboard: $e');
      throw Exception('Failed to load dashboard: $e');
    }
  }





  static Future<List<DailyStat>> fetchDailyStats(String firebaseUid, {String range = 'week'}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/user/stats/daily/$firebaseUid?range=$range');
    print('Fetching daily stats from: $url');
    try {
      final response = await http.get(url);
      print('Daily stats response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        return list.map((e) => DailyStat.fromJson(e)).toList();
      } else {
        print('Daily stats error body: ${response.body}');
        throw Exception('Failed to load daily stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchDailyStats: $e');
      throw Exception('Failed to load daily stats: $e');
    }
  }


  static Future<Map<String, dynamic>> sendChatMessage({
    required String userId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/chat"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": userId,
        "message": message,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Chat API failed");
    }
  }


}