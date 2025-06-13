// domain/usecases/add_module.dart

import 'package:check_list_qa/domain/entities/modul.dart';

import '../repositories/project_repository.dart';

class AddModuleToProject {
  final ProjectRepository repo;
  AddModuleToProject(this.repo);

  Future<void> call(int projectId, Module module) {
    return repo.insertModule(module, projectId);
  }
}
