import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum RewriteMode {
  clearer,
  shorter,
  formal,
  casual,
}

extension RewriteModeExtension on RewriteMode {
  String get label {
    switch (this) {
      case RewriteMode.clearer:
        return 'CLEARER';
      case RewriteMode.shorter:
        return 'SHORTER';
      case RewriteMode.formal:
        return 'FORMAL';
      case RewriteMode.casual:
        return 'CASUAL';
    }
  }

  String get prompt {
    switch (this) {
      case RewriteMode.clearer:
        return 'Rewrite the following text to be clearer and easier to understand. '
            'Fix any ambiguity, improve sentence structure, and use precise language. '
            'Keep the same meaning but make it crystal clear.';
      case RewriteMode.shorter:
        return 'Rewrite the following text to be more concise. '
            'Remove redundancy, cut filler words, and tighten the prose. '
            'Aim for at least 30% fewer words while preserving all key information.';
      case RewriteMode.formal:
        return 'Rewrite the following text in a formal, professional tone. '
            'Use proper grammar, avoid contractions and slang, '
            'and structure it appropriately for a business or academic context.';
      case RewriteMode.casual:
        return 'Rewrite the following text in a friendly, conversational tone. '
            'Make it warm, approachable, and easy to read — '
            'as if you are talking to a friend.';
    }
  }

  String get emoji {
    switch (this) {
      case RewriteMode.clearer:
        return '◎';
      case RewriteMode.shorter:
        return '→';
      case RewriteMode.formal:
        return '⊞';
      case RewriteMode.casual:
        return '◉';
    }
  }
}

class AIService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  String get _apiKey {
    final key = dotenv.env['API_KEY'] ?? '';
    if (key.isEmpty || key == 'your_api_key_here') {
      throw Exception('API key not configured. Please set API_KEY in your .env file.');
    }
    return key;
  }

  Future<String> rewrite(String text, RewriteMode mode) async {
    if (text.trim().isEmpty) {
      throw Exception('Please enter some text to rewrite.');
    }

    final systemPrompt = '''You are a precise text editor. 
${mode.prompt}

RULES:
- Output ONLY the rewritten text. No preamble, no explanation, no quotes.
- Do not say "Here is..." or "Sure!" or anything introductory.
- Preserve paragraph breaks where they exist.
- Output the result directly.''';

    // Combine system prompt with user text since Gemini API handles system prompts differently
    final fullPrompt = '$systemPrompt\n\nText to rewrite:\n$text';

    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': fullPrompt
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 1024,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        if (content != null && content['parts'] != null) {
          final parts = content['parts'] as List;
          if (parts.isNotEmpty && parts[0]['text'] != null) {
            return (parts[0]['text'] as String).trim();
          }
        }
      }
      throw Exception('Unexpected response format from API.');
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      final message = data['error']?['message'] ?? 'Bad request';
      throw Exception('API error: $message');
    } else if (response.statusCode == 403) {
      throw Exception('API key not valid or quota exceeded. Please check your Google AI Studio quota at https://aistudio.google.com');
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit reached. Please wait a moment and try again. Free tier: 1,500 requests per day.');
    } else {
      throw Exception('API error (${response.statusCode}): ${response.body}');
    }
  }
}