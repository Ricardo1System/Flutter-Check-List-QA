// domain/usecases/add_activity.dart

import 'package:check_list_qa/domain/entities/rule.dart';

import '../../repositories/project_repository.dart';

class AddRuleToModule {
  final ProjectRepository repo;
  AddRuleToModule(this.repo);

  Future<void> call(int projectId, int module, Rule rule) {
    return repo.insertRule(rule, projectId, module,);
  }
}

class AddRuleToSubModule {
  final ProjectRepository repo;
  AddRuleToSubModule(this.repo);

  Future<void> call(int projectId, int module, int subModule, Rule rule) {
    return repo.insertRuleToSubModule(projectId, module, subModule, rule);
  }
}
