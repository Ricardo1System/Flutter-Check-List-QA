// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// class PdfService {
//   Future<void> generatePdf() async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text('¡Hola Foquito el más calabacín!'),
//         ),
//       ),
//     );

//     final outputDir = await getTemporaryDirectory();
//     final file = File("${outputDir.path}/ejemplo.pdf");
//     await file.writeAsBytes(await pdf.save());

//     print('PDF guardado en: ${file.path}');
//   }
// }
