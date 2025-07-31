import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/rule_provider/rule_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingRuleSubModuleProvider = StateProvider<bool>((ref) => false);
final isUpdatingRuleSubModuleProvider = StateProvider<bool>((ref) => false);

final ruleListSubModuleNotifierProvider =
    AutoDisposeStateNotifierProvider<RuleListSubModuleNotifier, List<Rule>>((ref) {
  final getUseCase = ref.watch(getRulesFromSubModelUseCaseProvider);
  final addUseCase = ref.watch(addRuleToSubModelUseCaseProvider);
  final updateUseCase = ref.watch(updateRuleFromSubModelUseCaseProvider);
  final deleteUseCase = ref.watch(deleteRuleFromSubModelUseCaseProvider);
  return RuleListSubModuleNotifier(addUseCase, updateUseCase, deleteUseCase, getUseCase);
});

class RuleListSubModuleNotifier extends StateNotifier<List<Rule>> {
  final GetRulesFromSubModule _getRules;
  final AddRuleToSubModule _addRule;
  final UpdateRuleFromSubModule _updateRule;
  final DeleteRuleFromSubModule _deleteRule;

  RuleListSubModuleNotifier(
    this._addRule,
    this._updateRule,
    this._deleteRule,
    this._getRules,
  ) : super([]);

  Future<void> loadRules(ModuleModel module, SubModuleModel subModule, int projectId) async {
    final rulesList = await _getRules(projectId, module.id, subModule.id);
    subModule.rules = rulesList.map(RuleModel.fromEntity).toList();
    state = rulesList;
  }

  Future<void> addRule(ModuleModel module, SubModuleModel subModule, int projectId, Rule rule) async {
    await _addRule(projectId, module.id, subModule.id, rule);
    subModule.rules ??= [];
    subModule.rules!.add(RuleModel.fromEntity(rule));
    state = subModule.rules!.map((a) => a.toEntity()).toList();
  }

  Future<void> updateRule(ModuleModel module, SubModuleModel subModule, int projectId, Rule rule) async {
    await _updateRule(projectId, module.id, subModule.id, rule);
    final model = RuleModel.fromEntity(rule);
    final index = subModule.rules?.indexWhere((e) => e.id == model.id);
    if (index != null && index != -1) {
      subModule.rules![index] = model;
      state = subModule.rules!.map((a) => a.toEntity()).toList();
    }
  }

  Future<void> removeFromState(SubModuleModel subModule, Rule rule) async {
    subModule.rules?.removeWhere((e) => e.id == rule.id);
    state = subModule.rules!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteRule(ModuleModel module, SubModuleModel subModule, int projectId, Rule rule) async {
    await _deleteRule(projectId, module.id, subModule.id, rule.id);
  }
}
