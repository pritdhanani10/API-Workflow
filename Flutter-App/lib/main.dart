import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';
import 'screens/students_screen.dart';
import 'screens/api_flow_screen.dart';
import 'widgets/architecture_header.dart';

void main() {
  runApp(const ApiWorkflowApp());
}

class ApiWorkflowApp extends StatelessWidget {
  const ApiWorkflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Workflow - Flutter to .NET Web API & MySQL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 4,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
        ),
      ),
      home: const ApiWorkflowHomePage(),
    );
  }
}

class ApiWorkflowHomePage extends StatefulWidget {
  const ApiWorkflowHomePage({super.key});

  @override
  State<ApiWorkflowHomePage> createState() => _ApiWorkflowHomePageState();
}

class _ApiWorkflowHomePageState extends State<ApiWorkflowHomePage>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  int _studentCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onStudentsUpdated(List<Student> students) {
    setState(() {
      _studentCount = students.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              '🚀 API Workflow Architecture',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Flutter ➔ .NET Web API ➔ MySQL',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF06B6D4),
          indicatorWeight: 3,
          tabs: [
            Tab(
              icon: const Icon(Icons.people_outline),
              text: 'Students ($_studentCount)',
            ),
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows),
                  const SizedBox(width: 4),
                  if (_apiService.logs.isNotEmpty)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_apiService.logs.length}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
              text: 'API Flow Inspector',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const ArchitectureHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StudentsScreen(
                  apiService: _apiService,
                  onStudentsUpdated: _onStudentsUpdated,
                ),
                ApiFlowScreen(
                  apiService: _apiService,
                  onClearLogs: () => setState(() => _apiService.clearLogs()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
