import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/rule_provider/rule_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingRuleProvider = StateProvider<bool>((ref) => false);
final isUpdatingRuleProvider = StateProvider<bool>((ref) => false);

final ruleListNotifierProvider =
    AutoDisposeStateNotifierProvider<RuleListNotifier, List<Rule>>((ref) {
  final getUseCase = ref.watch(getRulesUseCaseProvider);
  final addUseCase = ref.watch(addRuleUseCaseProvider);
  final updateUseCase = ref.watch(updateRuleUseCaseProvider);
  final deleteUseCase = ref.watch(deleteRuleUseCaseProvider);
  return RuleListNotifier(addUseCase, updateUseCase, deleteUseCase, getUseCase);
});

class RuleListNotifier extends StateNotifier<List<Rule>> {
  final GetRulesFromModule _getRules;
  final AddRuleToModule _addRule;
  final UpdateRuleFromModule _updateRule;
  final DeleteRuleFromModule _deleteRule;

  RuleListNotifier(
    this._addRule,
    this._updateRule,
    this._deleteRule,
    this._getRules,
  ) : super([]);

  Future<void> loadRules(ModuleModel module, int projectId) async {
    final rulesList = await _getRules(projectId, module.id);
    module.rules = rulesList.map(RuleModel.fromEntity).toList();
    state = rulesList;
  }

  Future<void> addRule(ModuleModel module, int projectId, Rule rule) async {
    await _addRule(projectId, module.id, rule);
    module.rules ??= [];
    module.rules!.add(RuleModel.fromEntity(rule));
    state = module.rules!.map((a) => a.toEntity()).toList();
  }

  Future<void> updateRule(ModuleModel module, int projectId, Rule rule) async {
    await _updateRule(projectId, module.id, rule);
    final model = RuleModel.fromEntity(rule);
    final index = module.rules?.indexWhere((e) => e.id == model.id);
    if (index != null && index != -1) {
      module.rules![index] = model;
      state = module.rules!.map((a) => a.toEntity()).toList();
    }
  }

  Future<void> removeFromState(ModuleModel module, Rule rule) async {
    module.rules?.removeWhere((e) => e.id == rule.id);
    state = module.rules!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteRule(ModuleModel module, int projectId, Rule rule) async {
    await _deleteRule(projectId, module.id, rule.id);
  }
}
