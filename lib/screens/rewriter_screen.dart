import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ai_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mode_selector_widget.dart';
import '../widgets/result_card.dart';

class RewriterScreen extends StatefulWidget {
  const RewriterScreen({super.key});

  @override
  State<RewriterScreen> createState() => _RewriterScreenState();
}

class _RewriterScreenState extends State<RewriterScreen> {
  final _controller = TextEditingController();
  final _service = AIService();
  final _scrollController = ScrollController();

  RewriteMode _selectedMode = RewriteMode.clearer;
  bool _isLoading = false;
  String? _result;
  String? _error;
  String _lastOriginal = '';

  int get _wordCount {
    final text = _controller.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  Future<void> _rewrite() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
      _lastOriginal = text;
    });

    try {
      final result = await _service.rewrite(text, _selectedMode);
      setState(() {
        _result = result;
        _isLoading = false;
      });

      // Scroll to result
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = null;
      _error = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 20 : 40,
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader().animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 40),

                  // Mode selector
                  _buildSectionLabel('01 — CHOOSE MODE'),
                  const SizedBox(height: 12),
                  ModeSelectorWidget(
                    selectedMode: _selectedMode,
                    onModeChanged: (mode) => setState(() => _selectedMode = mode),
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 32),

                  // Input
                  _buildSectionLabel('02 — YOUR TEXT'),
                  const SizedBox(height: 12),
                  _buildTextInput().animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 20),

                  // Actions
                  _buildActions().animate().fadeIn(delay: 200.ms),

                  // Result / Error
                  if (_isLoading) ...[
                    const SizedBox(height: 32),
                    _buildLoading(),
                  ],

                  if (_error != null) ...[
                    const SizedBox(height: 24),
                    _buildError(),
                  ],

                  if (_result != null) ...[
                    const SizedBox(height: 32),
                    _buildSectionLabel('03 — REWRITTEN'),
                    const SizedBox(height: 12),
                    ResultCard(
                      originalText: _lastOriginal,
                      rewrittenText: _result!,
                      modeLabel: _selectedMode.label,
                    ),
                  ],

                  const SizedBox(height: 60),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'REWRITE.AI',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Make your\nwords work.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Paste any text. Choose how to transform it.\nGet a better version instantly.',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 14,
            color: AppTheme.muted,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AppTheme.muted,
      ),
    );
  }

  Widget _buildTextInput() {
    return Stack(
      children: [
        TextFormField(
          controller: _controller,
          maxLines: 8,
          minLines: 6,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.ibmPlexMono(
            fontSize: 14,
            color: AppTheme.ink,
            height: 1.6,
          ),
          decoration: InputDecoration(
            hintText: 'Paste or type your text here...',
            alignLabelWithHint: true,
          ),
        ),
        // Word count badge
        Positioned(
          right: 12,
          bottom: 12,
          child: Text(
            '$_wordCount words',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              color: AppTheme.muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final hasText = _controller.text.trim().isNotEmpty;

    return Row(
      children: [
        // Main rewrite button
        Expanded(
          child: GestureDetector(
            onTap: hasText && !_isLoading ? _rewrite : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: hasText && !_isLoading ? AppTheme.ink : AppTheme.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  _isLoading ? 'REWRITING...' : 'REWRITE  →',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        if (_result != null || _controller.text.isNotEmpty) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _clear,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                border: Border.all(color: AppTheme.border, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'CLEAR',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.muted,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.border, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Gemini is thinking...',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 13,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        border: Border.all(color: const Color(0xFFFFB5A7), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 13,
                color: const Color(0xFFB91C1C),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().shakeX(amount: 4);
  }


}
