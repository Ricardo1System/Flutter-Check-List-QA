// domain/usecases/add_activity.dart

import 'package:check_list_qa/domain/entities/submodule.dart';

import '../../repositories/project_repository.dart';

class AddSubModuleToModule {
  final ProjectRepository repo;
  AddSubModuleToModule(this.repo);

  Future<void> call(int projectId, int module, SubModule subModule) {
    return repo.insertSubModule(subModule, projectId, module,);
  }
}
