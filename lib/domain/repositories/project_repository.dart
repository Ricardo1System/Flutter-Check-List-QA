import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/modul.dart';

import '../entities/project.dart';

abstract class ProjectRepository {
  Future<void> insertProject(Project project);
  Future<List<Project>> getAllProjects();
  Future<void> deleteProject(int id);

  Future<void> insertModule(
    Module module,
    int projectId,
  );
  Future<void> reorderModules(
    int projectId,
    int oldIndex,
    int newIndex,
  );
  Future<List<Module>> getAllModule(int projectId);
  Future<void> deleteModule(
    int projectId,
    int moduleId,
  );

  Future<void> insertActivity(
    Activity activity,
    int projectId,
    int moduleId,
  );
  Future<void> reorderActivities(
    int projectId,
    int moduleId,
    int oldIndex,
    int newIndex,
  );
  Future<List<Activity>> getAllActivity(
    int projectId,
    int moduleId,
  );
  Future<void> deleteActivity(
    int projectId,
    int moduleId,
    int activityId,
  );
}
