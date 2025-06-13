// presentation/pages/module_screen.dart

import 'dart:math';

import 'package:check_list_qa/domain/entities/modul.dart';
import 'package:check_list_qa/presentation/providers/modules_provider/module_provider.dart';
import 'package:check_list_qa/presentation/screens/activity_list_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/project_model.dart'; // o Project si ya estás usando entidades

class ModuleScreen extends ConsumerWidget {
  final ProjectModel project; // o Project

  const ModuleScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(moduleListProvider(project));
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Módulos de ${project.name}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                //Cambiar esta impplementación para dejarlo lo mas limpio posible
                final model = ModuleModel.fromEntity(module);
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityScreen(projectId: project.id, module: model),
                      )),
                  child: ListTile(
                    title: Text(module.name),
                    subtitle: Text(module.description),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre del módulo'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final desc = descriptionController.text.trim();
                    if (name.isEmpty) return;
                    final module = Module(
                      id: Random().nextInt(0xFFFFFFFF),
                      name: name,
                      description: desc);
                    ref.read(moduleListProvider(project).notifier).addModule(module);
                    nameController.clear();
                    descriptionController.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
