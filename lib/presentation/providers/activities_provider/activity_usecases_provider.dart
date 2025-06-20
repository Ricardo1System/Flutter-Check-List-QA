// presentation/providers/module_usecases_providers.dart

import 'package:check_list_qa/domain/usecases/delete_activity.dart';
import 'package:check_list_qa/domain/usecases/update_activity.dart';
import 'package:check_list_qa/presentation/providers/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/usecases/add_activity.dart';

final projectBoxProvider = Provider<Box<ProjectModel>>((ref) {
  return Hive.box<ProjectModel>('projects');
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

final addActivityUseCaseProvider = Provider<AddActivityToModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddActivityToModule(repo);
});

final updateActivityUseCaseProvider = Provider<UpdateActivityFromModule>((ref){
  final repo = ref.watch(projectRepositoryProvider);
  return UpdateActivityFromModule(repo);
});

final deleteActivityUseCaseProvider = Provider<DeleteActivityFromModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return DeleteActivityFromModule(repo);
});
