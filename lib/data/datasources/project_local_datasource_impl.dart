import 'package:hive/hive.dart';

import '../models/project_model.dart';
import 'project_local_datasource.dart';

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box<ProjectModel> _box = Hive.box<ProjectModel>('projects');
  
  // @override
  // Future<void> addActivityToModule(int projectId, int moduleId, Activity activity) async {
  //   final projectList = await getAllProjects();
  //   var project = projectList.firstWhere(
  //     (e) => e.id == projectId,
  //     orElse: () =>
  //         throw Exception("No se encontro el Projecto con el Id: $projectId"),
  //   );
  //   var modules = project.modules;
  //   final targetModule = modules?.firstWhere((m) => m.id == moduleId);
  //   if (targetModule != null) {
  //     var activities = targetModule.activities??=[];
  //     activities.add(ActivityModel.fromEntity(activity));
  //     var index = modules?.indexOf(targetModule);
  //     modules![index!] = targetModule;
  //     await _box.put(projectId, project);
  //   }
  // }
  
  // @override
  // Future<void> addModuleToProject(int projectId, Module module) async {
  //   final projectList = await getAllProjects();
  //   var project = projectList.firstWhere(
  //     (e) => e.id == projectId,
  //     orElse: () =>
  //         throw Exception("No se encontro el projecto con el id: $projectId"),
  //   );
  //   project.modules ??= [];
  //   project.modules!.add(ModuleModel.fromEntity(module));
  //   await _box.put(projectId, project);
  // }
  
  @override
  Future<void> deleteProject(int id) async {
    await _box.delete(id);
  }
  
  @override
  Future<List<ProjectModel>> getAllProjects() async {
    return _box.values.toList();
  }
  
  @override
  Future<void> insertProject(ProjectModel project) async {
    await _box.put(project.id, project);
  }
  
  // @override
  // Future<void> removeActivityToModule(int projectId, int moduleId, int activityId) {
  //   // TODO: implement removeActivityToModule
  //   throw UnimplementedError();
  // }
  
  // @override
  // Future<void> removeModuleToProject(int projectId, int moduleId) {
  //   // TODO: implement removeModuleToProject
  //   throw UnimplementedError();
  // }

}
