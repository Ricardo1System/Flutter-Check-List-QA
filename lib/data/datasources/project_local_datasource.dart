import '../models/project_model.dart';

abstract class ProjectLocalDataSource {
  //Projects
  Future<void> insertProject(ProjectModel project);
  Future<List<ProjectModel>> getAllProjects();
  Future<void> deleteProject(int id);

}
