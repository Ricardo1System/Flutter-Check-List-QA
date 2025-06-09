import 'package:hive/hive.dart';
import '../models/project_model.dart';
import 'project_local_datasource.dart';

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box<ProjectModel> _box = Hive.box<ProjectModel>('projects');

  @override
  Future<void> insert(ProjectModel project) async {
    await _box.add(project);
  }

  @override
  Future<List<ProjectModel>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);
  }
}
