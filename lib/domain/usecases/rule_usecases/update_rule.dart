

import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/repositories/project_repository.dart';

class UpdateRuleFromModule {
  final ProjectRepository repo;

  UpdateRuleFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, Rule rule) async {
    return repo.updateRule(projectId, moduleId, rule);
  }
}

class UpdateRuleFromSubModule {
  final ProjectRepository repo;

  UpdateRuleFromSubModule(this.repo);

  Future<void> call(int projectId, int moduleId, int subModuleId, Rule rule) async {
    return repo.updateRuleFromSubModule(projectId, moduleId, subModuleId, rule);
  }
}