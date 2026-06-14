import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'pdf_service.dart';

class ResumeDetailScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const ResumeDetailScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? "Resume Detail", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xff6C63FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("Personal Information", [
              _buildDetailItem("Name", data['name']),
              _buildDetailItem("Email", data['email']),
              _buildDetailItem("Phone", data['phone']),
            ]),
            const SizedBox(height: 20),
            _buildSection("Skills", [
              Text(data['skills'] ?? "No skills listed", style: GoogleFonts.inter(fontSize: 16)),
            ]),
            const SizedBox(height: 20),
            _buildSection("Experience", [
              Text(data['experience'] ?? "No experience listed", style: GoogleFonts.inter(fontSize: 16)),
            ]),
            const SizedBox(height: 20),
            _buildSection("Education", [
              Text(data['education'] ?? "No education listed", style: GoogleFonts.inter(fontSize: 16)),
            ]),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final file = await PdfService.generateResumePdf(data);

                  if (!context.mounted) return;

                  if (file != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("PDF Saved in Downloads")),
                    );
                    
                    await OpenFile.open(file.path);
                    debugPrint("PDF Path: ${file.path}");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to generate PDF")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Download & Open PDF",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xff6C63FF),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "N/A")),
        ],
      ),
    );
  }
}
