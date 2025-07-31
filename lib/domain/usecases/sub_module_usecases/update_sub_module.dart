
import 'package:check_list_qa/domain/entities/submodule.dart';
import 'package:check_list_qa/domain/repositories/project_repository.dart';

class UpdateSubModuleFromModule {
  final ProjectRepository repo;

  UpdateSubModuleFromModule(this.repo);

  Future<void> call(int projectId, int moduleId, SubModule subModule) async {
    return repo.updateSubModule(projectId, moduleId, subModule);
  }
}