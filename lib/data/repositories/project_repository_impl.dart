import 'package:check_list_qa/data/datasources/project_local_datasource.dart';
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/module.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';

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
  Future<Project> getProjectForId(int projectId) async {
    final projects = await local.getAllProjects();
    projects.map((e) => e.toEntity()).toList();
    Project project = (projects.where((p) => p.id == projectId).first).toEntity();
    project.modules =  await getAllModule(projectId);

    for (var m in project.modules!) {
      m.activities = await getAllActivity(projectId, m.id);
      m.rules = await getAllRule(projectId, m.id);

      if (m.subModules != null) {
        for (var s in m.subModules!) {
          s.activities = await getAllActivityForSubModule(projectId, m.id, s.id);
          s.rules = await getAllRuleFromSubModule(projectId, m.id, s.id);
        }
      }
    }
  
    return project;
  }

  @override
  Future<void> deleteProject(int id) async {
    await local.deleteProject(id);
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
  Future<List<SubModule>> getAllSubModule(int projectId, int moduleId) async {
    final allProjects = await local.getAllProjects();
    var project = allProjects.firstWhere(
      (e) => e.id == projectId,
    );
    var module = project.modules!.firstWhere(
      (e) => e.id == moduleId,
    );
    return module.subModules
            ?.map(
              (e) => e.toEntity(),
            )
            .toList() ??
        [];
  }

  @override
  Future<void> insertSubModule(
      SubModule subModule, int projectId, int moduleId) async {
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
    var subModules = module!.subModules ??= [];
    subModules.add(SubModuleModel.fromEntity(subModule));
    project.modules![index!].subModules = subModules;
    await project.save();
  }

  @override
  Future<void> updateSubModule(
      int projectId, int moduleId, SubModule subModuleUpdate) async {
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
    var subModules = module!.subModules ??= [];
    var oldActivity = subModules.firstWhere(
      (e) => e.id == subModuleUpdate.id,
    );
    final indexOldActivity = subModules.indexOf(oldActivity);
    subModules.remove(oldActivity);
    subModules.insert(
        indexOldActivity, SubModuleModel.fromEntity(subModuleUpdate));
    project.modules![index!].subModules = subModules;
    await project.save();
  }

  @override
  Future<void> deleteSubModule(
      int projectId, int moduleId, int subModuleId) async {
    final projectList = await local.getAllProjects();
    final project = projectList.firstWhere(
      (e) => e.id == projectId,
      orElse: () =>
          throw Exception("No se encontró el proyecto con de la actividad"),
    );
    final moduleList = project.modules ??= [];
    final module = moduleList.firstWhere(
      (e) => e.id == moduleId,
      orElse: () => throw Exception("No se encontró el módulo de la actividad"),
    );
    final moduleIndex = moduleList.indexWhere(
      (e) => e.id == moduleId,
    );
    final subModules = module.subModules ??= [];
    subModules.removeWhere(
      (e) => e.id == subModuleId,
    );
    project.modules![moduleIndex].subModules = subModules;
    await project.save();
  }

  @override
  Future<List<Activity>> getAllActivity(int projectId, int moduleId) async {
    final allProjects = await local.getAllProjects();
    ProjectModel project = allProjects.firstWhere(
      (e) => e.id == projectId,
    );
    ModuleModel module = project.modules!.firstWhere(
      (e) => e.id == moduleId,
    );
    var list = module.activities
            ?.where((a) => a.subModuleId == null)
            .map(
              (e) => e.toEntity(),
            )
            .toList() ??
        [];
    return list;
  }

  @override
  Future<void> insertActivity(
      int projectId, int moduleId, Activity activity) async {
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
  Future<void> updateActivity(
      int projectId, int moduleId, Activity activityUpdate) async {
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
    var oldActivity = activities.firstWhere(
      (e) => e.id == activityUpdate.id,
    );
    final indexOldActivity = activities.indexOf(oldActivity);
    activities.remove(oldActivity);
    activities.insert(
        indexOldActivity, ActivityModel.fromEntity(activityUpdate));
    project.modules![index!].activities = activities;
    await project.save();
  }

  @override
  Future<void> deleteActivity(
      int projectId, int moduleId, int activityId) async {
    final projectList = await local.getAllProjects();
    final project = projectList.firstWhere(
      (e) => e.id == projectId,
      orElse: () =>
          throw Exception("No se encontró el proyecto con de la actividad"),
    );
    final moduleList = project.modules ??= [];
    final module = moduleList.firstWhere(
      (e) => e.id == moduleId,
      orElse: () => throw Exception("No se encontró el módulo de la actividad"),
    );
    final moduleIndex = moduleList.indexWhere(
      (e) => e.id == moduleId,
    );
    final activityList = module.activities ??= [];
    activityList.removeWhere(
      (e) => e.id == activityId,
    );
    project.modules![moduleIndex].activities = activityList;
    await project.save();
  }

  @override
  Future<List<Rule>> getAllRule(int projectId, int moduleId) async {
    final allProjects = await local.getAllProjects();
    var project = allProjects.firstWhere(
      (e) => e.id == projectId,
    );
    var module = project.modules!.firstWhere(
      (e) => e.id == moduleId,
    );
    return module.rules
            ?.where((e) => e.subModuleId == null,)
            .map(
              (e) => e.toEntity(),
            )
            .toList() ??
        [];
  }

  @override
  Future<void> insertRule(Rule rule, int projectId, int moduleId) async {
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
    var rules = module!.rules ??= [];
    rules.add(RuleModel.fromEntity(rule));
    project.modules![index!].rules = rules;
    await project.save();
  }

  @override
  Future<void> updateRule(int projectId, int moduleId, Rule ruleUpdate) async {
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
    var rules = module!.rules ??= [];
    var oldActivity = rules.firstWhere(
      (e) => e.id == ruleUpdate.id,
    );
    final indexOldActivity = rules.indexOf(oldActivity);
    rules.remove(oldActivity);
    rules.insert(indexOldActivity, RuleModel.fromEntity(ruleUpdate));
    project.modules![index!].rules = rules;
    await project.save();
  }

  @override
  Future<void> deleteRule(int projectId, int moduleId, int ruleId) async {
    final projectList = await local.getAllProjects();
    final project = projectList.firstWhere(
      (e) => e.id == projectId,
      orElse: () =>
          throw Exception("No se encontró el proyecto con de la actividad"),
    );
    final moduleList = project.modules ??= [];
    final module = moduleList.firstWhere(
      (e) => e.id == moduleId,
      orElse: () => throw Exception("No se encontró el módulo de la actividad"),
    );
    final moduleIndex = moduleList.indexWhere(
      (e) => e.id == moduleId,
    );
    final ruleList = module.rules ??= [];
    ruleList.removeWhere(
      (e) => e.id == ruleId,
    );
    project.modules![moduleIndex].rules = ruleList;
    await project.save();
  }

  @override
  Future<List<Rule>> getAllRuleFromSubModule(
      int projectId, int moduleId, int subModuleId) async {
    final allProjects = await local.getAllProjects();
    var project = allProjects.firstWhere(
      (e) => e.id == projectId,
    );
    var module = project.modules!.firstWhere(
      (e) => e.id == moduleId,
    );
    var subModule = module.subModules!.firstWhere(
      (e) => e.id == subModuleId,
    );
    return subModule.rules
            ?.where((e) => e.subModuleId == subModuleId,)
            .map(
              (e) => e.toEntity(),
            )
            .toList() ??
        [];
  }

  @override
  Future<void> insertRuleToSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    Rule rule,
  ) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    final module = project.modules?.firstWhere(
      (e) => e.id == moduleId,
    );
    final moduleIndex = project.modules?.indexOf(module!);

    final subModule = module!.subModules!.firstWhere(
      (e) => e.id == subModuleId,
    );
    final subModuleIndex = module.subModules!.indexOf(subModule);

    var rules = module.rules ??= [];
    rule.subModuleId = subModuleId;
    rules.add(RuleModel.fromEntity(rule));
    project.modules![moduleIndex!].subModules![subModuleIndex].rules = rules;
    await project.save();
  }

  @override
  Future<void> updateRuleFromSubModule(
      int projectId, int moduleId, int subModuleId, Rule ruleUpdate) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    final module = project.modules?.firstWhere(
      (e) => e.id == moduleId,
    );
    final moduleIndex = project.modules?.indexOf(module!);

    final subModule = module!.subModules!.firstWhere(
      (e) => e.id == subModuleId,
    );
    final subModuleIndex = module.subModules!.indexOf(subModule);

    var rules = subModule.rules ??= [];
    var oldActivity = rules.firstWhere(
      (e) => e.id == ruleUpdate.id,
    );
    final indexOldActivity = rules.indexOf(oldActivity);
    rules.remove(oldActivity);
    rules.insert(indexOldActivity, RuleModel.fromEntity(ruleUpdate));
    project.modules![moduleIndex!].subModules![subModuleIndex].rules = rules;
    await project.save();
  }

  @override
  Future<void> deleteRuleFromSubModule(
      int projectId, int moduleId, int subModuleId, int ruleId) async {
    final projectList = await local.getAllProjects();
    final project = projectList.firstWhere(
      (e) => e.id == projectId,
      orElse: () =>
          throw Exception("No se encontró el proyecto con de la actividad"),
    );

    final moduleList = project.modules ??= [];
    final module = moduleList.firstWhere(
      (e) => e.id == moduleId,
      orElse: () => throw Exception("No se encontró el módulo de la actividad"),
    );
    final moduleIndex = moduleList.indexWhere(
      (e) => e.id == moduleId,
    );

    final subModuleList = module.subModules ??= [];
    final subModule = subModuleList.firstWhere(
      (e) => e.id == subModuleId,
      orElse: () => throw Exception("No se encontró el módulo de la actividad"),
    );
    final subModuleIndex = subModuleList.indexWhere(
      (e) => e.id == subModuleId,
    );

    final ruleList = subModule.rules ??= [];
    ruleList.removeWhere(
      (e) => e.id == ruleId,
    );
    project.modules![moduleIndex].subModules![subModuleIndex].rules = ruleList;
    await project.save();
  }

  @override
  Future<List<Module>> getAllModule(int projectId) async {
    final allProjects = await local.getAllProjects();
    var moduleModellist = allProjects
        .firstWhere(
          (e) => e.id == projectId,
        )
        .modules;
    moduleModellist ??= [];
    return moduleModellist.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> insertModule(Module module, int projectId) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    project.modules!
        .add(ModuleModel.fromEntity(module)); // si estás usando .toModel()
    await project.save();
  }

  @override
  Future<void> reorderActivities(
      int projectId, int moduleId, int oldIndex, int newIndex) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
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
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    if (newIndex > oldIndex)
      newIndex--; // necesario por cómo funciona ReorderableListView

    final modules = project.modules;
    final moved = modules!.removeAt(oldIndex);
    modules.insert(newIndex, moved);

    await project.save(); // HiveObject.save()
  }

  @override
  Future<void> updateModule(int projectId, Module moduleUpdate) async {
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
    project.modules![index!] = module;
    await project.save();
  }

  @override
  Future<List<Activity>> getAllActivityForSubModule(
      int projectId, int moduleId, int subModuleId) async {
    final allProjects = await local.getAllProjects();
    var project = allProjects.firstWhere(
      (e) => e.id == projectId,
    );
    var module = project.modules!.firstWhere(
      (e) => e.id == moduleId,
    );
    var subModule = module.subModules!.firstWhere(
      (e) => e.id == subModuleId,
    );
    return subModule.activities
            ?.where((e) => e.subModuleId == subModuleId,)
            .map(
              (e) => e.toEntity(),
            )
            .toList() ??
        [];
  }

  @override
  Future<void> deleteActivityFromSubModule(
      int projectId, int moduleId, int subModuleId, int activityId) async {
    final projectList = await local.getAllProjects();
    final project = projectList.firstWhere(
      (e) => e.id == projectId,
      orElse: () =>
          throw Exception("No se encontró el proyecto con de la actividad"),
    );

    final moduleList = project.modules ??= [];
    final module = moduleList.firstWhere(
      (e) => e.id == moduleId,
      orElse: () => throw Exception("No se encontró el módulo de la actividad"),
    );
    final moduleIndex = moduleList.indexWhere(
      (e) => e.id == moduleId,
    );

    final subModuleList = module.subModules ??= [];
    final subModule = subModuleList.firstWhere(
      (e) => e.id == subModuleId,
      orElse: () =>
          throw Exception("No se encontró el sub-módulo de la actividad"),
    );
    final subModuleIndex = subModuleList.indexWhere(
      (e) => e.id == subModuleId,
    );

    final activityList = subModule.activities ??= [];
    activityList.removeWhere(
      (e) => e.id == activityId,
    );

    project.modules![moduleIndex].subModules![subModuleIndex].activities =
        activityList;
    await project.save();
  }

  @override
  Future<void> insertActivityFromSubModule(
      int projectId, int moduleId, int subModuleId, Activity activity) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    final module = project.modules?.firstWhere(
      (e) => e.id == moduleId,
    );
    final moduleIndex = project.modules?.indexOf(module!);

    final subModule = project.modules![moduleIndex!].subModules!.firstWhere(
      (e) => e.id == subModuleId,
    );
    final subModuleIndex =
        project.modules![moduleIndex].subModules!.indexOf(subModule);

    var activities = module!.activities ??= [];
    activity.subModuleId = subModuleId;
    activities.add(ActivityModel.fromEntity(activity));
    project.modules![moduleIndex].subModules![subModuleIndex].activities =
        activities;
    await project.save();
  }

  @override
  Future<void> updateActivityFromSubModule(
      int projectId, int moduleId, int subModuleId, Activity activity) async {
    final allProjects = await local.getAllProjects();
    final project = allProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () =>
          throw Exception('Proyecto no encontrado con id: $projectId'),
    );

    final module = project.modules?.firstWhere(
      (e) => e.id == moduleId,
    );
    final moduleIndex = project.modules?.indexOf(module!);

    final subModule = project.modules![moduleIndex!].subModules?.firstWhere(
      (e) => e.id == subModuleId,
    );
    final subModuleIndex =
        project.modules![moduleIndex].subModules?.indexOf(subModule!);

    var activities = subModule!.activities ??= [];
    var oldActivity = activities.firstWhere(
      (e) => e.id == activity.id,
    );
    final indexOldActivity = activities.indexOf(oldActivity);
    activities.remove(oldActivity);
    activities.insert(indexOldActivity, ActivityModel.fromEntity(activity));
    project.modules![moduleIndex].subModules?[subModuleIndex!].activities =
        activities;
    await project.save();
  }
  
}
