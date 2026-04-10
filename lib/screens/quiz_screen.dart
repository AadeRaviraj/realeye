

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navaveda/services/api_service.dart';

import '../models/quiz_question.dart';
import '../models/quiz_submit_request.dart';

class QuizScreen extends StatefulWidget {
  final int subtopicId;
  final int topicId;

  const QuizScreen({
    Key? key,
    required this.subtopicId,
    required this.topicId,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  late Future<List<QuizQuestion>> _quizFuture;

  int _currentQuestionIndex = 0;
  int? _selectedOptionId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _quizFuture = ApiService.fetchQuiz(widget.subtopicId);
  }

  void _submitAnswer(List<QuizQuestion> questions) async {

    final question = questions[_currentQuestionIndex];

    if (_selectedOptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    final firebaseUid = user?.uid ?? '';

    try {

      final correct = await ApiService.submitQuizAnswer(
        QuizSubmitRequest(
          firebaseUid: firebaseUid,
          subtopicId: widget.subtopicId,
          questionId: question.questionId,
          selectedOptionId: _selectedOptionId!,
        ),
      );

      if (correct) {

        if (_currentQuestionIndex < questions.length - 1) {

          // next question
          setState(() {
            _currentQuestionIndex++;
            _selectedOptionId = null;
            _isSubmitting = false;
          });

        } else {

          // quiz finished
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Icon(Icons.check_circle,
                  color: Colors.green, size: 60),
              content: const Text(
                'Quiz Completed!',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          );

        }

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect. Try again!'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _selectedOptionId = null;
          _isSubmitting = false;
        });
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );

      setState(() => _isSubmitting = false);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Quick Quiz'),
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //     ),
  //
  //     body: FutureBuilder<List<QuizQuestion>>(
  //
  //       future: _quizFuture,
  //
  //       builder: (context, snapshot) {
  //
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //
  //         if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         }
  //
  //         final questions = snapshot.data!;
  //
  //         final question = questions[_currentQuestionIndex];
  //
  //         return Padding(
  //
  //           padding: const EdgeInsets.all(20),
  //
  //           child: Column(
  //
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //
  //             children: [
  //
  //               /// Question number
  //               Text(
  //                 "Question ${_currentQuestionIndex + 1} / ${questions.length}",
  //                 style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //
  //               const SizedBox(height: 10),
  //
  //               /// Question Card
  //               Card(
  //                 elevation: 4,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20)),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(20),
  //                   child: Text(
  //                     question.questionText,
  //                     style: const TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               const Text(
  //                 'Choose your answer:',
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //
  //               const SizedBox(height: 10),
  //
  //               /// Options
  //               Expanded(
  //                 child: ListView.builder(
  //
  //                   itemCount: question.options.length,
  //
  //                   itemBuilder: (context, index) {
  //
  //                     final option = question.options[index];
  //
  //                     return GestureDetector(
  //
  //                       onTap: _isSubmitting
  //                           ? null
  //                           : () {
  //                         setState(() {
  //                           _selectedOptionId = option.optionId;
  //                         });
  //                       },
  //
  //                       child: Container(
  //
  //                         margin:
  //                         const EdgeInsets.symmetric(vertical: 6),
  //
  //                         padding: const EdgeInsets.all(16),
  //
  //                         decoration: BoxDecoration(
  //
  //                           color: _selectedOptionId ==
  //                               option.optionId
  //                               ? const Color(0xFF5F9DF2)
  //                               .withOpacity(0.2)
  //                               : Colors.white,
  //
  //                           border: Border.all(
  //
  //                             color: _selectedOptionId ==
  //                                 option.optionId
  //                                 ? const Color(0xFF5F9DF2)
  //                                 : Colors.grey.shade300,
  //
  //                             width: 2,
  //                           ),
  //
  //                           borderRadius:
  //                           BorderRadius.circular(12),
  //                         ),
  //
  //                         child: Row(
  //                           children: [
  //
  //                             Icon(
  //                               _selectedOptionId ==
  //                                   option.optionId
  //                                   ? Icons.radio_button_checked
  //                                   : Icons
  //                                   .radio_button_unchecked,
  //                               color: const Color(0xFF5F9DF2),
  //                             ),
  //
  //                             const SizedBox(width: 12),
  //
  //                             Expanded(
  //                                 child:
  //                                 Text(option.optionText)),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               ElevatedButton(
  //
  //                 onPressed: _isSubmitting
  //                     ? null
  //                     : () => _submitAnswer(questions),
  //
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: const Color(0xFF5F9DF2),
  //                   padding:
  //                   const EdgeInsets.symmetric(vertical: 16),
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius:
  //                       BorderRadius.circular(30)),
  //                 ),
  //
  //                 child: _isSubmitting
  //                     ? const CircularProgressIndicator(
  //                     color: Colors.white)
  //                     : const Text(
  //                   'Submit',
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  //

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Quick Quiz',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5F9DF2)),
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final questions = snapshot.data!;
          final question = questions[_currentQuestionIndex];
          final progress = (_currentQuestionIndex + 1) / questions.length;

          return Column(
            children: [
              // Progress bar at top
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF5F9DF2)),
                minHeight: 4,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question counter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5F9DF2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Q ${_currentQuestionIndex + 1} of ${questions.length}',
                              style: const TextStyle(
                                  color: Color(0xFF5F9DF2),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ),
                          Icon(Icons.quiz_rounded,
                              color: Colors.grey.shade400),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Question Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5F9DF2), Color(0xFF9C27B0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5F9DF2).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          question.questionText,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text('Choose your answer:',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600)),
                      const SizedBox(height: 12),

                      // Options
                      Expanded(
                        child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            final option = question.options[index];
                            final isSelected = _selectedOptionId == option.optionId;

                            return GestureDetector(
                              onTap: _isSubmitting ? null : () =>
                                  setState(() => _selectedOptionId = option.optionId),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF5F9DF2).withOpacity(0.1)
                                      : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF5F9DF2)
                                        : Colors.grey.shade200,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: const Color(0xFF5F9DF2).withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ] : [],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked_rounded,
                                      color: isSelected
                                          ? const Color(0xFF5F9DF2)
                                          : Colors.grey.shade400,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(option.optionText,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : () => _submitAnswer(questions),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F9DF2),
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                            : const Text('Submit Answer',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}