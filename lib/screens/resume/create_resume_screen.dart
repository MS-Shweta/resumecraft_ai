import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'resume_list_screen.dart';
import '../../services/ai_service.dart';

class CreateResumeScreen extends StatefulWidget {
  const CreateResumeScreen({super.key});

  @override
  State<CreateResumeScreen> createState() => _CreateResumeScreenState();
}

class _CreateResumeScreenState extends State<CreateResumeScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final educationController = TextEditingController();
  final summaryController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    skillsController.dispose();
    experienceController.dispose();
    educationController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  Future<void> saveResume() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection("resumes").add({
        "userId": user.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "skills": skillsController.text.trim(),
        "experience": experienceController.text.trim(),
        "education": educationController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
        "summary": summaryController.text.trim(),
      });

      if (!mounted) return;

      messenger.showSnackBar(
        const SnackBar(content: Text("Resume Saved Successfully")),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      nameController.clear();
      emailController.clear();
      phoneController.clear();
      skillsController.clear();
      experienceController.clear();
      educationController.clear();
      summaryController.clear();

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResumeListScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6C63FF), Color(0xff8B5CF6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Create Resume",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildField("Name", nameController),
                        buildField("Email", emailController),
                        buildField("Phone", phoneController),
                        buildField("Skills", skillsController),
                        buildField("Experience", experienceController),
                        buildField("Education", educationController),
                        buildField("AI Summary", summaryController),
                        const SizedBox(height: 30),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              String result = await AIService.generateSummary(
                                skillsController.text,
                                experienceController.text,
                              );

                              if (!mounted) return;

                              setState(() {
                                summaryController.text = result;
                              });

                              messenger.showSnackBar(
                                const SnackBar(content: Text("AI Summary Generated")),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.deepPurple, strokeWidth: 2),
                                )
                              : const Text("Generate AI Summary"),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: saveResume,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff6C63FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Save Resume",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
