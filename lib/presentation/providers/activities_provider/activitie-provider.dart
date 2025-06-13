


import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/usecases/add_activity.dart';
import 'package:check_list_qa/presentation/providers/modules_provider/module_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final activityListProvider = StateNotifierProvider.family<ActivityListNotifier, List<Activity>, ModuleModel>((ref, module) {
  final useCase = ref.watch(addActivityUseCaseProvider);
  return ActivityListNotifier(module, useCase);
});


class ActivityListNotifier extends StateNotifier<List<Activity>> {
  final ModuleModel _module;
  final AddActivityToModule _addActivity;

  ActivityListNotifier(this._module, this._addActivity)
      : super(_module.activities?.map((a) => a.toEntity()).toList() ?? []);

  Future<void> addActivity(int projectId, int moduleId, Activity activity) async {
    await _addActivity(projectId, moduleId, activity);
    _module.activities ??= [];
    _module.activities!.add(ActivityModel.fromEntity(activity));
    state = _module.activities!.map((a) => a.toEntity()).toList();
  }
}