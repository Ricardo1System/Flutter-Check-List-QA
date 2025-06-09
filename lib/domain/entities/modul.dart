import 'package:check_list_qa/domain/entities/activity.dart';

class Module {
  final int id;
  final String name;
  final String description;
  final List<Activity> activities;

  Module(
      {required this.id,
      required this.name,
      required this.description,
      required this.activities});
}