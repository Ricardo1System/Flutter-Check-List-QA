
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/presentation/screens/project_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(ModuleModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());
  await Hive.openBox<ProjectModel>('projects');
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA CheckList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProjectListScreen(),
    );
  }
}
