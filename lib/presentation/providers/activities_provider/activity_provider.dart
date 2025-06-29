import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';

import 'package:check_list_qa/presentation/providers/activities_provider/activity_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingActivityProvider = StateProvider<bool>((ref) => false);
final isUpdatingActivityProvider = StateProvider<bool>((ref) => false);

final activityListProvider = StateNotifierProvider.family<ActivityListNotifier, List<Activity>, ModuleModel>((ref, module) {
  final getUseCase = ref.watch(getActivitiesUseCaseProvider);
  final addUseCase = ref.watch(addActivityUseCaseProvider);
  final updateUseCase = ref.watch(updateActivityUseCaseProvider);
  final deleteUseCase = ref.watch(deleteActivityUseCaseProvider);
  return ActivityListNotifier(module, addUseCase, updateUseCase, deleteUseCase, getUseCase);
});


class ActivityListNotifier extends StateNotifier<List<Activity>> {
  final ModuleModel _module;
  final GetActivitiesFromModule _getActivities;
  final AddActivityToModule _addActivity;
  final UpdateActivityFromModule _updateActivity;
  final DeleteActivityFromModule _deleteActivity;
  bool isAdding = false;
  bool isUpdating = false;

  ActivityListNotifier(this._module, this._addActivity, this._updateActivity, this._deleteActivity, this._getActivities)
      : super(_module.activities?.map((a) => a.toEntity()).toList() ?? []);

    Future<void> loadActivities(int projectId) async {
    final moduleId = _module.id;
    var activitylist = await _getActivities(projectId, moduleId);
    state = activitylist;
  }

  Future<void> addActivity(int projectId, int moduleId, Activity activity) async {
    await _addActivity(projectId, moduleId, activity);
    _module.activities ??= [];
    _module.activities!.add(ActivityModel.fromEntity(activity));
    state = _module.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> updateActivity(int projectId, int moduleId, Activity activity) async {
    await _updateActivity(projectId, moduleId, activity);
    var index =_module.activities?.indexWhere((e) => e.id == (ActivityModel.fromEntity(activity).id));
    _module.activities?.removeWhere((e) => e.id == (ActivityModel.fromEntity(activity).id));
    _module.activities?.insert(index!, ActivityModel.fromEntity(activity));
    state = _module.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> removeFromState(Activity activity) async {
    _module.activities?.removeWhere((e) => e.id == (ActivityModel.fromEntity(activity).id));
    state = _module.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteActivity(int projectId, int moduleId, Activity activity) async {
    await _deleteActivity(projectId, moduleId, activity.id);
  }

}