import '../entities/project.dart';

abstract class ProjectRepository {
  Future<void> insert(Project project);
  Future<List<Project>> getAll();
  Future<void> delete(int id);
}
