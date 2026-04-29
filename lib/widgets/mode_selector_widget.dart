import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ai_service.dart';
import '../theme/app_theme.dart';

class ModeSelectorWidget extends StatelessWidget {
  final RewriteMode selectedMode;
  final ValueChanged<RewriteMode> onModeChanged;

  const ModeSelectorWidget({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RewriteMode.values.map((mode) {
        final isSelected = mode == selectedMode;
        return Expanded(
          child: GestureDetector(
            onTap: () => onModeChanged(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: mode != RewriteMode.values.last ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.ink : AppTheme.white,
                border: Border.all(
                  color: isSelected ? AppTheme.ink : AppTheme.border,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mode.emoji,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? AppTheme.white : AppTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mode.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: isSelected ? AppTheme.white : AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
