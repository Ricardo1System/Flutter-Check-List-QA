import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/activities_provider/activity_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingActivitySubModuleProvider = StateProvider<bool>((ref) => false);
final isUpdatingActivitySubModuleProvider = StateProvider<bool>((ref) => false);

final activityListSubModuleNotifierProvider =
    AutoDisposeStateNotifierProvider<ActivityListSubModuleNotifier, List<Activity>>((ref) {
  final getUseCase = ref.watch(getActivitiesForSubModuleUseCaseProvider);
  final addUseCase = ref.watch(addActivityToSubModuleUseCaseProvider);
  final updateUseCase = ref.watch(updateActivityFromSubModuleUseCaseProvider);
  final deleteUseCase = ref.watch(deleteActivityFromSubModuleUseCaseProvider);
  return ActivityListSubModuleNotifier(addUseCase, updateUseCase, deleteUseCase, getUseCase);
});

class ActivityListSubModuleNotifier extends StateNotifier<List<Activity>> {
  final GetActivitiesFromSubModule _getActivities;
  final AddActivityToSubModule _addActivity;
  final UpdateActivityFromSubModule _updateActivity;
  final DeleteActivityFromSubModule _deleteActivity;

  ActivityListSubModuleNotifier(
    this._addActivity,
    this._updateActivity,
    this._deleteActivity,
    this._getActivities,
  ) : super([]);

  Future<void> loadActivities(ModuleModel module, SubModuleModel subModule, int projectId) async {
    final activityList = await _getActivities(projectId, module.id, subModule.id);
    subModule.activities = activityList.map(ActivityModel.fromEntity).toList();
    state = activityList;
  }

  Future<void> addActivity(ModuleModel module, SubModuleModel subModule, int projectId, Activity activity) async {
    await _addActivity(projectId, module.id, subModule.id, activity);
    subModule.activities ??= [];
    subModule.activities!.add(ActivityModel.fromEntity(activity));
    state = subModule.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> updateActivity(ModuleModel module, SubModuleModel subModule, int projectId, Activity activity) async {
    await _updateActivity(projectId, module.id, subModule.id, activity);
    final model = ActivityModel.fromEntity(activity);
    final index = subModule.activities?.indexWhere((e) => e.id == model.id);
    if (index != null && index != -1) {
      subModule.activities![index] = model;
      state = subModule.activities!.map((a) => a.toEntity()).toList();
    }
  }

  Future<void> removeFromState(SubModuleModel subModule, Activity activity) async {
    subModule.activities?.removeWhere((e) => e.id == activity.id);
    state = subModule.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteActivity(ModuleModel module, SubModuleModel subModule, int projectId, Activity activity) async {
    await _deleteActivity(projectId, module.id, subModule.id, activity.id);
  }
}
