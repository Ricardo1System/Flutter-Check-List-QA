import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/modul.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/project.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  List<ModuleModel> modules;

  ProjectModel({required this.name, required this.description, required this.modules});

  Project toEntity() => Project(id: key ?? 0, name: name, description: description, modules: modules.map((m) => m.toEntity()).toList());

  static ProjectModel fromEntity(Project entity) =>
      ProjectModel(name: entity.name, description: entity.description, modules: entity.modules.map((m) => ModuleModel.fromEntity(m)).toList() );
}

@HiveType(typeId: 1)
class ModuleModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(3)
  List<ActivityModel> activities;

  ModuleModel({required this.name, required this.description, required this.activities});

  Module toEntity() => Module(id: key ?? 0, name: name, description: description, activities: activities.map((m) => m.toEntity()).toList());

  static ModuleModel fromEntity(Module entity) => ModuleModel(
        name: entity.name,
        description: entity.description,
        activities: entity.activities.map((m) => ActivityModel.fromEntity(m)).toList(),
      );

}

@HiveType(typeId: 2)
class ActivityModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String detail;
  @HiveField(2)
  bool check;

  ActivityModel({
    required this.name,
    required this.detail,
    required this.check,
  });

  Activity toEntity() => Activity(id: key ?? 0, name: name, check: check, detail: detail);

    static ActivityModel fromEntity(Activity entity) => ActivityModel(
        name: entity.name,
        check: entity.check,
        detail: entity.detail,
      );

}
