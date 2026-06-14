import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<String> generateSummary(
      String skills, String experience) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":"Bearer YOUR_OPENAI_API_KEY",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": "You are a professional resume writer."
            },
            {
              "role": "user",
              "content":
                  "Create a professional resume summary:\nSkills: $skills\nExperience: $experience"
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Failed to generate summary: ${response.statusCode}";
      }
    } catch (e) {
      return "Failed to generate summary";
    }
  }
}
