import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class PdfService {
  static Future<File?> generateResumePdf(Map<String, dynamic> data) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "RESUME",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text("Name: ${data['name'] ?? ''}"),
                pw.Text("Email: ${data['email'] ?? ''}"),
                pw.Text("Phone: ${data['phone'] ?? ''}"),
                pw.Text("Skills: ${data['skills'] ?? ''}"),
                pw.Text("Experience: ${data['experience'] ?? ''}"),
                pw.Text("Education: ${data['education'] ?? ''}"),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        "${dir.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf",
      );

      await file.writeAsBytes(bytes);
      return file;
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint("PDF ERROR: $e");
        debugPrint("STACK: $stack");
      }
      return null;
    }
  }
}
