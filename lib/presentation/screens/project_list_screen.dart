import 'package:check_list_qa/core/theme/text_styles.dart';
import 'package:check_list_qa/core/utils/id_generator.dart';
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
      appBar: AppBar(title: const Text('Mis Proyectos'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: projects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
          ),
          itemBuilder: (context, index) {
            final project = projects[index];
            final model = ProjectModel.fromEntity(project);
            var name =projects[index].name;
            var description =projects[index].description;
            Offset tapPosition = Offset.zero;
            //Cambiar esta impplementación para dejarlo lo mas limpio posible
            return GestureDetector(
              onTapDown: (details) {
                tapPosition = details.globalPosition;
              },
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleScreen(project: model),
                )),
              onLongPress: () {
                showMenu(
                  context: context,
                  color: Colors.blueGrey,
                  elevation: 2,
                  position: RelativeRect.fromLTRB(
                    tapPosition.dx,
                    tapPosition.dy,
                    tapPosition.dx,
                    tapPosition.dy,
                  ),
                  items: [
                    const PopupMenuItem(
                      value: 'test',
                      child: Text(
                        "Realizar Prueba",
                        style: Styles.popMenuItemText,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text(
                        "Editar",
                        style: Styles.popMenuItemText,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        "Eliminar",
                        style: Styles.popMenuItemText,
                      ),
                    ),
                  ],
                ).then((value) {
                  switch (value) {
                    case "test":
                      
                      break;
                    case "edit":
                      
                      break;
                    case "delete":
                      
                      break;
                    default:
                  }
                },);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.blueGrey
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(name, style: Styles.titleBoldText, textAlign: TextAlign.justify,),
                      Text(description, style: Styles.bodyText, textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),
            );
          },),
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
                notifier.addProject(Project(id: IdGenerator.generate(), name: name, description: desc, modules: []));
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
