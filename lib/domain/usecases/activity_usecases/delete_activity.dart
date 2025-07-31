// domain/usecases/add_activity.dart

import '../../repositories/project_repository.dart';

class DeleteActivityFromModule {
  final ProjectRepository repo;
  DeleteActivityFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, int activityId) {
    return repo.deleteActivity(projectId, moduleId, activityId);
  }
}

class DeleteActivityFromSubModule {
  final ProjectRepository repo;
  DeleteActivityFromSubModule(this.repo);

  Future<void> call(int projectId, int moduleId, int subModuleId, int activityId) {
    return repo.deleteActivityFromSubModule(projectId, moduleId, subModuleId, activityId);
  }
}
