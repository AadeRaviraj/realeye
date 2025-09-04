import 'package:flutter/material.dart';


class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<JobReadyModule> jobReadyModules = [
    JobReadyModule(
      title: "Module 1: Computer Fundamentals",
      description: "Learn the basics of computer systems and architecture",
      icon: Icons.computer,
      progress: 0.3,
      topics: [
        "Introduction to Computers",
        "Input Devices",
        "Output Devices",
        "Computer Architecture",
        "Von Neumann Architecture",
        "CPU, RAM, Storage",
        "I/O Devices",
        "Microprocessors",
        "RAM functionality",
        "Storage Devices",
        "Motherboard Components",
        "How computers work from a programmer's perspective"
      ],
    ),
    JobReadyModule(
      title: "Module 2: Programming Fundamentals",
      description: "Master the core concepts of programming",
      icon: Icons.code,
      progress: 0.1,
      topics: ["Variables", "Data Types", "Control Structures", "Functions", "Algorithms"],
    ),
    JobReadyModule(
      title: "Module 3: Object-Oriented Programming",
      description: "Learn OOP principles and design patterns",
      icon: Icons.layers,
      progress: 0.0,
      topics: ["Classes & Objects", "Inheritance", "Polymorphism", "Encapsulation", "Abstraction"],
    ),
    JobReadyModule(
      title: "Module 4: Database Management",
      description: "Understand databases and SQL",
      icon: Icons.storage,
      progress: 0.0,
      topics: ["SQL Basics", "Database Design", "Normalization", "Transactions", "NoSQL"],
    ),
  ];

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

    // Initialize the animation controller first
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Then initialize the animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

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

  // Rest of your code remains the same...
  @override
  Widget build(BuildContext context) {
     return Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Job-Ready Program',
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
                      'Become industry-ready with our comprehensive program',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                _buildJobReadyPrograms(),
                SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Programming Courses',
                      style:Theme.of(context).textTheme.titleLarge ,
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
                SizedBox(height: 24),
                _buildProgrammingCourses(),
              ],
            );
          },
        ),
      ),
    );
  }



// remain exactly the same as in your original code
  Widget _buildJobReadyPrograms() {
    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: jobReadyModules.length,
        itemBuilder: (context, index) {
          final module = jobReadyModules[index];
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Container(
                width: 280,
                margin: EdgeInsets.only(right: 16),
                child: JobReadyModuleCard(module: module),
              ),
            ),
          );
        },
      ),
    );
  }

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
}

class JobReadyModule {
  final String title;
  final String description;
  final IconData icon;
  final double progress;
  final List<String> topics;

  JobReadyModule({
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.topics,
  });
}

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

class ProgrammingCourse {
  final String name;
  final IconData icon;
  final Color color;

  ProgrammingCourse({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class ProgrammingCourseCard extends StatelessWidget {
  final ProgrammingCourse course;

  const ProgrammingCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      //fontSize: 10,
                      fontSize: MediaQuery.of(context).size.width * 0.026, // 2% of screen width

                      color: Colors.grey.shade900,
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