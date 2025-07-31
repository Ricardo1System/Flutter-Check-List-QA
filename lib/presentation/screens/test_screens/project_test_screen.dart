import 'package:check_list_qa/domain/entities/project.dart';
import 'package:check_list_qa/presentation/widgets/pie_chart_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectTestScreen extends ConsumerStatefulWidget {
  const ProjectTestScreen({super.key, required this.project});
  final ProjectTest project;

  @override
  ConsumerState<ProjectTestScreen> createState() => _ProjectTestScreenState();
}

class _ProjectTestScreenState extends ConsumerState<ProjectTestScreen> {
  int moduleCheck = 0;
  double activitiesCheck = 0;
  double activitiesNotCheck = 0;
  late ProjectTest project;

  late Map<String, double> dataMap;

  @override
  void initState() {
    project = widget.project;
    getData();
    super.initState();
  }

  getData() {
    dataMap = <String, double>{
      "true": double.parse(getChecks().toString()),
      "false": double.parse(getNotChecks().toString()),
    };
  }

  getChecks() {
    return project.modules
            ?.expand((module) {
              final moduleActivities = module.activities ?? [];
              final subModuleActivities =
                  module.subModules?.expand((sub) => sub.activities ?? []) ??
                      [];
              return [...moduleActivities, ...subModuleActivities];
            })
            .where((activity) => activity.isCheck == true)
            .length ??
        0;
  }

  getNotChecks() {
    return project.modules
            ?.expand((module) {
              final moduleActivities = module.activities ?? [];
              final subModuleActivities =
                  module.subModules?.expand((sub) => sub.activities ?? []) ??
                      [];
              return [...moduleActivities, ...subModuleActivities];
            })
            .where((activity) => activity.isCheck == false)
            .length ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _header(),
            _bodyList(),
          ],
        ),
      ),
    );
  }

  checkModule(int moduleIndex) {
    setState(() {
      moduleCheck = moduleIndex;
    });
  }

  checkActivity(int moduleIndex, int activityIndex, bool value) {
    setState(() {
      project.modules![moduleIndex].activities![activityIndex].isCheck = value;
    });
    getData();
  }

  checkSubModuleActivity(int moduleIndex, int subModuleIndex, int activityIndex, bool value) {
    setState(() {
      project.modules![moduleIndex].subModules![subModuleIndex].activities![activityIndex].isCheck = value;
    });
    getData();
  }

  Widget _header() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.24,
      child: Column(
        children: [
          Container(
            color: Colors.green[700],
            padding: const EdgeInsets.all(10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Regresión de apartados",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      color: Colors.green[700],
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                        "Objetivo General",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                        child: TextFormField(
                      minLines: 1,
                      maxLines: 3,
                    ))
                  ],
                ),
              ),
              PieChartCustom(
                dataMap: dataMap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyList() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, moduleIndex) {
                    return InkWell(
                      onTap: () => checkModule(moduleIndex),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          project.modules?[moduleIndex].name ?? "",
                          style: TextStyle(
                              color: moduleIndex != moduleCheck
                                  ? Colors.white
                                  : Colors.green,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const VerticalDivider();
                  },
                  itemCount: project.modules?.length ?? 0),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.separated(
                    itemBuilder: (context, activityIndex) {
                      return Row(
                        children: [
                          Text(project.modules?[moduleCheck]
                                  .activities?[activityIndex].name ??
                              ""),
                          const Spacer(),
                          Checkbox(
                            value: project.modules?[moduleCheck]
                                .activities?[activityIndex].isCheck,
                            onChanged: (value) => checkActivity(
                                moduleCheck, activityIndex, value ?? false),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount:
                        project.modules?[moduleCheck].activities?.length ?? 0),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.separated(
                  itemBuilder: (context, subModuleIndex) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.blueGrey,
                          margin: const EdgeInsets.only(right: 80.0),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(project.modules?[moduleCheck]
                                  .subModules?[subModuleIndex].name ??
                              "", style: const TextStyle(color: Colors.white),),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ListView.separated(
                            itemBuilder: (context, subModuleActivityIndex) {
                              return Row(
                                children: [
                                  Text(project.modules?[moduleCheck]
                                          .subModules?[subModuleIndex].name ??
                                      ""),
                                  const Spacer(),
                                  Checkbox(
                                    value: project
                                        .modules?[moduleCheck]
                                        .subModules?[subModuleIndex]
                                        .activities?[subModuleActivityIndex]
                                        .isCheck,
                                    onChanged: (value) =>
                                        checkSubModuleActivity(moduleCheck, subModuleIndex,
                                            subModuleActivityIndex, value ?? false),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: project
                                    .modules?[moduleCheck]
                                    .subModules?[subModuleIndex]
                                    .activities
                                    ?.length ??
                                0,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount:
                      project.modules?[moduleCheck].subModules?.length ?? 0),
            )
          ],
        ));
  }
}
