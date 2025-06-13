import '../models/project_model.dart';

abstract class ProjectLocalDataSource {
  //Projects
  Future<void> insertProject(ProjectModel project);
  Future<List<ProjectModel>> getAllProjects();
  Future<void> deleteProject(int id);
  // //Modules
  // Future<void> addModuleToProject(int projectId, Module module);
  // Future<void> removeModuleToProject(int projectId, int moduleId);
  // //Activities
  // Future<void> addActivityToModule(int projectId, int moduleId, Activity activity);
  // Future<void> removeActivityToModule(int projectId, int moduleId, int activityId);

}
