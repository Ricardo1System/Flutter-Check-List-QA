// presentation/pages/activity_screen.dart

import 'package:check_list_qa/core/theme/text_styles.dart';
import 'package:check_list_qa/core/utils/id_generator.dart';
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';
import 'package:check_list_qa/presentation/providers/activities_provider/activity_provider.dart';
import 'package:check_list_qa/presentation/providers/rule_provider/rule_provider.dart';
import 'package:check_list_qa/presentation/providers/sub_module_provider/sub_module_provider.dart';
import 'package:check_list_qa/presentation/screens/list_screens/sub_module_screens/sub_module_detail_screen.dart';
import 'package:check_list_qa/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/activity.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({
    super.key,
    required this.projectId,
    required this.module,
  });
  final int projectId;
  final ModuleModel module;

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  SubModule? subModuleUpdating;
  Rule? ruleUpdating;
  Activity? activityUpdating;

  @override
  void initState() {
    ref.read(activityListNotifierProvider.notifier).loadActivities(widget.module, widget.projectId);
    ref.read(ruleListNotifierProvider.notifier).loadRules(widget.module, widget.projectId);
    ref.read(subModuleListNotifierProvider.notifier).loadSubModules(widget.module, widget.projectId);
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
    final subModules = ref.watch(subModuleListNotifierProvider);
    final isAddingSubModule = ref.watch(isAddingSubModuleProvider);
    final isUpdatingSubModule = ref.watch(isUpdatingSubModuleProvider);
    final notifierSubModules =ref.read(subModuleListNotifierProvider.notifier);

    final activities = ref.watch(activityListNotifierProvider);
    final isAddingActivity = ref.watch(isAddingActivityProvider);
    final isUpdatingActivity = ref.watch(isUpdatingActivityProvider);
    final notifierActivity = ref.read(activityListNotifierProvider.notifier);

    final rules = ref.watch(ruleListNotifierProvider);
    final isAddingRule = ref.watch(isAddingRuleProvider);
    final isUpdatingRule = ref.watch(isUpdatingRuleProvider);
    final notifierRule = ref.read(ruleListNotifierProvider.notifier);

    onSaveSubModule() {
      final name = nameController.text.trim();
      final description = detailController.text.trim();
      if (name.isEmpty || description.isEmpty) return;

      final subModule = SubModule(
        id: IdGenerator.generate(),
        name: name,
        description: description,
      );

      final notifierActivity =
          ref.read(subModuleListNotifierProvider.notifier);
      notifierActivity.addSubModule(
           widget.module, widget.projectId, subModule);
      ref.read(isAddingSubModuleProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    onUpdateSubModule() {
      final name = nameController.text.trim();
      final description = detailController.text.trim();
      if (name.isEmpty || description.isEmpty) return;

      final subModule = SubModule(
        id: subModuleUpdating!.id,
        name: name,
        description: description,
      );

      final notifierActivity =
          ref.read(subModuleListNotifierProvider.notifier);
      notifierActivity.updateSubModule( widget.module, widget.projectId, subModule);
      ref.read(isUpdatingSubModuleProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    onSaveActivity() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty || detail.isEmpty) return;

      final activity = Activity(
        id: IdGenerator.generate(),
        name: name,
        detail: detail,
      );

      final notifierActivity =
          ref.read(activityListNotifierProvider.notifier);
      notifierActivity.addActivity(widget.module, widget.projectId, activity);
      ref.read(isAddingActivityProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    onUpdateActivity() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty || detail.isEmpty) return;

      final activity = Activity(
        id: activityUpdating!.id,
        name: name,
        detail: detail,
      );

      final notifierActivity =
          ref.read(activityListNotifierProvider.notifier);
      notifierActivity.updateActivity(widget.module, widget.projectId, activity);
      ref.read(isUpdatingActivityProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    onSaveRule() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty) return;

      final rule = Rule(
        id: IdGenerator.generate(),
        name: name,
        detail: detail,
      );

      final notifierRule = ref.read(ruleListNotifierProvider.notifier);
      notifierRule.addRule( widget.module, widget.projectId, rule);
      ref.read(isAddingRuleProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    onUpdateRule() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty) return;

      final rule = Rule(
        id: ruleUpdating!.id,
        name: name,
        detail: detail,
      );

      final notifierRule = ref.read(ruleListNotifierProvider.notifier);
      notifierRule.updateRule( widget.module, widget.projectId, rule);
      ref.read(isUpdatingRuleProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    var divider = Divider(
      color: Colors.amber[700],
      thickness: 10.0,
      height: 1.0,
    );

    String title = 'Módulo de ${widget.module.name}';
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(isAddingSubModuleProvider.notifier).state = false;
          ref.read(isAddingRuleProvider.notifier).state = false;
          ref.read(isAddingActivityProvider.notifier).state = false;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Column(
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    if (rules.isNotEmpty) ...[
                      _rulesList(rules, notifierRule),
                      divider
                    ],
                    if (activities.isNotEmpty) ...[
                      _activitiesList(activities, notifierActivity),
                      divider
                    ],
                    if (subModules.isNotEmpty) ...[
                      _subModulesList(subModules, notifierSubModules),
                    ],
                    if (isAddingSubModule) ...[
                      DoubleForm(
                        fistLabel: "Nombre del sub-modulo",
                        firstController: nameController,
                        secondLabel: "Detalles",
                        secondController: detailController,
                        buttonLabel: "Guardar",
                        onTap: onSaveSubModule,
                      )
                    ],
                    if (isUpdatingSubModule) ...[
                      DoubleForm(
                        fistLabel: "Nombre del sub-modulo",
                        firstController: nameController,
                        secondLabel: "Detalles",
                        secondController: detailController,
                        buttonLabel: "Actualizar",
                        onTap: onUpdateSubModule,
                      )
                    ],
                    if (isAddingActivity) ...[
                      DoubleForm(
                        fistLabel: "Nombre de la actividad",
                        firstController: nameController,
                        secondLabel: "Descripción",
                        secondController: detailController,
                        buttonLabel: "Guardar",
                        onTap: onSaveActivity,
                      )
                    ],
                    if (isUpdatingActivity) ...[
                      DoubleForm(
                        fistLabel: "Nombre de la actividad",
                        firstController: nameController,
                        secondLabel: "Descripción",
                        secondController: detailController,
                        buttonLabel: "Actualizar",
                        onTap: onUpdateActivity,
                      )
                    ],
                    if (isAddingRule) ...[
                      DoubleForm(
                        fistLabel: "Regla",
                        firstController: nameController,
                        secondLabel: "Descripción",
                        secondController: detailController,
                        buttonLabel: "Guardar",
                        onTap: onSaveRule,
                      )
                    ],
                    if (isUpdatingRule) ...[
                      DoubleForm(
                        fistLabel: "Regla",
                        firstController: nameController,
                        secondLabel: "Descripción",
                        secondController: detailController,
                        buttonLabel: "Actualizar",
                        onTap: onUpdateRule,
                      )
                    ],
                  ],
                )),
            Expanded(flex: 1, child: _toolsList()),
          ],
        ),
      ),
    );
  }

  Container _toolsList() {
    return Container(
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "FloationActionButtonModule",
            onPressed: () {
              ref.read(isAddingSubModuleProvider.notifier).state =
                  !ref.read(isAddingSubModuleProvider.notifier).state;
              ref.read(isAddingActivityProvider.notifier).state = false;
              ref.read(isAddingRuleProvider.notifier).state = false;
            },
            child: const Icon(Icons.stacked_bar_chart_outlined),
          ),
          FloatingActionButton(
            heroTag: "FloationActionButtonRule",
            onPressed: () {
              ref.read(isAddingRuleProvider.notifier).state =
                  !ref.read(isAddingRuleProvider.notifier).state;
              ref.read(isAddingActivityProvider.notifier).state = false;
              ref.read(isAddingSubModuleProvider.notifier).state = false;
            },
            child: const Icon(Icons.rule),
          ),
          FloatingActionButton(
            heroTag: "FloationActionButtonActivity",
            onPressed: () {
              ref.read(isAddingActivityProvider.notifier).state =
                  !ref.read(isAddingActivityProvider.notifier).state;
              ref.read(isAddingRuleProvider.notifier).state = false;
              ref.read(isAddingSubModuleProvider.notifier).state = false;
            },
            child: const Icon(Icons.library_add_sharp),
          ),
        ],
      ),
    );
  }

  Expanded _subModulesList(
      List<SubModule> subModules, SubModuleListNotifier notifierSubModules) {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 2,
          height: 1,
        ),
        itemCount: subModules.length,
        itemBuilder: (context, index) {
          final subModule = subModules[index];
          final subModuleModel = SubModuleModel.fromEntity(subModule);
          return InkWell(
            onTap:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ActivitySubModuleScreen(projectId: widget.projectId, module: widget.module.copyWith(), subModule: subModuleModel,),
                  ));
            },
            child: Dismissible(
              key: Key(subModule.id.toString()),
              background: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.blue,
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Editar",
                      style: Styles.bodyText,
                    )),
              ),
              confirmDismiss: (direction) async {
                switch (direction) {
                  case DismissDirection.startToEnd:
                    ref.read(isUpdatingActivityProvider.notifier).state = true;
                    subModuleUpdating = subModule;
                    nameController.text = subModule.name;
                    detailController.text = subModule.description;
                    return false;
                  case DismissDirection.endToStart:
                    notifierSubModules.removeFromState(widget.module, subModule);
                    notifierSubModules.deleteSubModule(
                         widget.module, widget.projectId, subModule);
                    return true;
                  default:
                    return false;
                }
              },
              secondaryBackground: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(right: 10),
                child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Eliminar",
                      style: Styles.bodyText,
                    )),
              ),
              child: Container(
                color: Colors.blue[600],
                child: ListTile(
                  title: Text(
                    subModule.name,
                    style: Styles.titleText,
                  ),
                  subtitle: Text(
                    subModule.description,
                    style: Styles.bodyText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded _activitiesList(List<Activity> activities, ActivityListNotifier notifierActivity) {
    return Expanded(
      flex: 2,
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
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Editar",
                    style: Styles.bodyText,
                  )),
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
                  notifierActivity.removeFromState(widget.module, activity);
                  notifierActivity.deleteActivity(
                      widget.projectId, widget.module.id, activity);
                  return true;
                default:
                  return false;
              }
            },
            secondaryBackground: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(right: 10),
              child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Eliminar",
                    style: Styles.bodyText,
                  )),
            ),
            child: Container(
              color: Colors.blueGrey,
              child: ListTile(
                title: Text(
                  activity.name,
                  style: Styles.titleText,
                ),
                subtitle: Text(
                  activity.detail,
                  style: Styles.bodyText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded _rulesList(List<Rule> rules, RuleListNotifier notifierRule) {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 2,
          height: 1,
        ),
        itemCount: rules.length,
        itemBuilder: (context, index) {
          final rule = rules[index];
          return Dismissible(
            key: Key(rule.id.toString()),
            background: Container(
              padding: const EdgeInsets.only(left: 10),
              color: Colors.blue,
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Editar",
                    style: Styles.bodyText,
                  )),
            ),
            confirmDismiss: (direction) async {
              switch (direction) {
                case DismissDirection.startToEnd:
                  ref.read(isUpdatingRuleProvider.notifier).state = true;
                  ruleUpdating = rule;
                  nameController.text = rule.name;
                  detailController.text = rule.detail;
                  return false;
                case DismissDirection.endToStart:
                  notifierRule.removeFromState(widget.module, rule);
                  notifierRule.deleteRule(widget.module, widget.projectId, rule);
                  return true;
                default:
                  return false;
              }
            },
            secondaryBackground: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(right: 10),
              child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Eliminar",
                    style: Styles.bodyText,
                  )),
            ),
            child: Container(
              color: Colors.red[900],
              child: ListTile(
                title: Text(
                  "*${rule.name}",
                  style: Styles.titleText,
                ),
                subtitle: Text(
                  rule.detail,
                  style: Styles.bodyText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
