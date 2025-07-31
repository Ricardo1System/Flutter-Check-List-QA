// presentation/providers/module_usecases_providers.dart

import 'package:check_list_qa/domain/usecases/rule_usecases/delete_rule.dart';
import 'package:check_list_qa/domain/usecases/rule_usecases/get_rules.dart';
import 'package:check_list_qa/domain/usecases/rule_usecases/update_rule.dart';
import 'package:check_list_qa/presentation/providers/projects_provider/project_usecases_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/project_repository_impl.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/usecases/rule_usecases/add_rule.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(local);
});

//Module
final getRulesUseCaseProvider = Provider<GetRulesFromModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetRulesFromModule(repo);
});

final addRuleUseCaseProvider = Provider<AddRuleToModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddRuleToModule(repo);
});

final updateRuleUseCaseProvider = Provider<UpdateRuleFromModule>((ref){
  final repo = ref.watch(projectRepositoryProvider);
  return UpdateRuleFromModule(repo);
});

final deleteRuleUseCaseProvider = Provider<DeleteRuleFromModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return DeleteRuleFromModule(repo);
});

//Submodule
final getRulesFromSubModelUseCaseProvider = Provider<GetRulesFromSubModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetRulesFromSubModule(repo);
});

final addRuleToSubModelUseCaseProvider = Provider<AddRuleToSubModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddRuleToSubModule(repo);
});

final updateRuleFromSubModelUseCaseProvider = Provider<UpdateRuleFromSubModule>((ref){
  final repo = ref.watch(projectRepositoryProvider);
  return UpdateRuleFromSubModule(repo);
});

final deleteRuleFromSubModelUseCaseProvider = Provider<DeleteRuleFromSubModule>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return DeleteRuleFromSubModule(repo);
});
