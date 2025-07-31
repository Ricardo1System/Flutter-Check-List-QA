import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/project_local_datasource_impl.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/usecases/project_usecases/get_projects.dart';
import '../../../domain/usecases/project_usecases/insert_project.dart';

final projectLocalDataSourceProvider = Provider((ref) {
  return ProjectLocalDataSourceImpl();
});

final projectRepositoryProvider = Provider((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

final getProjectsProvider = Provider<GetProjects>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjects(repo);
});

final getProjectForIdProvider = Provider<GetProjectForId>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectForId(repo);
});

final insertProjectProvider = Provider<InsertProject>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return InsertProject(repo);
});
