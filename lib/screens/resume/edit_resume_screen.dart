import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditResumeScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditResumeScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<EditResumeScreen> createState() => _EditResumeScreenState();
}

class _EditResumeScreenState extends State<EditResumeScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController skillsController;
  late TextEditingController experienceController;
  late TextEditingController educationController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.data["name"]);
    emailController = TextEditingController(text: widget.data["email"]);
    phoneController = TextEditingController(text: widget.data["phone"]);
    skillsController = TextEditingController(text: widget.data["skills"]);
    experienceController = TextEditingController(text: widget.data["experience"]);
    educationController = TextEditingController(text: widget.data["education"]);
  }

  Future<void> updateResume() async {
    await FirebaseFirestore.instance
        .collection("resumes")
        .doc(widget.docId)
        .update({
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "skills": skillsController.text,
      "experience": experienceController.text,
      "education": educationController.text,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Resume Updated Successfully")),
    );

    Navigator.pop(context);
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Resume"),
        backgroundColor: const Color(0xff6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildField("Name", nameController),
              buildField("Email", emailController),
              buildField("Phone", phoneController),
              buildField("Skills", skillsController),
              buildField("Experience", experienceController),
              buildField("Education", educationController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C63FF),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Update Resume"),
              )
            ],
          ),
        ),
      ),
    );
  }
}