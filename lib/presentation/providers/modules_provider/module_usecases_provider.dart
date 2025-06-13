// presentation/providers/module_usecases_providers.dart

import 'package:check_list_qa/presentation/providers/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/usecases/add_module.dart';
import '../../../domain/usecases/add_activity.dart';
import '../../../domain/repositories/project_repository.dart';
import 'package:hive/hive.dart';
import '../../../data/models/project_model.dart';

final projectBoxProvider = Provider<Box<ProjectModel>>((ref) {
  return Hive.box<ProjectModel>('projects');
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

final addModuleUseCaseProvider = Provider<AddModuleToProject>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddModuleToProject(repo);
});

final addActivityUseCaseProvider = Provider<AddActivityToModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddActivityToModule(repo);
});
