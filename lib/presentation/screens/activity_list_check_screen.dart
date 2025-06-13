// presentation/pages/activity_screen.dart

import 'dart:math';

import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/presentation/providers/activities_provider/activitie-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/activity.dart';

class ActivityScreen extends ConsumerWidget {
  final int projectId;
  final ModuleModel module;

  const ActivityScreen({required this.projectId, super.key, required this.module});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityListProvider(module));
    final nameController = TextEditingController();
    final detailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Actividades de ${module.name}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  title: Text(activity.name),
                  subtitle: Text(activity.detail),
                  trailing: Icon(
                    activity.check ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: activity.check ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre de actividad'),
                ),
                TextField(
                  controller: detailController,
                  decoration: const InputDecoration(labelText: 'Detalle'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final detail = detailController.text.trim();
                    if (name.isEmpty || detail.isEmpty) return;

                    final activity = Activity(
                      id: Random().nextInt(0xFFFFFFFF),
                      name: name,
                      detail: detail,
                      check: false,
                    );

                    final notifier = ref.read(activityListProvider(module).notifier);
                    notifier.addActivity(projectId, module.id, activity);

                    nameController.clear();
                    detailController.clear();
                  },
                  child: const Text('Agregar actividad'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
