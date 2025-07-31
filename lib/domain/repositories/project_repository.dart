import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/module.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';

import '../entities/project.dart';

abstract class ProjectRepository {
  Future<void> insertProject(Project project);
  Future<List<Project>> getAllProjects();
  Future<Project> getProjectForId(int projectId);
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


  Future<void> insertRule(
    Rule rule,
    int projectId,
    int moduleId,
  );

  Future<void> insertRuleToSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    Rule rule,
  );


  Future<void> updateRule(
    int projectId,
    int moduleId,
    Rule rule,
  );

  Future<void> updateRuleFromSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    Rule rule,
  );

  Future<void> updateModule(
    int projectId,
    Module module,
  );


  Future<List<SubModule>> getAllSubModule(
    int projectId,
    int moduleId,
  );

  Future<void> insertSubModule(
    SubModule subModule,
    int projectId,
    int moduleId,
  );

  Future<void> updateSubModule(
    int projectId,
    int moduleId,
    SubModule subModule,
  );

  Future<void> deleteSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
  );

  // Future<void> reorderActivities(
  //   int projectId,
  //   int moduleId,
  //   int oldIndex,
  //   int newIndex,
  // );

  Future<List<Activity>> getAllActivity(
    int projectId,
    int moduleId,
  );

  Future<List<Activity>> getAllActivityForSubModule(
    int projectId,
    int moduleId,
    int subModuleId
  );

  Future<void> insertActivity(
    int projectId,
    int moduleId,
    Activity activity,
  );

  Future<void> insertActivityFromSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    Activity activity,
  );

  Future<void> updateActivity(
    int projectId,
    int moduleId,
    Activity activity,
  );

  Future<void> updateActivityFromSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    Activity activity,
  );

  Future<void> deleteActivity(
    int projectId,
    int moduleId,
    int activityId,
  );

  Future<void> deleteActivityFromSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    int activityId,
  );

  Future<void> reorderActivities(
    int projectId,
    int moduleId,
    int oldIndex,
    int newIndex,
  );

  Future<List<Rule>> getAllRule(
    int projectId,
    int moduleId,
  );

  Future<void> deleteRule(
    int projectId,
    int moduleId,
    int ruleId,
  );

  Future<List<Rule>> getAllRuleFromSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
  );

  Future<void> deleteRuleFromSubModule(
    int projectId,
    int moduleId,
    int subModuleId,
    int ruleId,
  );
}
