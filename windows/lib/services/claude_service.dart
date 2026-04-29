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

class ClaudeService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-sonnet-4-20250514';

  String get _apiKey {
    final key = dotenv.env['ANTHROPIC_API_KEY'] ?? '';
    if (key.isEmpty || key == 'your_api_key_here') {
      throw Exception('API key not configured. Please set ANTHROPIC_API_KEY in your .env file.');
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

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        // Required for browser/CORS contexts
        'anthropic-dangerous-direct-browser-access': 'true',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 1024,
        'system': systemPrompt,
        'messages': [
          {
            'role': 'user',
            'content': text,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['content'] as List;
      if (content.isNotEmpty && content[0]['type'] == 'text') {
        return content[0]['text'] as String;
      }
      throw Exception('Unexpected response format from API.');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key. Please check your .env file.');
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit reached. Please wait a moment and try again.');
    } else {
      final data = jsonDecode(response.body);
      final message = data['error']?['message'] ?? 'Unknown error';
      throw Exception('API error: $message');
    }
  }
}
