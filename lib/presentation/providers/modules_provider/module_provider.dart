import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/module.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/modules_provider/module_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingModuleProvider = StateProvider<bool>((ref) => false);
final isUpdatingModuleProvider = StateProvider<bool>((ref) => false);

final moduleListNotifierProvider =
    AutoDisposeStateNotifierProvider<ModuleListNotifier, List<Module>>((ref) {
  final getModuleUseCase = ref.watch(getModuleUseCaseProvider);
  final addModuleUseCase = ref.watch(addModuleUseCaseProvider);
  final updateModuleUseCase = ref.watch(updateModuleUseCaseProvider);
  final deleteModuleUseCase = ref.watch(deleteModuleUseCaseProvider);
  return ModuleListNotifier(addModuleUseCase, updateModuleUseCase, deleteModuleUseCase, getModuleUseCase);
});

class ModuleListNotifier extends StateNotifier<List<Module>> {
  final GetModulesFromProject _getModules;
  final AddModuleToProject _addModule;
  final UpdateModuleFromProject _updateModule;
  final DeleteModuleFromProject _deleteModule;

  ModuleListNotifier(
    this._addModule,
    this._updateModule,
    this._deleteModule,
    this._getModules,
  ) : super([]);

  Future<void> loadModules(ProjectModel project) async {
    final moduleList = await _getModules(project.id);
    project.modules = moduleList.map(ModuleModel.fromEntity).toList();
    state = moduleList;
  }

  Future<void> addModule(ProjectModel project, Module module) async {
    await _addModule(project.id, module);
    project.modules ??= [];
    project.modules!.add(ModuleModel.fromEntity(module));
    state = project.modules!.map((m) => m.toEntity()).toList();
  }

  Future<void> updatingModule(ProjectModel project, Module module) async {
    await _updateModule(project.id, module);
    final model = ModuleModel.fromEntity(module);
    final index = project.modules?.indexWhere((e) => e.id == model.id);
    if (index != null && index != -1) {
      project.modules![index] = model;
      state = project.modules!.map((m) => m.toEntity()).toList();
    }
  }

  Future<void> removeFromState(ProjectModel project, Module model) async {
    project.modules?.removeWhere((e) => e.id == model.id);
    state = project.modules!.map((m) => m.toEntity()).toList();
  }

  Future<void> deleteModule(ProjectModel project, Module module) async {
    await _deleteModule(project.id, module.id);
  }
}
