// domain/usecases/add_activity.dart

import '../../repositories/project_repository.dart';

class DeleteActivityFromModule {
  final ProjectRepository repo;
  DeleteActivityFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, int activityId) {
    return repo.deleteActivity(projectId, moduleId, activityId);
  }
}
