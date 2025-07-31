import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/module.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';
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

  ProjectModel({
    required this.name,
    required this.description,
    required this.modules,
    required this.id,
  });

  Project toEntity() => Project(
        id: id,
        name: name,
        description: description,
        modules: modules?.map((m) => m.toEntity()).toList() ?? [],
      );

  static ProjectModel fromEntity(Project entity) =>
      ProjectModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        modules:
            entity.modules?.map((m) => ModuleModel.fromEntity(m)).toList() ??
                [],
      );
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
  List<RuleModel>? rules;

  @HiveField(4)
  List<ActivityModel>? activities;

  @HiveField(5)
  List<SubModuleModel>? subModules;

  ModuleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rules,
    required this.activities,
    required this.subModules,
  });

  Module toEntity() => Module(
        id: id,
        name: name,
        description: description,
        rules: rules?.map((m) => m.toEntity()).toList() ?? [],
        activities: activities?.map((m) => m.toEntity()).toList() ?? [],
        subModules: subModules?.map((m) => m.toEntity()).toList() ?? [],
      );

  static ModuleModel fromEntity(Module entity) => ModuleModel(
        id:  entity.id,
        name: entity.name,
        description: entity.description,
        rules: entity.rules?.map((m) => RuleModel.fromEntity(m)).toList() ?? [],
        subModules: entity.subModules?.map((m) => SubModuleModel.fromEntity(m)).toList() ?? [],
        activities: entity.activities?.map((m) => ActivityModel.fromEntity(m)).toList() ?? [],
      );

  ModuleModel copyWith({
    int? id,
    String? name,
    String? description,
    List<RuleModel>? rules,
    List<ActivityModel>? activities,
    List<SubModuleModel>? subModules,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rules: rules != null
          ? [...rules]
          : (this.rules != null ? [...this.rules!] : null),
      activities: activities != null
          ? [...activities]
          : (this.activities != null ? [...this.activities!] : null),
      subModules: subModules != null
          ? [...subModules]
          : (this.subModules != null ? [...this.subModules!] : null),
    );
  }

}

@HiveType(typeId: 2)
class SubModuleModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<RuleModel>? rules;

  @HiveField(4)
  List<ActivityModel>? activities;

  SubModuleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rules,
    required this.activities,
  });

  SubModule toEntity() => SubModule(
        id: id,
        name: name,
        description: description,
        rules: rules?.map((m) => m.toEntity()).toList() ?? [],
        activities: activities?.map((m) => m.toEntity()).toList() ?? [],
      );

  static SubModuleModel fromEntity(SubModule entity) => SubModuleModel(
        id:  entity.id,
        name: entity.name,
        description: entity.description,
        rules: entity.rules?.map((m) => RuleModel.fromEntity(m)).toList() ?? [],
        activities: entity.activities?.map((m) => ActivityModel.fromEntity(m)).toList() ?? [],
      );

}

@HiveType(typeId: 3)
class RuleModel extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String detail;

  @HiveField(3)
  int? subModuleId;

  RuleModel({
    required this.id,
    required this.name,
    required this.detail,
    this.subModuleId,
  });

  Rule toEntity() => Rule(
        id: id,
        name: name,
        detail: detail,
      );

    static RuleModel fromEntity(Rule entity) => RuleModel(
        id: entity.id,
        name: entity.name,
        detail: entity.detail,
        subModuleId: entity.subModuleId,
      );

}

@HiveType(typeId: 4)
class ActivityModel extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String detail;

  @HiveField(3)
  List<RuleModel>? rules;

  @HiveField(4)
  int? subModuleId;

  ActivityModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.rules,
    this.subModuleId,
  });

  Activity toEntity() => Activity(
        id: id,
        name: name,
        detail: detail,
        rules: rules?.map((m) => m.toEntity()).toList() ?? [],
        subModuleId: subModuleId
      );

    static ActivityModel fromEntity(Activity entity,) => ActivityModel(
        id: entity.id,
        name: entity.name,
        detail: entity.detail,
        rules: entity.rules?.map((m) => RuleModel.fromEntity(m)).toList() ?? [],
        subModuleId: entity.subModuleId,
      );

}
