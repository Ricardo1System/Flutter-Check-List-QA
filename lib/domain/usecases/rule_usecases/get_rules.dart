

import 'package:check_list_qa/domain/entities/rule.dart';

import '../../repositories/project_repository.dart';

class GetRulesFromModule {
  final ProjectRepository repo;
  GetRulesFromModule(this.repo);

  Future<List<Rule>> call(int projectId, int moduleId) {
    return repo.getAllRule(projectId, moduleId);
  }
}

class GetRulesFromSubModule {
  final ProjectRepository repo;
  GetRulesFromSubModule(this.repo);

  Future<List<Rule>> call(int projectId, int moduleId, int subModuleId) {
    return repo.getAllRuleFromSubModule(projectId, moduleId, subModuleId);
  }
}