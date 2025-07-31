import 'package:check_list_qa/domain/entities/project.dart';
import 'package:check_list_qa/presentation/providers/projects_provider/project_provider.dart';
import 'package:check_list_qa/presentation/screens/test_screens/project_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key, required this.project});
  final Project project;

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {

  @override
  void initState() {
    ref.read(projectListProvider.notifier).loadProjectForId(widget.project.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var project = ProjectTest.fromProject(ref.watch(projectListProvider)[0]);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber[200],
              border: Border.all(
                color: Colors.amber,
                width: 2.0
              )
            ),
            padding: const EdgeInsets.all(12.0),
            child: const Text(
                "Esta prueba es en general de todo el proyecto, sí estas de acuerdo en continuar, has click al botón de play"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectTestScreen(project: project),
              ));
        },
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.green[200],
          size: 50,
        ),
      ),
    );
  }
}