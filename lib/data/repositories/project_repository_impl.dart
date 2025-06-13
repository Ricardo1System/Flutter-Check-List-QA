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
    final project = (await local.getAllProjects())[projectId];
    final module = project.modules![moduleId];

    module.activities!.removeWhere((a) => a.id == activityId);
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
    return allProjects[projectId]
        .modules![moduleId]
        .activities!
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Future<List<Module>> getAllModule(int projectId) async {
    final allProjects = await local.getAllProjects();
    return allProjects[projectId].modules!.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> insertActivity(
      Activity activity, int projectId, int moduleId) async {
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
  
}
