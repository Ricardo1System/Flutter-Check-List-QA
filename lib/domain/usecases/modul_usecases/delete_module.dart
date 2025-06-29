// domain/usecases/add_module.dart

import '../../repositories/project_repository.dart';

class DeleteModuleFromProject {
  final ProjectRepository repo;
  DeleteModuleFromProject(this.repo);

  Future<void> call(int projectId, int moduleId) {
    return repo.deleteModule(projectId, moduleId);
  }
}
