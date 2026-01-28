/// Example widgets for the SavePoints UI demo application
library;

import 'package:flutter/material.dart';

/// Section container widget for organizing example buttons
///
/// Displays a title with icon and wraps child widgets in a card layout
/// with hover effects and gradient backgrounds.
class ExampleSection extends StatefulWidget {
  /// Section title displayed in the header
  final String title;

  /// Icon displayed next to the title
  final IconData icon;

  /// List of child widgets (typically example buttons)
  final List<Widget> children;

  const ExampleSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  State<ExampleSection> createState() => _ExampleSectionState();
}

class _ExampleSectionState extends State<ExampleSection> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          elevation: _isHovered ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _isHovered
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        Theme.of(context).colorScheme.secondary.withValues(alpha: 0.02),
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.icon,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: widget.children,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

