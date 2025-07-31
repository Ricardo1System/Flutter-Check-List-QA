
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/projects_provider/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/project.dart';

// Estado de la lista de proyectos
final projectListProvider = StateNotifierProvider<ProjectListNotifier, List<Project>>((ref) {
  final getProjects = ref.watch(getProjectsProvider);
  final getProjectForId = ref.watch(getProjectForIdProvider);
  final insertProject = ref.watch(insertProjectProvider);
  return ProjectListNotifier(getProjectForId, getProjects, insertProject);
});

// Notifier
class ProjectListNotifier extends StateNotifier<List<Project>> {
  final GetProjectForId _getProjectForId;
  final GetProjects _getProjects;
  final InsertProject _insertProject;

  Future<void> loadProjectForId(int projectId) async {
    final project = await _getProjectForId(projectId);
    state = [project];
  }

  ProjectListNotifier(this._getProjectForId ,this._getProjects, this._insertProject) : super([]) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    state = await _getProjects();
  }

  Future<void> addProject(Project project) async {
    await _insertProject(project);
    await loadProjects();
  }
}
