import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/rewriter_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env
  await dotenv.load(fileName: '.env');

  runApp(const AiRewriterApp());
}

class AiRewriterApp extends StatelessWidget {
  const AiRewriterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rewrite.AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const RewriterScreen(),
    );
  }
}
