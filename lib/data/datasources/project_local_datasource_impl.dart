import 'package:hive/hive.dart';

import '../models/project_model.dart';
import 'project_local_datasource.dart';

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box<ProjectModel> _box = Hive.box<ProjectModel>('projects');
  
  @override
  Future<void> deleteProject(int id) async {
    await _box.delete(id);
  }
  
  @override
  Future<List<ProjectModel>> getAllProjects() async {
    return _box.values.toList();
  }
  
  @override
  Future<void> insertProject(ProjectModel project) async {
    await _box.put(project.id, project);
  }
  

}
