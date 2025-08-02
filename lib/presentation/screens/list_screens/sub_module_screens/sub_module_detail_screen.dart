// presentation/pages/activity_screen.dart

import 'package:check_list_qa/core/theme/text_styles.dart';
import 'package:check_list_qa/core/utils/id_generator.dart';
import 'package:check_list_qa/data/models/project_model.dart';
import 'package:check_list_qa/domain/entities/rule.dart';
import 'package:check_list_qa/domain/entities/submodule.dart';
import 'package:check_list_qa/presentation/providers/sub_module_activities_provider/sub_module_activity_provider.dart';
import 'package:check_list_qa/presentation/providers/sub_module_provider/sub_module_provider.dart';
import 'package:check_list_qa/presentation/providers/sub_module_rule_provider/sub_module_rule_provider.dart';
import 'package:check_list_qa/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/activity.dart';

class ActivitySubModuleScreen extends ConsumerStatefulWidget {
  const ActivitySubModuleScreen({
    super.key,
    required this.projectId,
    required this.module,
    required this.subModule,
  });
  final int projectId;
  final ModuleModel module;
  final SubModuleModel subModule;

  @override
  ConsumerState<ActivitySubModuleScreen> createState() =>
      _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivitySubModuleScreen> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  SubModule? subModuleUpdating;
  Rule? ruleUpdating;
  Activity? activityUpdating;

  @override
  void initState() {
    ref.read(activityListSubModuleNotifierProvider.notifier).loadActivities(
          widget.module,
          widget.subModule,
          widget.projectId,
        );
    ref.read(ruleListSubModuleNotifierProvider.notifier).loadRules(
          widget.module,
          widget.subModule,
          widget.projectId,
        );
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

    final activities = ref.watch(
        activityListSubModuleNotifierProvider);
    final isAddingActivity = ref.watch(isAddingActivitySubModuleProvider);
    final isUpdatingActivity = ref.watch(isUpdatingActivitySubModuleProvider);
    final notifierActivity = ref.read(
        activityListSubModuleNotifierProvider
            .notifier);

    final rules =
        ref.watch(ruleListSubModuleNotifierProvider);
    final isAddingRule = ref.watch(isAddingRuleSubModuleProvider);
    final isUpdatingRule = ref.watch(isUpdatingRuleSubModuleProvider);
    final notifierRule = ref.read(
        ruleListSubModuleNotifierProvider.notifier);

    onSaveActivity() {
      final name = nameController.text.trim();
      final detail = detailController.text.trim();
      if (name.isEmpty || detail.isEmpty) return;

      final activity = Activity(
        id: IdGenerator.generate(),
        name: name,
        detail: detail,
      );

      final notifierActivity = ref.read(
          activityListSubModuleNotifierProvider
              .notifier);
      notifierActivity.addActivity(
           widget.module, widget.subModule, widget.projectId, activity);
      ref.read(isAddingActivitySubModuleProvider.notifier).state = false;
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

      final notifierActivity = ref.read(
          activityListSubModuleNotifierProvider
              .notifier);
      notifierActivity.updateActivity(
           widget.module, widget.subModule, widget.projectId, activity);
      ref.read(isUpdatingActivitySubModuleProvider.notifier).state = false;
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

      final notifierRule = ref.read(
          ruleListSubModuleNotifierProvider
              .notifier);
      notifierRule.addRule( widget.module, widget.subModule, widget.projectId, rule);
      ref.read(isAddingRuleSubModuleProvider.notifier).state = false;
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

      final notifierRule = ref.read(
          ruleListSubModuleNotifierProvider
              .notifier);
      notifierRule.updateRule(widget.module, widget.subModule, widget.projectId, rule);
      ref.read(isUpdatingRuleSubModuleProvider.notifier).state = false;
      nameController.clear();
      detailController.clear();
    }

    var divider = Divider(
      color: Colors.amber[700],
      thickness: 10.0,
      height: 1.0,
    );

    String title = 'Sub-módulo de ${widget.subModule.name}';
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(isAddingRuleSubModuleProvider.notifier).state = false;
          ref.read(isAddingActivitySubModuleProvider.notifier).state = false;
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
            heroTag: "FloationActionButtonRule",
            onPressed: () {
              ref.read(isAddingRuleSubModuleProvider.notifier).state =
                  !ref.read(isAddingRuleSubModuleProvider.notifier).state;
              ref.read(isAddingActivitySubModuleProvider.notifier).state = false;
              ref.read(isAddingSubModuleProvider.notifier).state = false;
            },
            child: const Icon(Icons.rule),
          ),
          FloatingActionButton(
            heroTag: "FloationActionButtonActivity",
            onPressed: () {
              ref.read(isAddingActivitySubModuleProvider.notifier).state =
                  !ref.read(isAddingActivitySubModuleProvider.notifier).state;
              ref.read(isAddingRuleSubModuleProvider.notifier).state = false;
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivitySubModuleScreen(
                      projectId: widget.projectId,
                      module: widget.module,
                      subModule: subModuleModel,
                    ),
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
                    ref.read(isUpdatingActivitySubModuleProvider.notifier).state = true;
                    subModuleUpdating = subModule;
                    nameController.text = subModule.name;
                    detailController.text = subModule.description;
                    return false;
                  case DismissDirection.endToStart:
                    notifierSubModules.removeFromState(widget.module, subModule);
                    notifierSubModules.deleteSubModule(widget.module, widget.projectId, subModule);
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

  Expanded _activitiesList(List<Activity> activities,
      ActivityListSubModuleNotifier notifierActivity) {
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
                  ref.read(isUpdatingActivitySubModuleProvider.notifier).state = true;
                  activityUpdating = activity;
                  nameController.text = activity.name;
                  detailController.text = activity.detail;
                  return false;
                case DismissDirection.endToStart:
                  notifierActivity.removeFromState(widget.subModule, activity);
                  notifierActivity.deleteActivity(widget.module, widget.subModule, widget.projectId, activity);
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

  Expanded _rulesList(
      List<Rule> rules, RuleListSubModuleNotifier notifierRule) {
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
                  ref.read(isUpdatingRuleSubModuleProvider.notifier).state = true;
                  ruleUpdating = rule;
                  nameController.text = rule.name;
                  detailController.text = rule.detail;
                  return false;
                case DismissDirection.endToStart:
                  notifierRule.removeFromState(widget.subModule, rule);
                  notifierRule.deleteRule(
                    widget.module,
                    widget.subModule,
                    widget.projectId,
                    rule,
                  );
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
