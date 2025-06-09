import '../models/project_model.dart';

abstract class ProjectLocalDataSource {
  Future<void> insert(ProjectModel project);
  Future<List<ProjectModel>> getAll();
  Future<void> delete(int id);
}
