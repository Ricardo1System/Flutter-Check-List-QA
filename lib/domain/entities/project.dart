import 'package:check_list_qa/domain/entities/module.dart';

class Project {
  int id;
  String name;
  String description;
  List<Module>? modules;

  Project({
    required this.id,
    required this.name,
    required this.description,
    this.modules = const [],
  });
}

class ProjectTest {
  int id;
  String name;
  String description;
  List<ModuleTest>? modules;

  ProjectTest({
    required this.id,
    required this.name,
    required this.description,
    this.modules = const [],
  });
    /// Factory constructor para convertir desde Project
  factory ProjectTest.fromProject(Project project) {
    return ProjectTest(
      id: project.id,
      name: project.name,
      description: project.description,
      modules: project.modules?.map((m) => ModuleTest.fromModule(m)).toList(),
    );
  }
}
