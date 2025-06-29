

import 'package:check_list_qa/domain/entities/modul.dart';
import 'package:check_list_qa/domain/repositories/project_repository.dart';

class UpdateModuleFromProject {
  final ProjectRepository repo;

  UpdateModuleFromProject(this.repo);

  Future<void> call(int projectId, Module module) async {
    return repo.updateModule(projectId, module);
  }
}