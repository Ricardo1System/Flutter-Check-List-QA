
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/projects_provider/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/project.dart';

// Estado de la lista de proyectos
final projectTestListProvider = StateNotifierProvider<ProjectTestListNotifier, List<Project>>((ref) {
  final getProjects = ref.watch(getProjectsProvider);
  return ProjectTestListNotifier(getProjects);
});

// Notifier
class ProjectTestListNotifier extends StateNotifier<List<Project>> {
  final GetProjects _getProjects;

  ProjectTestListNotifier(this._getProjects) : super([]) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    state = await _getProjects();
  }

  Future<void> addProject(Project project) async {
    await loadProjects();
  }
}
