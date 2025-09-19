import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';



// Data models
class JobReadyCourse {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<JobReadyModule> modules;

  JobReadyCourse({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.modules,
  });
}

class JobReadyModule {
  final String title;
  final String description;
  final IconData icon;
  final double progress;
  final List<String> topics;

  JobReadyModule({
    //job module constructor
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.topics,
  });
}

class ProgrammingCourse {
  // class for programming courses detail
  final String name;
  final IconData icon;
  final Color color;

  ProgrammingCourse({
    // constructor for pass the when object created
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Main Study Screen
class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;


  // Sample data for Job Ready courses
  final List<JobReadyCourse> jobReadyCourses = [
    JobReadyCourse(
      title: "Job Ready(Python Developer)",
      description: "Become a proficient in programming from basic to advance",
      icon: Icons.work,
      color: Colors.purpleAccent,
      modules: [
        JobReadyModule(
          title: "Module 1: Computer Fundamentals",
          description: "Learn the basics of computer fundamental",
          icon: Icons.data_usage,
          progress: 0.2,
          topics: ["Introduction to computer ", "Component of computer ", "MicroProcessor", "Storage Device"],
        ),
        JobReadyModule(
          title: "Module 2: Computer Fundamental",
          description: "Master in computer fundamental ",
          icon: Icons.bar_chart,
          progress: 0.1,
          topics: ["Introduction to Programming language", "Graphs", "Dashboards", "Tools"],
        ),
      ],
    ),
    JobReadyCourse(
      title: "Data Analyst",
      description: "Master data analysis and visualization techniques",
      icon: Icons.analytics,
      color: Colors.blue,
      modules: [
        JobReadyModule(
          title: "Module 1: Data Fundamentals",
          description: "Learn the basics of data analysis",
          icon: Icons.data_usage,
          progress: 0.2,
          topics: ["Data Types", "Data Collection", "Data Cleaning", "Basic Statistics"],
        ),
        JobReadyModule(
          title: "Module 2: Visualization",
          description: "Master data visualization techniques",
          icon: Icons.bar_chart,
          progress: 0.0,
          topics: ["Charts", "Graphs", "Dashboards", "Tools"],
        ),
      ],
    ),
    JobReadyCourse(
      title: "Data Scientist",
      description: "Become an expert in machine learning and AI",
      icon: Icons.science,
      color: Colors.purple,
      modules: [
        JobReadyModule(
          title: "Module 1: Python for Data Science",
          description: "Learn Python programming essentials",
          icon: Icons.code,
          progress: 0.4,
          topics: ["Python Basics", "Pandas", "NumPy", "Data Manipulation"],
        ),
        JobReadyModule(
          title: "Module 2: Machine Learning",
          description: "Introduction to ML algorithms",
          icon: Icons.model_training,
          progress: 0.1,
          topics: ["Regression", "Classification", "Clustering", "Neural Networks"],
        ),
      ],
    ),
    JobReadyCourse(
      title: "Prompt Engineer",
      description: "Master the art of AI communication and prompt design",
      icon: Icons.chat,
      color: Colors.orange,
      modules: [
        JobReadyModule(
          title: "Module 1: AI Fundamentals",
          description: "Understand how AI models work",
          icon: Icons.smart_toy,
          progress: 0.0,
          topics: ["AI Basics", "Model Types", "Capabilities", "Limitations"],
        ),
        JobReadyModule(
          title: "Module 2: Prompt Design",
          description: "Craft effective prompts for AI systems",
          icon: Icons.text_fields,
          progress: 0.0,
          topics: ["Prompt Structures", "Examples", "Best Practices", "Advanced Techniques"],
        ),
      ],
    ),
    JobReadyCourse(
      title: "Cloud Engineer",
      description: "Learn cloud infrastructure and deployment",
      icon: Icons.cloud,
      color: Colors.green,
      modules: [
        JobReadyModule(
          title: "Module 1: Cloud Basics",
          description: "Introduction to cloud computing",
          icon: Icons.cloud_queue,
          progress: 0.6,
          topics: ["Cloud Providers", "Services", "Deployment Models", "Security"],
        ),
        JobReadyModule(
          title: "Module 2: DevOps",
          description: "Master development operations practices",
          icon: Icons.settings,
          progress: 0.3,
          topics: ["CI/CD", "Containers", "Orchestration", "Monitoring"],
        ),
      ],
    ),
  ];

  // Sample data for Programming courses
  final List<ProgrammingCourse> programmingCourses = [
    ProgrammingCourse(name: "C", icon: Icons.settings, color: Colors.blue),
    ProgrammingCourse(name: "C++", icon: Icons.settings_applications, color: Colors.purple),
    ProgrammingCourse(name: "Java", icon: Icons.coffee, color: Colors.orange),
    ProgrammingCourse(name: "Python", icon: Icons.auto_awesome, color: Colors.green),
    ProgrammingCourse(name: "JavaScript", icon: Icons.web, color: Colors.yellow.shade700),
    ProgrammingCourse(name: "Dart", icon: Icons.mobile_friendly, color: Colors.blue.shade300),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Configure fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Configure slide animation
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animations after build completes
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
    final bool isWeb = kIsWeb;

    return Scaffold(
      // appBar: AppBar(
      //  // title: Text('LearnHub'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.notifications_none),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big Job Ready Card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                   // child: _buildJobReadyCard(),
                  ),
                ),
                SizedBox(height: 0),



// Slider card using padding

                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 2,
                //     horizontal: isWeb ? 100 : 10,
                //   ),
                //   child: CarouselSlider(
                //     options: CarouselOptions(
                //       autoPlay: true,
                //       aspectRatio: isWeb ? 21 / 9 : 16 / 9,
                //       enlargeCenterPage: true,
                //       viewportFraction: isWeb ? 0.7 : 0.9,
                //     ),
                //     items: jobReadyCourses.map((course) {
                //       return Builder(
                //         builder: (BuildContext context) {
                //           return ClipRRect(
                //             borderRadius: BorderRadius.circular(15),
                //             child: JobReadyCourseCard(course: course), //
                //           );
                //         },
                //       );
                //     }).toList(),
                //   ),
                // ),

// slider using simple row
                Row(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: isWeb ? 21 / 9 : 16 / 9,
                          enlargeCenterPage: true,
                          viewportFraction: isWeb ? 0.7 : 0.9,
                        ),
                        items: jobReadyCourses.map((course) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: JobReadyCourseCard(course: course),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),



                SizedBox(height: 24,),
                // Job Ready Courses Section Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Job Ready Career Paths',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Choose your career path and become industry-ready',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Job Ready Courses List
                _buildJobReadyCoursesList(),
                SizedBox(height: 32),

                // Programming Courses Section Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Programming Courses',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Explore language-specific courses',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Programming Courses Grid
                _buildProgrammingCourses(),
              ],
            );
          },
        ),
      ),

      // Chat with AI FAB
        floatingActionButton: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent.shade400,
                Colors.lightBlue,

              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () {
                _showChatDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Chat with AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );



        //     floatingActionButton: FloatingActionButton.extended(
  //       onPressed: () {
  //         _showChatDialog(context);
  //       },
  //       icon: Icon(Icons.chat),
  //       label: Text('Chat with AI'),
  //       backgroundColor: Theme.of(context).colorScheme.primary,
  //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
  //     ),
  //   );
   }

  // This is an teh job ready widget
  // Widget _buildJobReadyCard() {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Container(
  //       width: double.infinity,
  //       padding: EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(16),
  //         gradient: LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           // colors: [
  //           //   Theme.of(context).colorScheme.primary,
  //           //   Theme.of(context).colorScheme.primary.withOpacity(0.1),
  //           // ],
  //           colors: [
  //             Colors.lightBlue,
  //             Colors.purpleAccent.shade400,
  //           ],
  //         ),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.work, size: 28, color: Colors.white),
  //               SizedBox(width: 8),
  //               Text(
  //                 'Job Ready Program',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 12),
  //           Text(
  //             'Industry-focused learning paths to launch your tech career',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.white.withOpacity(0.9),
  //             ),
  //           ),
  //           SizedBox(height: 16),
  //           // Realeye branding
  //           Align(
  //             alignment: Alignment.bottomRight,
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Text(
  //                 'Realeye',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  // Build the list of Job Ready courses
  Widget _buildJobReadyCoursesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: jobReadyCourses.length,
      itemBuilder: (context, index) {
        final course = jobReadyCourses[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              child: JobReadyCourseCard(course: course),
            ),
          ),
        );
      },
    );
  }

  // Build the Programming courses grid
  Widget _buildProgrammingCourses() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: programmingCourses.length,
      itemBuilder: (context, index) {
        final course = programmingCourses[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: ProgrammingCourseCard(course: course),
          ),
        );
      },
    );
  }

  // Show chat dialog
  void _showChatDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Text(
                'Chat with AI Assistant',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).colorScheme.surfaceVariant,
                  //   borderRadius: BorderRadius.circular(12),
                  // ),.
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     colors: [
                  //       Colors.lightBlue,
                  //       Colors.purpleAccent.shade400,
                  //     ],
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //   ),
                  //   borderRadius: BorderRadius.circular(12),
                  // ),

                  child: Center(



                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [
                                  Colors.lightBlue,
                                  Colors.purpleAccent.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'AI Chat Feature Coming Soon!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ask questions and get help with your learning journey',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }


}

// Job Ready Course Card Widget
class JobReadyCourseCard extends StatelessWidget {
  final JobReadyCourse course;

  const JobReadyCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseModulesScreen(course: course),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: course.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(course.icon, color: course.color, size: 20),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          course.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Explore modules",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 12, color: Colors.grey.shade600),
                    ],
                  ),
                ],
              ),
              // Realeye branding
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Realeye',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Programming Course Card Widget
class ProgrammingCourseCard extends StatelessWidget {
  final ProgrammingCourse course;

  const ProgrammingCourseCard({Key? key, required this.course}) : super(key: key);

  // desining the screen size , it invike teh screen size as per screen width and height
  double getResponsiveFontSize(BuildContext context, double baseSize){
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / 375 * baseSize;
  }

  @override
  Widget build(BuildContext context) {
    //defing teh screen size it invoke as per screen
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: course.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(course.icon, color: course.color, size: 20),
              ),
              Text(
                course.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Start learning",
                    style: TextStyle(
                      // fontSize: 10, // this is the first way that we can define teh screen size fixed
                      // fontSize:  getResponsiveFontSize(context, 10), // this is teh second way that we can define teh a retunabel function an dus eteh screen size

                      fontSize: screenWidth * 0.027, // this is teh third way that we can use the responsive screen size

                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 12, color: Colors.grey.shade600),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Course Modules Screen (shown when a Job Ready course is tapped)
class CourseModulesScreen extends StatelessWidget {
  final JobReadyCourse course;

  const CourseModulesScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About this course",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              course.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Text(
              "Modules",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: course.modules.length,
              itemBuilder: (context, index) {
                final module = course.modules[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: JobReadyModuleCard(module: module),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Job Ready Module Card (reused from existing code)
class JobReadyModuleCard extends StatelessWidget {
  final JobReadyModule module;

  const JobReadyModuleCard({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleDetailScreen(module: module),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(module.icon, color: Colors.blue, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      module.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                module.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: module.progress,
                backgroundColor: Colors.grey.shade200,
                color: Colors.blue,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${(module.progress * 100).toInt()}% completed",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    "${module.topics.length} topics",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Module Detail Screen (reused from existing code)
class ModuleDetailScreen extends StatelessWidget {
  final JobReadyModule module;

  const ModuleDetailScreen({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About this module",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              module.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Text(
              "Topics",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: module.topics.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_circle_outline, size: 16, color: Colors.blue),
                  ),
                  title: Text(module.topics[index]),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Start Learning"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}