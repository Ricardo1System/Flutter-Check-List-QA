import 'dart:math';

import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/presentation/providers/project_provider.dart';
import 'package:check_list_qa/presentation/screens/module_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/project_provider.dart';
import '../../../domain/entities/project.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectListProvider);
    final notifier = ref.watch(projectListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Proyectos')),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          //Cambiar esta impplementación para dejarlo lo mas limpio posible
          final model = ProjectModel.fromEntity(project);
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleScreen(project: model),
                )),
            child: ListTile(
              title: Text(project.name),
              subtitle: Text(project.description),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, notifier),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, ProjectListNotifier notifier) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Proyecto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final desc = descController.text.trim();

              if (name.isNotEmpty) {
                notifier.addProject(Project(id: Random().nextInt(0xFFFFFFFF), name: name, description: desc, modules: []));
              }

              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
