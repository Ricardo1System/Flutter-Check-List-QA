import 'package:check_list_qa/domain/entities/activity.dart';
import 'package:check_list_qa/domain/entities/rule.dart';

class Module {
  final int id;
  final String name;
  final String description;
  final List<Rule>? rules;
  final List<Activity>? activities;

  Module(
      {required this.id,
      required this.name,
      required this.description,
      this.rules = const [],
      this.activities = const []});
}