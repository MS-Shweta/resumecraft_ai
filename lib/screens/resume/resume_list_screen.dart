import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'resume_detail_screen.dart';
import 'edit_resume_screen.dart';

class ResumeListScreen extends StatelessWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Resumes"),
        backgroundColor: const Color(0xff6C63FF),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("resumes")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No resumes found"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data();
              var docId = docs[index].id;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff6C63FF), Color(0xff8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.white),
                  title: Text(
                    data["name"] ?? "No Name",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    data["email"] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // EDIT BUTTON
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditResumeScreen(
                                docId: docId,
                                data: data,
                              ),
                            ),
                          );
                        },
                      ),

                      // DELETE BUTTON
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("resumes")
                              .doc(docId)
                              .delete();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResumeDetailScreen(
                          docId: docId,
                          data: data,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
