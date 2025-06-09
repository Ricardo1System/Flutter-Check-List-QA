import 'package:check_list_qa/data/datasources/project_local_datasource.dart';
import 'package:check_list_qa/data/models/project_model.dart';

import '../../../domain/entities/project.dart';
import '../../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource local;

  ProjectRepositoryImpl(this.local);

  @override
  Future<void> insert(Project project) async {
    final model = ProjectModel.fromEntity(project);
    await local.insert(model);
  }

  @override
  Future<List<Project>> getAll() async {
    final models = await local.getAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> delete(int id) async {
    await local.delete(id);
  }
}
