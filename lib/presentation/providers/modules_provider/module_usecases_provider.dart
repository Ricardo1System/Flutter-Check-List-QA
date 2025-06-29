// presentation/providers/module_usecases_providers.dart

import 'package:check_list_qa/domain/usecases/modul_usecases/delete_module.dart';
import 'package:check_list_qa/domain/usecases/modul_usecases/get_modules.dart';
import 'package:check_list_qa/domain/usecases/modul_usecases/update_module.dart';
import 'package:check_list_qa/presentation/providers/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/usecases/modul_usecases/add_module.dart';

final projectBoxProvider = Provider<Box<ProjectModel>>((ref) {
  return Hive.box<ProjectModel>('projects');
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

final getModuleUseCaseProvider = Provider<GetModulesFromProject>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetModulesFromProject(repo);
});

final addModuleUseCaseProvider = Provider<AddModuleToProject>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddModuleToProject(repo);
});

final updateModuleUseCaseProvider = Provider<UpdateModuleFromProject>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return UpdateModuleFromProject(repo);
});

final deleteModuleUseCaseProvider = Provider<DeleteModuleFromProject>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return DeleteModuleFromProject(repo);
});

