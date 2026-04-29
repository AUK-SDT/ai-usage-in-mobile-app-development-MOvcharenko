import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatefulWidget {
  final String originalText;
  final String rewrittenText;
  final String modeLabel;

  const ResultCard({
    super.key,
    required this.originalText,
    required this.rewrittenText,
    required this.modeLabel,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.rewrittenText));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  int get _originalWords => widget.originalText.trim().split(RegExp(r'\s+')).length;
  int get _rewrittenWords => widget.rewrittenText.trim().split(RegExp(r'\s+')).length;

  int get _delta => _rewrittenWords - _originalWords;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.border, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.border, width: 1.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    widget.modeLabel,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppTheme.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$_rewrittenWords words  '
                  '${_delta >= 0 ? '+' : ''}$_delta',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    color: _delta < 0 ? AppTheme.accent : AppTheme.muted,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _copyToClipboard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _copied
                        ? Row(
                            key: const ValueKey('copied'),
                            children: [
                              const Icon(Icons.check, size: 14, color: AppTheme.accent),
                              const SizedBox(width: 4),
                              Text(
                                'COPIED',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 11,
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('copy'),
                            children: [
                              const Icon(Icons.copy, size: 14, color: AppTheme.muted),
                              const SizedBox(width: 4),
                              Text(
                                'COPY',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 11,
                                  color: AppTheme.muted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.rewrittenText,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 14,
                color: AppTheme.ink,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0, duration: 300.ms);
  }
}
