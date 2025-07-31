import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';

class Module {
  int id;
  String name;
  String description;
  List<SubModule>? subModules;
  List<Rule>? rules;
  List<Activity>? activities;

  Module(
      {required this.id,
      required this.name,
      required this.description,
      this.subModules = const [],
      this.rules = const [],
      this.activities = const []});
}

class ModuleTest {
  int id;
  String name;
  String description;
  List<SubModuleTest>? subModules;
  List<Rule>? rules;
  List<ActivityTest>? activities;

  ModuleTest(
      {required this.id,
      required this.name,
      required this.description,
      this.subModules = const [],
      this.rules = const [],
      this.activities = const []});

  factory ModuleTest.fromModule(Module module) {
    return ModuleTest(
      id: module.id,
      name: module.name,
      description: module.description,
      subModules: module.subModules?.map((a) => SubModuleTest.fromSubModule(a)).toList(),
      rules: module.rules ?? [],
      activities: module.activities?.map((a) => ActivityTest.fromActivity(a)).toList(),
    );
  }
}
