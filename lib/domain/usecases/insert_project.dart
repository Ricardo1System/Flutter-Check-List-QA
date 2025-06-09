import '../entities/project.dart';
import '../repositories/project_repository.dart';

class InsertProject {
  final ProjectRepository repository;

  InsertProject(this.repository);

  Future<void> call(Project project) async {
    await repository.insert(project);
  }
}
