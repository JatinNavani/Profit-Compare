import 'dart:convert';
import 'package:http/http.dart' as http;

class GPTService {
  final String _apiKey = ""; // Your Gemini API Key

  Future<String> getResponse(String userInput) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey"
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userInput}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print("Gemini Error: ${response.statusCode} ${response.body}");
        return "Sorry, Gemini API error occurred.";
      }
    } catch (e) {
      print("Exception: $e");
      return "Something went wrong. Please check your connection.";
    }
  }
}
