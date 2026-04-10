import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String _baseUrl = 'http://10.0.2.2:5000'; // Use 10.0.2.2 for emulator

  // Send user question to AI backend
  Future<String> askQuestion(String question, String language, String topic) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ask'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': question,
        'language': language,
        'topic': topic,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // If the backend returns a list of QAs, just get the first answer
      if (data['answer'] is List && data['answer'].isNotEmpty) {
        return data['answer'][0]['answer'];
      } else {
        return data['answer'].toString();
      }
    } else {
      throw Exception('Failed to get AI answer');
    }
  }



  Future<List<String>> generateQuestions(String language, String topic) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/generate_questions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'language': language,
        'topic': topic,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['questions']);
    } else {
      throw Exception('Failed to generate questions');
    }


  }


}