import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;

  GetProjects(this.repository);

  Future<List<Project>> call() async {
    return await repository.getAllProjects();
  }
}
