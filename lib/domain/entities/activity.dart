import 'package:check_list_qa/domain/entities/rule.dart';

class Activity {
  int id;
  String name;
  String detail;
  List<Rule>? rules;
  int? subModuleId;

  Activity( 
      {required this.id,
      required this.name,
      required this.detail,
      this.rules = const [],
      this.subModuleId,});
}

class ActivityTest {
  int id;
  String name;
  String detail;
  List<Rule>? rules;
  int? subModuleId;
  bool isCheck;

  ActivityTest(
      {required this.id,
      required this.name,
      required this.detail,
      this.rules = const [],
      this.isCheck = false,
      this.subModuleId
      });

    factory ActivityTest.fromActivity(Activity activity) {
    return ActivityTest(
      id: activity.id,
      name: activity.name,
      detail: activity.detail,
      rules: activity.rules ?? [],
      subModuleId: activity.subModuleId,
      isCheck: false
    );
  }
}