

import 'package:check_list_qa/domain/entities/activity.dart';

import '../../repositories/project_repository.dart';

class GetActivitiesFromModule {
  final ProjectRepository repo;
  GetActivitiesFromModule(this.repo);

  Future<List<Activity>> call(int projectId, int moduleId) {
    return repo.getAllActivity(projectId, moduleId);
  }
}