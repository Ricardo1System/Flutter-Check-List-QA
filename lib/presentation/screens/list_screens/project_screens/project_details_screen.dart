import 'package:check_list_qa/core/theme/text_styles.dart';
import 'package:check_list_qa/core/utils/id_generator.dart';
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/module.dart';
import 'package:check_list_qa/presentation/providers/modules_provider/module_provider.dart';
import 'package:check_list_qa/presentation/screens/list_screens/module_screens/module_detail_screen.dart';
import 'package:check_list_qa/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleScreen extends ConsumerStatefulWidget {
  const ModuleScreen({super.key, required this.project});
  final ProjectModel project;

  @override
  ConsumerState<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends ConsumerState<ModuleScreen> {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Module? moduleUpdating;

    @override
  void initState() {
    ref.read(moduleListNotifierProvider.notifier).loadModules(widget.project);
    super.initState();
  }

    @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


 @override
  Widget build(BuildContext context) {
    final modules = ref.watch(moduleListNotifierProvider);
    final isAdding = ref.watch(isAddingModuleProvider);
    final isUpdating = ref.watch(isUpdatingModuleProvider);

    onSave() {
      final name = nameController.text.trim();
      final desc = descriptionController.text.trim();
      if (name.isEmpty) return;
      final module = Module(id: IdGenerator.generate(), name: name, description: desc);
      ref.read(moduleListNotifierProvider.notifier).addModule(widget.project, module);
      nameController.clear();
      descriptionController.clear();
      ref.read(isAddingModuleProvider.notifier).state = false;
    }

    onUpdate() {
      final name = nameController.text.trim();
      final desc = descriptionController.text.trim();
      if (name.isEmpty) return;
      final module = Module(id: moduleUpdating!.id, name: name, description: desc);
      ref.read(moduleListNotifierProvider.notifier).updatingModule(widget.project, module);
      nameController.clear();
      descriptionController.clear();
      ref.read(isUpdatingModuleProvider.notifier).state = false;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          ref.read(isAddingModuleProvider.notifier).state = false;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Módulos de ${widget.project.name}')),
        floatingActionButton: !isAdding
            ? FloatingActionButton(
                onPressed: () {
                  ref.read(isAddingModuleProvider.notifier).state =
                      !ref.read(isAddingModuleProvider.notifier).state;
                },
                child: Icon(isAdding ? Icons.close : Icons.add),
              )
            : null,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  //Cambiar esta impplementación para dejarlo lo mas limpio posible
                  final model = ModuleModel.fromEntity(module);
                  return InkWell(
                    onTap: () {
                      ref.read(isAddingModuleProvider.notifier).state = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityScreen(
                                projectId: widget.project.id, module: model),
                          ));
                    },
                    child: Dismissible(
                      key: Key(module.id.toString()),
                      confirmDismiss: (direction) async{
                        switch(direction){
                          case DismissDirection.startToEnd:
                           ref.read(isUpdatingModuleProvider.notifier).state = true;
                           moduleUpdating = module;
                           nameController.text = module.name;
                           descriptionController.text = module.description;
                           return false;
                          case DismissDirection.endToStart:
                          ref.read(moduleListNotifierProvider.notifier)
                          .removeFromState(widget.project, module);
                          ref.read(moduleListNotifierProvider.notifier)
                          .deleteModule(widget.project, module);

                          return true;
                          default:
                          return false;
                        }
                      },
                      background: Container(
                        padding: const EdgeInsets.only(left: 10),
                        color: Colors.blue,
                        child:  const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Editar", style:  Styles.bodyText,)),
                      ),
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
                          title: Text(
                            module.name,
                            style: Styles.titleText,),
                          subtitle: Text(
                            module.description,
                            style: Styles.bodyText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isAdding)
                  DoubleForm(
                  fistLabel: "Nombre del Módulo",
                  firstController: nameController,
                  secondLabel: "Descripción",
                  secondController: descriptionController,
                  buttonLabel: "Guardar",
                  onTap: onSave,
                ),
            if(isUpdating)
              DoubleForm(
                  fistLabel: "Nombre del Módulo",
                  firstController: nameController,
                  secondLabel: "Descripción",
                  secondController: descriptionController,
                  buttonLabel: "Actualizar",
                  onTap: onUpdate,
                ),
          ],
        ),
      ),
    );
  }
}


