import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/modul.dart';
import 'package:check_list_qa/domain/usecases/add_module.dart';
import 'package:check_list_qa/presentation/providers/modules_provider/module_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final moduleListProvider = StateNotifierProvider.family<ModuleListNotifier, List<Module>, ProjectModel>((ref, project) {
  final addModuleUseCase = ref.watch(addModuleUseCaseProvider);
  return ModuleListNotifier(project, addModuleUseCase);
});


class ModuleListNotifier extends StateNotifier<List<Module>> {
  final ProjectModel _project;
  final AddModuleToProject _addModule;

  ModuleListNotifier(this._project, this._addModule)
      : super(_project.modules?.map((m) => m.toEntity()).toList() ?? []);

  Future<void> addModule(Module module) async {
    final projectId = _project.id;
    // if (projectId is! int) return;
    await _addModule(projectId, module);
    _project.modules ??= [];
    _project.modules!.add(ModuleModel.fromEntity(module));
    state = _project.modules!.map((m) => m.toEntity()).toList();
  }
}