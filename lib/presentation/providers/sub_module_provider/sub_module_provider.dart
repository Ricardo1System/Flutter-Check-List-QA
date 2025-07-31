import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/sub_module_provider/sub_module_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingSubModuleProvider = StateProvider<bool>((ref) => false);
final isUpdatingSubModuleProvider = StateProvider<bool>((ref) => false);

final subModuleListNotifierProvider =
    AutoDisposeStateNotifierProvider<SubModuleListNotifier, List<SubModule>>((ref) {
  final getUseCase = ref.watch(getSubModulesUseCaseProvider);
  final addUseCase = ref.watch(addSubModuleUseCaseProvider);
  final updateUseCase = ref.watch(updateSubModuleUseCaseProvider);
  final deleteUseCase = ref.watch(deleteSubModuleUseCaseProvider);
  return SubModuleListNotifier(addUseCase, updateUseCase, deleteUseCase, getUseCase);
});

class SubModuleListNotifier extends StateNotifier<List<SubModule>> {
  final GetSubModulesFromModule _getSubModules;
  final AddSubModuleToModule _addSubModule;
  final UpdateSubModuleFromModule _updateSubModule;
  final DeleteSubModuleFromModule _deleteSubModule;

  SubModuleListNotifier(
    this._addSubModule,
    this._updateSubModule,
    this._deleteSubModule,
    this._getSubModules,
  ) : super([]);

  Future<void> loadSubModules(ModuleModel module, int projectId) async {
    final moduleId = module.id;
    final list = await _getSubModules(projectId, moduleId);
    module.subModules = list.map(SubModuleModel.fromEntity).toList();
    state = list;
  }

  Future<void> addSubModule(ModuleModel module, int projectId, SubModule subModule) async {
    await _addSubModule(projectId, module.id, subModule);
    module.subModules ??= [];
    module.subModules!.add(SubModuleModel.fromEntity(subModule));
    state = module.subModules!.map((a) => a.toEntity()).toList();
  }

  Future<void> updateSubModule(ModuleModel module, int projectId, SubModule subModule) async {
    await _updateSubModule(projectId, module.id, subModule);
    final model = SubModuleModel.fromEntity(subModule);
    final index = module.subModules?.indexWhere((e) => e.id == model.id);
    if (index != null && index != -1) {
      module.subModules![index] = model;
      state = module.subModules!.map((a) => a.toEntity()).toList();
    }
  }

  Future<void> removeFromState(ModuleModel module, SubModule subModule) async {
    module.subModules?.removeWhere((e) => e.id == subModule.id);
    state = module.subModules!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteSubModule(ModuleModel module, int projectId, SubModule subModule) async {
    await _deleteSubModule(projectId, module.id, subModule.id);
  }
}
