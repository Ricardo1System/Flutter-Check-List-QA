import 'package:check_list_qa/data/datasources/project_local_datasource.dart';
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/modul.dart';

import '../../../domain/entities/project.dart';
import '../../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource local;

  ProjectRepositoryImpl(this.local);

  @override
  Future<void> insertProject(Project project) async {
    final model = ProjectModel.fromEntity(project);
    await local.insertProject(model);
  }

  @override
  Future<List<Project>> getAllProjects() async {
    final models = await local.getAllProjects();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> deleteProject(int id) async {
    await local.deleteProject(id);
  }

  @override
  Future<void> deleteActivity(int projectId, int moduleId, int activityId) async {
    final projectList = await local.getAllProjects();
    final project = projectList.firstWhere((e) => e.id ==projectId,
    orElse: () => throw Exception("No se encontró el proyecto con de la actividad"),);
    final moduleList = project.modules ??=[];
    final module = moduleList.firstWhere((e) => e.id == moduleId,
    orElse: () => throw Exception("No se encontró el módulo de la actividad"),);
    final moduleIndex = moduleList.indexWhere((e) => e.id == moduleId,);
    final activityList =module.activities ??=[];
    activityList.removeWhere((e) => e.id == activityId,);
    project.modules![moduleIndex].activities=activityList;
    await project.save();
  }

  @override
  Future<void> deleteModule(int projectId, int moduleId) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    project.modules!.removeWhere((ModuleModel m) => m.id == moduleId);
    await project.save();
  }

  @override
  Future<List<Activity>> getAllActivity(int projectId, int moduleId) async {
    final allProjects = await local.getAllProjects();
    var project = allProjects.firstWhere((e) => e.id == projectId,);
    var module = project.modules!.firstWhere((e) => e.id == moduleId,);
    return module.activities?.map((e) => e.toEntity(),).toList() ?? [];
  }

  @override
  Future<List<Module>> getAllModule(int projectId) async {
    final allProjects = await local.getAllProjects();
    var moduleModellist = allProjects.firstWhere((e) => e.id == projectId,).modules;
    moduleModellist ??=[];
    return moduleModellist.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> insertActivity( Activity activity, int projectId, int moduleId) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );
    final module = project.modules?.firstWhere(
      (e) => e.id == moduleId,
    );
    final index = project.modules?.indexOf(module!);
    var activities = module!.activities ??= [];
    activities.add(ActivityModel.fromEntity(activity));
    project.modules![index!].activities = activities;
    await project.save();
  }

  @override
  Future<void> insertModule(Module module, int projectId) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    project.modules!.add(ModuleModel.fromEntity(module)); // si estás usando .toModel()
    await project.save();
  }
  
  @override
  Future<void> reorderActivities(int projectId, int moduleId, int oldIndex, int newIndex) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => throw Exception('Proyecto no encontrado con id: $projectId'),
    );
    final module = project.modules![moduleId];

    if (newIndex > oldIndex) newIndex--;

    final activity = module.activities!.removeAt(oldIndex);
    module.activities!.insert(newIndex, activity);

    await project.save();
  }
  
  @override
  Future<void> reorderModules(int projectId, int oldIndex, int newIndex) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    if (newIndex > oldIndex) newIndex--; // necesario por cómo funciona ReorderableListView

    final modules = project.modules;
    final moved = modules!.removeAt(oldIndex);
    modules.insert(newIndex, moved);

    await project.save(); // HiveObject.save()
  }
  
  @override
  Future<void> updateActivity(int projectId, int moduleId, Activity activityUpdate) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );
    final module = project.modules?.firstWhere(
      (e) => e.id == moduleId,
    );
    final index = project.modules?.indexOf(module!);
    var activities = module!.activities ??= [];
    var oldActivity = activities.firstWhere((e) => e.id == activityUpdate.id,);
    final indexOldActivity = activities.indexOf(oldActivity);
    activities.remove(oldActivity);
    activities.insert(indexOldActivity, ActivityModel.fromEntity(activityUpdate));
    project.modules![index!].activities = activities;
    await project.save();
  }

  @override
  Future<void> updateModule(int projectId, Module moduleUpdate ) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );
    final module = project.modules?.firstWhere(
      (e) => e.id == moduleUpdate.id,
    );
    final index = project.modules?.indexOf(module!);
    module!.name = moduleUpdate.name;
    module.description = moduleUpdate.description;
    project.modules![index!]=module;
    await project.save();
  }
  
}
