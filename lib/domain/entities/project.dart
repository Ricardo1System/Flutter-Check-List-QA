import 'package:check_list_qa/domain/entities/modul.dart';

class Project {
  final int id;
  final String name;
  final String description;
  final List<Module> modules;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.modules
  });
}
