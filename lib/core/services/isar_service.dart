// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../data/models/project_model.dart';

// class IsarService {
//   static final IsarService _instance = IsarService._internal();
//   late final Isar db;

//   factory IsarService() => _instance;

//   IsarService._internal();

//   Future<void> init() async {
//     final dir = await getApplicationDocumentsDirectory();
//     db = await Isar.open(
//       [ProjectModelSchema],
//       directory: dir.path,
//     );
//   }
// }
