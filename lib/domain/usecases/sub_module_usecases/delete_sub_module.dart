// domain/usecases/add_activity.dart

import '../../repositories/project_repository.dart';

class DeleteSubModuleFromModule {
  final ProjectRepository repo;
  DeleteSubModuleFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, int subModuleId) {
    return repo.deleteSubModule(projectId, moduleId, subModuleId);
  }
}
