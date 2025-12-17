import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Header widget for the example app
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Beautiful, customizable UI components with glassmorphism effects',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

