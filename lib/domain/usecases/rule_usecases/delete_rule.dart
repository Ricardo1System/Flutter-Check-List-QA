// domain/usecases/add_Rule.dart

import '../../repositories/project_repository.dart';

class DeleteRuleFromModule {
  final ProjectRepository repo;
  DeleteRuleFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, int ruleId) {
    return repo.deleteRule(projectId, moduleId, ruleId);
  }
}

class DeleteRuleFromSubModule {
  final ProjectRepository repo;
  DeleteRuleFromSubModule(this.repo);

  Future<void> call(int projectId, int moduleId, int subModuleId, int ruleId) {
    return repo.deleteRuleFromSubModule(projectId, moduleId, subModuleId, ruleId);
  }
}
