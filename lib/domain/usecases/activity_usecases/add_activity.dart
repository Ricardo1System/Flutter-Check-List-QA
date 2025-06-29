// domain/usecases/add_activity.dart

import '../../entities/activity.dart';
import '../../repositories/project_repository.dart';

class AddActivityToModule {
  final ProjectRepository repo;
  AddActivityToModule(this.repo);

  Future<void> call(int projectId, int module, Activity activity) {
    return repo.insertActivity(activity, projectId, module,);
  }
}
