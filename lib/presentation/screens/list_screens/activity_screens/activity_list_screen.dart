// presentation/pages/activity_screen.dart

import 'package:check_list_qa/core/theme/text_styles.dart';
import 'package:check_list_qa/core/utils/id_generator.dart';
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/presentation/providers/activities_provider/activity_provider.dart';
import 'package:check_list_qa/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/activity.dart';


class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key, required this.projectId, required this.module});
  final int projectId;
  final ModuleModel module;

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {

  final nameController = TextEditingController();
  final detailController = TextEditingController();
  Activity? activityUpdating;

  @override
  void initState() {
    ref.read(activityListProvider(widget.module).notifier).loadActivities(widget.projectId);
    super.initState();
  }


  @override
  void dispose() {
    nameController.dispose();
    detailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activityListProvider(widget.module));
    final isAdding = ref.watch(isAddingActivityProvider);
    final isUpdating = ref.watch(isUpdatingActivityProvider);
    final notifier = ref.read(activityListProvider(widget.module).notifier);

    onSave() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty || detail.isEmpty) return;

      final activity = Activity(
        id: IdGenerator.generate(),
        name: name,
        detail: detail,
      );

      final notifier = ref.read(activityListProvider(widget.module).notifier);
      notifier.addActivity(widget.projectId, widget.module.id, activity);
      ref.read(isAddingActivityProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    onUpdate() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty || detail.isEmpty) return;

      final activity = Activity(
        id: activityUpdating!.id,
        name: name,
        detail: detail,
      );

      final notifier = ref.read(activityListProvider(widget.module).notifier);
      notifier.updateActivity(widget.projectId, widget.module.id, activity);
      ref.read(isUpdatingActivityProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          ref.read(isAddingActivityProvider.notifier).state = false;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Actividades de ${widget.module.name}')),
        floatingActionButton:!isAdding? FloatingActionButton(onPressed: () {
          ref.read(isAddingActivityProvider.notifier).state = true;
        }, child: const Icon(Icons.add),) : null,
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  thickness: 2,
                  height: 1,
                ),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Dismissible(
                    key: Key(activity.id.toString()),
                    background: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.blue,
                      child:  const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Editar", style:  Styles.bodyText,)),
                    ),
                    confirmDismiss: (direction) async {
                      switch (direction) {
                        case DismissDirection.startToEnd:
                        ref.read(isUpdatingActivityProvider.notifier).state = true;
                        activityUpdating = activity;
                        nameController.text = activity.name;
                        detailController.text = activity.detail;
                        return false;
                        case DismissDirection.endToStart:
                          notifier.removeFromState(activity);
                          notifier.deleteActivity(widget.projectId, widget.module.id, activity);
                          return true;
                        default:
                        return false;
                      }
                    },
                    secondaryBackground: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 10),
                      child:  const Align(
                        alignment: Alignment.centerRight,
                        child: Text("Eliminar", style: Styles.bodyText,)),
                    ),
                    child: Container(
                      color: Colors.blueGrey,
                      child: ListTile(
                        title: Text(activity.name, style: Styles.titleText,),
                        subtitle: Text(activity.detail, style: Styles.bodyText,),
                      ),
                    ),
                  );
                },
              ),
            ),
            if(isAdding)...[
              DoubleForm(
                fistLabel: "Nombre de la actividad",
                firstController: nameController,
                secondLabel: "Descripción",
                secondController: detailController,
                buttonLabel: "Guardar",
                onTap: onSave,
              )
            ],
            if(isUpdating)...[
              DoubleForm(
                fistLabel: "Nombre de la actividad",
                firstController: nameController,
                secondLabel: "Descripción",
                secondController: detailController,
                buttonLabel: "Actualizar",
                onTap: onUpdate,
              )
            ],
          ],
        ),
      ),
    );
  }
}
