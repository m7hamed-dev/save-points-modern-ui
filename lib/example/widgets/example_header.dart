/// Example widgets for the SavePoints UI demo application
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated header widget displaying the app title and description
///
/// Features a rotating and scaling icon animation with gradient background.
class ExampleHeader extends StatefulWidget {
  const ExampleHeader({super.key});

  @override
  State<ExampleHeader> createState() => _ExampleHeaderState();
}

class _ExampleHeaderState extends State<ExampleHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _iconController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _iconController.value * 0.1 * math.pi,
                    child: Transform.scale(
                      scale: 1.0 + (_iconController.value * 0.1),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'SavePoints Modern UI',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Beautiful, customizable UI components with glassmorphism effects',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
