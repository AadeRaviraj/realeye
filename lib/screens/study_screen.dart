// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:realeyes/ai_chat/chat_screen.dart';
// import 'package:realeyes/screens/topics_screen.dart';
// import '../services/api_service.dart';
// import '../models/course.dart';
// // import 'package:realeyes/features/profile/widgets/ai_chat_fab.dart';
//
// // Keep your existing data models unchanged
// class JobReadyCourse {
//   final int id; //fetch from api
//   final String title;
//   final String description;
//   final IconData icon;
//   final Color color;
//   final List<JobReadyModule> modules;
//
//   JobReadyCourse({
//     required this .id,
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.color,
//     required this.modules,
//   });
// }
//
// class JobReadyModule {
//   final String title;
//   final String description;
//   final IconData icon;
//   final double progress;
//   final List<String> topics;
//
//   JobReadyModule({
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.progress,
//     required this.topics,
//   });
// }
//
// class ProgrammingCourse {
//   final String name;
//   final IconData icon;
//   final Color color;
//
//   ProgrammingCourse({
//     required this.name,
//     required this.icon,
//     required this.color,
//   });
// }
//
// class StudyScreen extends StatefulWidget {
//   @override
//   _StudyScreenState createState() => _StudyScreenState();
// }
//
// class _StudyScreenState extends State<StudyScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _slideAnimation;
//
//   // Sample data for Job Ready courses (unchanged)
//   final List<JobReadyCourse> jobReadyCourses = [
//     JobReadyCourse(
//       id: 1,
//       title: "Job Ready(Python Developer)",
//       description: "Become a proficient in programming from basic to advance",
//       icon: Icons.work,
//       color: Colors.purpleAccent,
//       modules: [
//         JobReadyModule(
//           title: "Module 1: Computer Fundamentals",
//           description: "Learn the basics of computer fundamental",
//           icon: Icons.data_usage,
//           progress: 0.2,
//           topics: [
//             "Introduction to computer ",
//             "Component of computer ",
//             "MicroProcessor",
//             "Storage Device"
//           ],
//         ),
//         JobReadyModule(
//           title: "Module 2: Computer Fundamental",
//           description: "Master in computer fundamental ",
//           icon: Icons.bar_chart,
//           progress: 0.1,
//           topics: [
//             "Introduction to Programming language",
//             "Graphs",
//             "Dashboards",
//             "Tools"
//           ],
//         ),
//       ],
//     ),
//
//     JobReadyCourse(
//       id:2,
//       title: "Data Analyst",
//       description: "Master data analysis and visualization techniques",
//       icon: Icons.analytics,
//       color: Colors.blue,
//       modules: [
//         JobReadyModule(
//           title: "Module 1: Data Fundamentals",
//           description: "Learn the basics of data analysis",
//           icon: Icons.data_usage,
//           progress: 0.2,
//           topics: [
//             "Data Types",
//             "Data Collection",
//             "Data Cleaning",
//             "Basic Statistics"
//           ],
//         ),
//         JobReadyModule(
//           title: "Module 2: Visualization",
//           description: "Master data visualization techniques",
//           icon: Icons.bar_chart,
//           progress: 0.0,
//           topics: ["Charts", "Graphs", "Dashboards", "Tools"],
//         ),
//       ],
//     ),
//     JobReadyCourse(
//       id:3,
//       title: "Data Scientist",
//       description: "Become an expert in machine learning and AI",
//       icon: Icons.science,
//       color: Colors.purple,
//       modules: [
//         JobReadyModule(
//           title: "Module 1: Python for Data Science",
//           description: "Learn Python programming essentials",
//           icon: Icons.code,
//           progress: 0.4,
//           topics: ["Python Basics", "Pandas", "NumPy", "Data Manipulation"],
//         ),
//         JobReadyModule(
//           title: "Module 2: Machine Learning",
//           description: "Introduction to ML algorithms",
//           icon: Icons.model_training,
//           progress: 0.1,
//           topics: [
//             "Regression",
//             "Classification",
//             "Clustering",
//             "Neural Networks"
//           ],
//         ),
//       ],
//     ),
//     JobReadyCourse(
//       id:4,
//       title: "Prompt Engineer",
//       description: "Master the art of AI communication and prompt design",
//       icon: Icons.chat,
//       color: Colors.orange,
//       modules: [
//         JobReadyModule(
//           title: "Module 1: AI Fundamentals",
//           description: "Understand how AI models work",
//           icon: Icons.smart_toy,
//           progress: 0.0,
//           topics: ["AI Basics", "Model Types", "Capabilities", "Limitations"],
//         ),
//         JobReadyModule(
//           title: "Module 2: Prompt Design",
//           description: "Craft effective prompts for AI systems",
//           icon: Icons.text_fields,
//           progress: 0.0,
//           topics: [
//             "Prompt Structures",
//             "Examples",
//             "Best Practices",
//             "Advanced Techniques"
//           ],
//         ),
//       ],
//     ),
//     JobReadyCourse(
//       id:5,
//       title: "Cloud Engineer",
//       description: "Learn cloud infrastructure and deployment",
//       icon: Icons.cloud,
//       color: Colors.green,
//       modules: [
//         JobReadyModule(
//           title: "Module 1: Cloud Basics",
//           description: "Introduction to cloud computing",
//           icon: Icons.cloud_queue,
//           progress: 0.6,
//           topics: [
//             "Cloud Providers",
//             "Services",
//             "Deployment Models",
//             "Security"
//           ],
//         ),
//         JobReadyModule(
//           title: "Module 2: DevOps",
//           description: "Master development operations practices",
//           icon: Icons.settings,
//           progress: 0.3,
//           topics: ["CI/CD", "Containers", "Orchestration", "Monitoring"],
//         ),
//       ],
//     ),
//   ];
//
//   // Sample data for Programming courses (unchanged)
//   final List<ProgrammingCourse> programmingCourses = [
//     ProgrammingCourse(name: "C", icon: Icons.settings, color: Colors.blue),
//     ProgrammingCourse(
//         name: "C++", icon: Icons.settings_applications, color: Colors.purple),
//     ProgrammingCourse(name: "Java", icon: Icons.coffee, color: Colors.orange),
//     ProgrammingCourse(
//         name: "Python", icon: Icons.auto_awesome, color: Colors.green),
//     ProgrammingCourse(
//         name: "JavaScript", icon: Icons.web, color: Colors.yellow.shade700),
//     ProgrammingCourse(
//         name: "Dart", icon: Icons.mobile_friendly, color: Colors.blue.shade300),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Interval(0.0, 0.5, curve: Curves.easeOut),
//       ),
//     );
//     _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Interval(0.3, 1.0, curve: Curves.easeOut),
//       ),
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _animationController.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isWeb = kIsWeb;
//
//     return Scaffold(
//       backgroundColor: Colors.white, // Sky blue + white theme
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: AnimatedBuilder(
//
//           animation: _animationController,
//           builder: (context, child) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header with greeting
//                // _buildHeader(context),
//
//                 const SizedBox(height: 20),
//
//                 // Job Ready Carousel (using your existing carousel but with theme)
//                 _buildJobReadyCarousel(context, isWeb),
//
//                 const SizedBox(height: 30),
//
//                 // API Courses Section (modern grid)
//                 //_buildApiCoursesSection(context),
//
//                 const SizedBox(height: 30),
//
//                 // Job Ready Courses List (unchanged)
//                 _buildJobReadyCoursesList(context),
//
//                 const SizedBox(height: 30),
//
//                 // Programming Courses Grid (unchanged)
//                 _buildProgrammingCourses(context),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // New header widget
//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Hello, Learner!',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: const Color(0xFF2C3E50),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Ready to upskill today?',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: const Color(0xFF7F8C8D),
//               ),
//             ),
//           ],
//         ),
//         CircleAvatar(
//           backgroundColor: const Color(0xFFE3F2FD), // light sky
//           child: Icon(Icons.person, color: const Color(0xFF5F9DF2)), // sky blue
//         ),
//       ],
//     );
//   }
//
//   // Carousel for Job Ready courses (using your existing carousel, but with animation)
//   Widget _buildJobReadyCarousel(BuildContext context, bool isWeb) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           ' Job Ready Career Paths',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 8),
//         CarouselSlider(
//           options: CarouselOptions(
//             autoPlay: true,
//             aspectRatio: isWeb ? 21 / 9 : 16 / 9,
//             enlargeCenterPage: true,
//             viewportFraction: isWeb ? 0.7 : 0.9,
//           ),
//           items: jobReadyCourses.map((course) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: JobReadyCourseCard(course: course),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   // New API courses section with modern grid cards
//   Widget _buildApiCoursesSection(BuildContext context) {
//     return FutureBuilder<List<Course>>(
//       future: ApiService.getCourses(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildShimmerLoader(context);
//         }
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red)),
//           );
//         }
//         final courses = snapshot.data!;
//         if (courses.isEmpty) {
//           return const Center(child: Text('No courses available.'));
//         }
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'All Courses',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 12),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1.2,
//               ),
//               itemCount: courses.length,
//               itemBuilder: (context, index) {
//                 final course = courses[index];
//                 return _buildCourseCard(context, course);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//
// // Modern responsive course card with sky blue accents
//   Widget _buildCourseCard(BuildContext context, Course course) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => TopicsScreen(courseId: course.id),
//             transitionsBuilder: (_, animation, __, child) {
//               const begin = Offset(1.0, 0.0);
//               const end = Offset.zero;
//               const curve = Curves.easeInOut;
//               var tween = Tween(begin: begin, end: end)
//                   .chain(CurveTween(curve: curve));
//               return SlideTransition(position: animation.drive(tween), child: child);
//             },
//           ),
//         );
//       },
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF5F9DF2).withOpacity(0.1),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Top bar
//                 Container(
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF5F9DF2),
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                 ),
//                 // Flexible content
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8), // reduced padding
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Top content
//                         Flexible(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Center(
//                                 child: Container(
//                                   width: 48, // slightly smaller
//                                   height: 48,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFFE3F2FD),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.code,
//                                     color: Color(0xFF5F9DF2),
//                                     size: 26,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8), // reduced spacing
//                               Flexible(
//                                 child: Text(
//                                   course.name,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                     color: Color(0xFF2C3E50),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 '${course.id} lessons',
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Color(0xFF7F8C8D),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Bottom row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: const [
//                             Text(
//                               'Explore',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF5F9DF2),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Icon(Icons.arrow_forward,
//                                 size: 22, color: Color(0xFF5F9DF2)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
//
//
//   // Shimmer loading placeholder for API courses
//   Widget _buildShimmerLoader(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(width: 150, height: 24, color: Colors.grey[300]),
//         const SizedBox(height: 12),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.2,
//           ),
//           itemCount: 4,
//           itemBuilder: (_, __) => Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Existing Job Ready Courses list (unchanged, but with animation preserved)
//   Widget _buildJobReadyCoursesList(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Continue Learning',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 12),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: jobReadyCourses.length,
//           itemBuilder: (context, index) {
//             final course = jobReadyCourses[index];
//             return FadeTransition(
//               opacity: _fadeAnimation,
//               child: Transform.translate(
//                 offset: Offset(0, _slideAnimation.value),
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 16),
//                   child: JobReadyCourseCard(course: course),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   // Existing Programming Courses grid (unchanged, but with animation preserved)
//   Widget _buildProgrammingCourses(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Programming Languages',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 12),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.5,
//           ),
//           itemCount: programmingCourses.length,
//           itemBuilder: (context, index) {
//             final course = programmingCourses[index];
//             return FadeTransition(
//               opacity: _fadeAnimation,
//               child: Transform.translate(
//                 offset: Offset(0, _slideAnimation.value),
//                 child: ProgrammingCourseCard(course: course),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
// // Job Ready Course Card Widget
// class JobReadyCourseCard extends StatelessWidget {
//   final JobReadyCourse course;
//
//   const JobReadyCourseCard({Key? key, required this.course}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             // MaterialPageRoute(
//             //   builder: (context) => CourseModulesScreen(course: course),
//             // ),
//             MaterialPageRoute(
//               builder: (context) => TopicsScreen(courseId: course.id),
//             ),
//           );
//         },
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: course.color.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(course.icon, color: course.color, size: 20),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           course.title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     course.description,
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 13,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Text(
//                         "Explore modules",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Icon(Icons.arrow_forward,
//                           size: 12, color: Colors.grey.shade600),
//                     ],
//                   ),
//                 ],
//               ),
//               // Realeye branding
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     'Realeye',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Programming Course Card Widget
// class ProgrammingCourseCard extends StatelessWidget {
//   final ProgrammingCourse course;
//
//   const ProgrammingCourseCard({Key? key, required this.course})
//       : super(key: key);
//
//   // desining the screen size , it invike teh screen size as per screen width and height
//   double getResponsiveFontSize(BuildContext context, double baseSize) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return screenWidth / 375 * baseSize;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //defing teh screen size it invoke as per screen
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {},
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: course.color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(course.icon, color: course.color, size: 20),
//               ),
//               Text(
//                 course.name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     "Start learning",
//                     style: TextStyle(
//                       // fontSize: 10, // this is the first way that we can define teh screen size fixed
//                       // fontSize:  getResponsiveFontSize(context, 10), // this is teh second way that we can define teh a retunabel function an dus eteh screen size
//
//                       fontSize: screenWidth *
//                           0.027, // this is teh third way that we can use the responsive screen size
//
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(width: 4),
//                   Icon(Icons.arrow_forward,
//                       size: 12, color: Colors.grey.shade600),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Course Modules Screen (shown when a Job Ready course is tapped)
// class CourseModulesScreen extends StatelessWidget {
//   final JobReadyCourse course;
//
//   const CourseModulesScreen({Key? key, required this.course}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(course.title),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "About this course",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             SizedBox(height: 8),
//             Text(
//               course.description,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             SizedBox(height: 24),
//             Text(
//               "Modules",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             SizedBox(height: 16),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: course.modules.length,
//               itemBuilder: (context, index) {
//                 final module = course.modules[index];
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 16),
//                   child: JobReadyModuleCard(module: module),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Job Ready Module Card (reused from existing code)
// class JobReadyModuleCard extends StatelessWidget {
//   final JobReadyModule module;
//
//   const JobReadyModuleCard({Key? key, required this.module}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ModuleDetailScreen(module: module),
//             ),
//           );
//         },
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(module.icon, color: Colors.blue, size: 20),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       module.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               Text(
//                 module.description,
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 13,
//                 ),
//               ),
//               SizedBox(height: 16),
//               LinearProgressIndicator(
//                 value: module.progress,
//                 backgroundColor: Colors.grey.shade200,
//                 color: Colors.blue,
//                 minHeight: 6,
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "${(module.progress * 100).toInt()}% completed",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   Text(
//                     "${module.topics.length} topics",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Module Detail Screen (reused from existing code)
// class ModuleDetailScreen extends StatelessWidget {
//   final JobReadyModule module;
//
//   const ModuleDetailScreen({Key? key, required this.module}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(module.title),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "About this module",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             SizedBox(height: 8),
//             Text(
//               module.description,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             SizedBox(height: 24),
//             Text(
//               "Topics",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             SizedBox(height: 16),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: module.topics.length,
//               separatorBuilder: (context, index) => Divider(height: 1),
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.play_circle_outline,
//                         size: 16, color: Colors.blue),
//                   ),
//                   title: Text(module.topics[index]),
//                   trailing: Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {},
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: ElevatedButton(
//             onPressed: () {},
//             child: Text("Start Learning"),
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// lib/screens/study_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realeyes/screens/topics_screen.dart';
// import 'package:realeyes/widgets/ai_chat_fab.dart';
import '../services/api_service.dart';
import '../models/course.dart';

// ── Data models — unchanged ────────────────────────────────────
class JobReadyCourse {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<JobReadyModule> modules;
  JobReadyCourse({required this.id, required this.title, required this.description, required this.icon, required this.color, required this.modules});
}

class JobReadyModule {
  final String title;
  final String description;
  final IconData icon;
  final double progress;
  final List<String> topics;
  JobReadyModule({required this.title, required this.description, required this.icon, required this.progress, required this.topics});
}

class ProgrammingCourse {
  final String name;
  final IconData icon;
  final Color color;
  ProgrammingCourse({required this.name, required this.icon, required this.color});
}

// ── Main Screen ────────────────────────────────────────────────
class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // ── Data — unchanged ─────────────────────────────────────────
  final List<JobReadyCourse> jobReadyCourses = [
    JobReadyCourse(id: 1, title: "Python Developer", description: "From basics to advanced programming", icon: Icons.code, color: const Color(0xFF8E54E9), modules: [
      JobReadyModule(title: "Computer Fundamentals", description: "Basics of computing", icon: Icons.computer, progress: 0.2, topics: ["Intro to Computer", "Components", "MicroProcessor", "Storage"]),
      JobReadyModule(title: "Programming Basics", description: "Start coding journey", icon: Icons.terminal, progress: 0.1, topics: ["Intro to Programming", "Variables", "Loops", "Functions"]),
    ]),
    JobReadyCourse(id: 2, title: "Data Analyst", description: "Master data analysis & visualization", icon: Icons.analytics, color: const Color(0xFF4776E6), modules: [
      JobReadyModule(title: "Data Fundamentals", description: "Basics of data analysis", icon: Icons.data_usage, progress: 0.2, topics: ["Data Types", "Collection", "Cleaning", "Statistics"]),
      JobReadyModule(title: "Visualization", description: "Charts and dashboards", icon: Icons.bar_chart, progress: 0.0, topics: ["Charts", "Graphs", "Dashboards", "Tools"]),
    ]),
    JobReadyCourse(id: 3, title: "Data Scientist", description: "Machine learning & AI expert", icon: Icons.science, color: const Color(0xFF11998E), modules: [
      JobReadyModule(title: "Python for DS", description: "Python essentials", icon: Icons.code, progress: 0.4, topics: ["Python Basics", "Pandas", "NumPy", "Data Manipulation"]),
      JobReadyModule(title: "Machine Learning", description: "ML algorithms", icon: Icons.model_training, progress: 0.1, topics: ["Regression", "Classification", "Clustering", "Neural Networks"]),
    ]),
    JobReadyCourse(id: 4, title: "Prompt Engineer", description: "AI communication & prompt design", icon: Icons.smart_toy, color: const Color(0xFFF7971E), modules: [
      JobReadyModule(title: "AI Fundamentals", description: "How AI models work", icon: Icons.psychology, progress: 0.0, topics: ["AI Basics", "Model Types", "Capabilities", "Limitations"]),
    ]),
    JobReadyCourse(id: 5, title: "Cloud Engineer", description: "Cloud infrastructure & deployment", icon: Icons.cloud, color: const Color(0xFF38EF7D), modules: [
      JobReadyModule(title: "Cloud Basics", description: "Intro to cloud computing", icon: Icons.cloud_queue, progress: 0.6, topics: ["Providers", "Services", "Deployment", "Security"]),
    ]),
  ];

  final List<ProgrammingCourse> programmingCourses = [
    ProgrammingCourse(name: "C", icon: Icons.settings, color: const Color(0xFF4776E6)),
    ProgrammingCourse(name: "C++", icon: Icons.settings_applications, color: const Color(0xFF8E54E9)),
    ProgrammingCourse(name: "Java", icon: Icons.coffee, color: const Color(0xFFF7971E)),
    ProgrammingCourse(name: "Python", icon: Icons.auto_awesome, color: const Color(0xFF11998E)),
    ProgrammingCourse(name: "JavaScript", icon: Icons.web, color: const Color(0xFFFC5C7D)),
    ProgrammingCourse(name: "Dart", icon: Icons.phone_android, color: const Color(0xFF5F9DF2)),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isWeb = kIsWeb;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF2F4F8),
      // floatingActionButton: const AIChatFab(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Top Greeting Banner ─────────────────────
                  SliverToBoxAdapter(child: _GreetingBanner(isDark: isDark)),

                  // ── Career Paths ────────────────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Career Paths',
                      subtitle: 'Choose your learning track',
                      icon: Icons.rocket_launch_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _CareerPathCarousel(
                      courses: jobReadyCourses,
                      isWeb: isWeb,
                      isDark: isDark,
                    ),
                  ),

                  // ── Continue Learning ───────────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Continue Learning',
                      subtitle: 'Pick up where you left off',
                      icon: Icons.play_circle_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _CourseListCard(
                          course: jobReadyCourses[index],
                          isDark: isDark,
                        ),
                        childCount: jobReadyCourses.length,
                      ),
                    ),
                  ),

                  // ── Programming Languages ───────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Programming Languages',
                      subtitle: 'Master a language from scratch',
                      icon: Icons.terminal_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _ProgrammingCard(
                          course: programmingCourses[index],
                          isDark: isDark,
                        ),
                        childCount: programmingCourses.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// GREETING BANNER
// ──────────────────────────────────────────────────────────────
class _GreetingBanner extends StatelessWidget {
  final bool isDark;
  const _GreetingBanner({required this.isDark});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Ready to learn\nsomething new?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Start Learning',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Decorative icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SECTION HEADER
// ──────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4776E6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4776E6), size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CAREER PATH CAROUSEL
// ──────────────────────────────────────────────────────────────
class _CareerPathCarousel extends StatefulWidget {
  final List<JobReadyCourse> courses;
  final bool isWeb;
  final bool isDark;

  const _CareerPathCarousel({
    required this.courses,
    required this.isWeb,
    required this.isDark,
  });

  @override
  State<_CareerPathCarousel> createState() => _CareerPathCarouselState();
}

class _CareerPathCarouselState extends State<_CareerPathCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            aspectRatio: widget.isWeb ? 21 / 7 : 16 / 7,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            viewportFraction: widget.isWeb ? 0.5 : 0.85,
            onPageChanged: (index, _) =>
                setState(() => _currentIndex = index),
          ),
          items: widget.courses.map((course) {
            return _CarouselCard(course: course, isDark: widget.isDark);
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.courses.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == entry.key ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == entry.key
                    ? const Color(0xFF4776E6)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final JobReadyCourse course;
  final bool isDark;

  const _CarouselCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TopicsScreen(courseId: course.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              course.color,
              course.color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: course.color.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -10,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(course.icon,
                            color: Colors.white, size: 22),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Explore →',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COURSE LIST CARD (Continue Learning section)
// ──────────────────────────────────────────────────────────────
class _CourseListCard extends StatelessWidget {
  final JobReadyCourse course;
  final bool isDark;

  const _CourseListCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TopicsScreen(courseId: course.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(course.icon, color: course.color, size: 26),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    course.description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Module count chips
                  Row(
                    children: [
                      _InfoChip(
                        label: '${course.modules.length} modules',
                        color: course.color,
                      ),
                      const SizedBox(width: 6),
                      _InfoChip(
                        label: 'Job Ready',
                        color: const Color(0xFF11998E),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Arrow
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_rounded,
                  color: course.color, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PROGRAMMING LANGUAGE CARD
// ──────────────────────────────────────────────────────────────
class _ProgrammingCard extends StatelessWidget {
  final ProgrammingCourse course;
  final bool isDark;

  const _ProgrammingCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${course.name} course coming soon!'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(course.icon, color: course.color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              course.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Learn',
              style: TextStyle(
                fontSize: 10,
                color: course.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Kept for backward compatibility ────────────────────────────
class JobReadyCourseCard extends StatelessWidget {
  final JobReadyCourse course;
  const JobReadyCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CarouselCard(
        course: course,
        isDark: Theme.of(context).brightness == Brightness.dark);
  }
}

class ProgrammingCourseCard extends StatelessWidget {
  final ProgrammingCourse course;
  const ProgrammingCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ProgrammingCard(
        course: course,
        isDark: Theme.of(context).brightness == Brightness.dark);
  }
}

class CourseModulesScreen extends StatelessWidget {
  final JobReadyCourse course;
  const CourseModulesScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: const Center(child: Text('Module details')),
    );
  }
}

class ModuleDetailScreen extends StatelessWidget {
  final JobReadyModule module;
  const ModuleDetailScreen({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: const Center(child: Text('Topic details')),
    );
  }
}

class JobReadyModuleCard extends StatelessWidget {
  final JobReadyModule module;
  const JobReadyModuleCard({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(module.title)),
    );
  }
}