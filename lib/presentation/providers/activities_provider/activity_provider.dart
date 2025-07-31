import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/usecases/usecases.dart';
import 'package:check_list_qa/presentation/providers/activities_provider/activity_usecases_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddingActivityProvider = StateProvider<bool>((ref) => false);
final isUpdatingActivityProvider = StateProvider<bool>((ref) => false);

final activityListNotifierProvider = AutoDisposeStateNotifierProvider<ActivityListNotifier, List<Activity>>((ref) {
  final getUseCase = ref.watch(getActivitiesUseCaseProvider);
  final addUseCase = ref.watch(addActivityUseCaseProvider);
  final updateUseCase = ref.watch(updateActivityUseCaseProvider);
  final deleteUseCase = ref.watch(deleteActivityUseCaseProvider);
  return ActivityListNotifier(addUseCase, updateUseCase, deleteUseCase, getUseCase);
});

class ActivityListNotifier extends StateNotifier<List<Activity>> {
  final GetActivitiesFromModule _getActivities;
  final AddActivityToModule _addActivity;
  final UpdateActivityFromModule _updateActivity;
  final DeleteActivityFromModule _deleteActivity;

  ActivityListNotifier(this._addActivity, this._updateActivity, this._deleteActivity, this._getActivities)
      : super([]);

  Future<void> loadActivities(ModuleModel module, int projectId) async {
    final moduleId = module.id;
    final activities = await _getActivities(projectId, moduleId);
    module.activities = activities.map(ActivityModel.fromEntity).toList();
    state = activities;
  }

  Future<void> addActivity(ModuleModel module, int projectId, Activity activity) async {
    await _addActivity(projectId, module.id, activity);
    module.activities ??= [];
    module.activities!.add(ActivityModel.fromEntity(activity));
    state = module.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> updateActivity(ModuleModel module, int projectId, Activity activity) async {
    await _updateActivity(projectId, module.id, activity);
    final model = ActivityModel.fromEntity(activity);
    final index = module.activities?.indexWhere((e) => e.id == model.id);
    if (index != null && index != -1) {
      module.activities![index] = model;
      state = module.activities!.map((a) => a.toEntity()).toList();
    }
  }

  Future<void> removeFromState(ModuleModel module, Activity activity) async {
    module.activities?.removeWhere((e) => e.id == activity.id);
    state = module.activities!.map((a) => a.toEntity()).toList();
  }

  Future<void> deleteActivity(int projectId, int moduleId, Activity activity) async {
    await _deleteActivity(projectId, moduleId, activity.id);
  }
}
