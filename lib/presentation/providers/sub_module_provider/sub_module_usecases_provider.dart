
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/projects_provider/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/repositories/project_repository.dart';
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

final getSubModulesUseCaseProvider = Provider<GetSubModulesFromModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetSubModulesFromModule(repo);
});

final addSubModuleUseCaseProvider = Provider<AddSubModuleToModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddSubModuleToModule(repo);
});

final updateSubModuleUseCaseProvider = Provider<UpdateSubModuleFromModule>((ref){
  final repo = ref.watch(projectRepositoryProvider);
  return UpdateSubModuleFromModule(repo);
});

final deleteSubModuleUseCaseProvider = Provider<DeleteSubModuleFromModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return DeleteSubModuleFromModule(repo);
});
