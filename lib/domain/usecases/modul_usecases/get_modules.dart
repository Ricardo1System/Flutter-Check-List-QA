import 'package:check_list_qa/domain/entities/module.dart';

import '../../repositories/project_repository.dart';

class GetModulesFromProject {
  final ProjectRepository repo;
  GetModulesFromProject(this.repo);

  Future<List<Module>> call(int projectId) {
    return repo.getAllModule(projectId);
  }
}