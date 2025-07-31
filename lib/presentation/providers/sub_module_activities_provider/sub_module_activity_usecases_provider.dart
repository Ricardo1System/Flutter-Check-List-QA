// presentation/providers/module_usecases_providers.dart

import 'package:check_list_qa/domain/usecases/activity_usecases/delete_activity.dart';
import 'package:check_list_qa/domain/usecases/activity_usecases/get_activities.dart';
import 'package:check_list_qa/domain/usecases/activity_usecases/update_activity.dart';
import 'package:check_list_qa/presentation/providers/projects_provider/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/usecases/activity_usecases/add_activity.dart';

// final projectBoxProvider = Provider<Box<ProjectModel>>((ref) {
//   return Hive.box<ProjectModel>('projects');
// });

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

final getActivitiesUseCaseProvider = Provider<GetActivitiesFromModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetActivitiesFromModule(repo);
});

final getActivitiesForSubModuleUseCaseProvider = Provider<GetActivitiesFromSubModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetActivitiesFromSubModule(repo);
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
