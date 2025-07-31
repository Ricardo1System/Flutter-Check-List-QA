

import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/repositories/project_repository.dart';

class UpdateActivityFromModule {
  final ProjectRepository repo;

  UpdateActivityFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, Activity activity) async {
    return repo.updateActivity(projectId, moduleId, activity);
  }
}

class UpdateActivityFromSubModule {
  final ProjectRepository repo;

  UpdateActivityFromSubModule(this.repo);

  Future<void> call(int projectId, int moduleId, int subModuleId, Activity activity) async {
    return repo.updateActivityFromSubModule(projectId, moduleId, subModuleId, activity);
  }
}