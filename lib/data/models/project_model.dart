import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/modul.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/project.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<ModuleModel>? modules;

  ProjectModel({required this.name, required this.description, required this.modules, required this.id});

  Project toEntity() => Project(id: id, name: name, description: description, modules: modules?.map((m) => m.toEntity()).toList() ?? []);

  static ProjectModel fromEntity(Project entity) =>
      ProjectModel( id: entity.id, name: entity.name, description: entity.description, modules: entity.modules?.map((m) => ModuleModel.fromEntity(m)).toList() ?? [] );
}

@HiveType(typeId: 1)
class ModuleModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<RuleModel> rules;

  @HiveField(4)
  List<ActivityModel>? activities;

  ModuleModel({required this.id, required this.name, required this.description, required this.rules, required this.activities});

  Module toEntity() => Module( id: id, name: name, description: description, activities: activities?.map((m) => m.toEntity()).toList() ?? []);

  static ModuleModel fromEntity(Module entity) => ModuleModel(
        id:  entity.id,
        name: entity.name,
        description: entity.description,
        rules: entity.rules?.map((m) => RuleModel.fromEntity(m)).toList() ?? [],
        activities: entity.activities?.map((m) => ActivityModel.fromEntity(m)).toList() ?? [],
      );

}

@HiveType(typeId: 2)
class RuleModel extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String detail;

  RuleModel({
    required this.id,
    required this.name,
    required this.detail,
  });

  Rule toEntity() => Rule( id: id, name: name, detail: detail);

    static RuleModel fromEntity(Rule entity) => RuleModel(
        id: entity.id,
        name: entity.name,
        detail: entity.detail,
      );

}

@HiveType(typeId: 3)
class ActivityModel extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String detail;

  ActivityModel({
    required this.id,
    required this.name,
    required this.detail,
    // required this.check,
  });

  Activity toEntity() => Activity( id: id, name: name, detail: detail);

    static ActivityModel fromEntity(Activity entity) => ActivityModel(
        id: entity.id,
        name: entity.name,
        detail: entity.detail,
      );

}
