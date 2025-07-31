class Rule {
  final int id;
  final String name;
  final String detail;
  int? subModuleId;

  Rule(
      {required this.id,
      required this.name,
      required this.detail,
      this.subModuleId});
}