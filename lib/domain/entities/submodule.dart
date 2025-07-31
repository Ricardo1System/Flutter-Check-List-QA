import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/rule.dart';

class SubModule {
  int id;
  String name;
  String description;
  List<Rule>? rules;
  List<Activity>? activities;

  SubModule(
      {required this.id,
      required this.name,
      required this.description,
      this.rules = const [],
      this.activities = const []});
}

class SubModuleTest {
  int id;
  String name;
  String description;
  List<Rule>? rules;
  List<ActivityTest>? activities;

  SubModuleTest(
      {required this.id,
      required this.name,
      required this.description,
      this.rules = const [],
      this.activities = const []});

  factory SubModuleTest.fromSubModule(SubModule module) {
    return SubModuleTest(
      id: module.id,
      name: module.name,
      description: module.description,
      rules: module.rules ?? [],
      activities: module.activities?.map((a) => ActivityTest.fromActivity(a)).toList(),
    );
  }
}
