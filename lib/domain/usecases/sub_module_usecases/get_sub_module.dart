

import 'package:check_list_qa/domain/entities/submodule.dart';

import '../../repositories/project_repository.dart';

class GetSubModulesFromModule {
  final ProjectRepository repo;
  GetSubModulesFromModule(this.repo);

  Future<List<SubModule>> call(int projectId, int moduleId) {
    return repo.getAllSubModule(projectId, moduleId);
  }
}