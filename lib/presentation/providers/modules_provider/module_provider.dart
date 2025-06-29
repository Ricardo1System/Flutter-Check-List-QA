import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/modul.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/modules_provider/module_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingModuleProvider = StateProvider<bool>((ref) => false);
final isUpdatingModuleProvider = StateProvider<bool>((ref) => false,);

final moduleListProvider = StateNotifierProvider.family<ModuleListNotifier, List<Module>, ProjectModel>((ref, project) {
  final getModuleUseCase = ref.watch(getModuleUseCaseProvider);
  final addModuleUseCase = ref.watch(addModuleUseCaseProvider);
  final updateModuleUseCase = ref.watch(updateModuleUseCaseProvider);
  final deleteModuleUseCase = ref.watch(deleteModuleUseCaseProvider);
  return ModuleListNotifier(project, addModuleUseCase, updateModuleUseCase, deleteModuleUseCase, getModuleUseCase);
});
class ModuleListNotifier extends StateNotifier<List<Module>> {
  final ProjectModel _project;
  final GetModulesFromProject _getModules;
  final AddModuleToProject _addModule;
  final UpdateModuleFromProject _updateModule;
  final DeleteModuleFromProject _deleteModule;
  bool isAdding = false;
  bool isUpdating = false;

  ModuleListNotifier(this._project, this._addModule, this._updateModule, this._deleteModule, this._getModules)
      : super(_project.modules?.map((m) => m.toEntity()).toList() ?? []);

  Future<void> loadModules() async {
    final projectId = _project.id;
    var modulelist = await _getModules(projectId);
    state = modulelist;
  }

  Future<void> addModule(Module module) async {
    isAdding = true; 
    final projectId = _project.id;
    await _addModule(projectId, module);
    _project.modules ??= [];
    _project.modules!.add(ModuleModel.fromEntity(module));
    state = _project.modules!.map((m) => m.toEntity()).toList();
    isAdding = false;
  }

  Future<void> updatingModule(Module module) async {
    await _updateModule(_project.id, module);
    var index = _project.modules?.indexWhere((e) => e.id == (module.id));
    _project.modules ?.removeWhere((e) => e.id == (module.id));
    _project.modules?.insert(index!, ModuleModel.fromEntity(module));
    state = _project.modules!.map((a) => a.toEntity()).toList();
  }

  Future<void> removeFromState(Module model) async {
    _project.modules?.removeWhere((e) => e.id == (ModuleModel.fromEntity(model).id));
    state = _project.modules!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteModule(int projectId, Module model) async {
    await _deleteModule(projectId, model.id);
  }
}