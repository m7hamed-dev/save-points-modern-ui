/// SavePoints Modern UI - Example Application
///
/// This example app demonstrates the capabilities of the SavePoints UI library,
/// showcasing dialogs, snackbars, and bottom sheets with various configurations.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/example/widgets/widgets.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/presets/dialog_presets.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Application entry point
void main() {
  runApp(const MyApp());
}

/// Root application widget with theme management
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  /// Changes the application theme mode
  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavePoints Modern UI',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      home: ExampleHomePage(onThemeChanged: _changeTheme),
    );
  }

  /// Builds the light theme configuration
  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      ),
    );
  }

  /// Builds the dark theme configuration
  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      ),
    );
  }
}

/// Constants for animation timings and delays
class _AnimationConstants {
  static const gradientDuration = Duration(seconds: 10);
  static const headerAnimationDuration = Duration(milliseconds: 800);
  static const sectionAnimationDuration = Duration(milliseconds: 600);
  static const sectionCount = 4;
  static const initialDelay = 300;
  static const staggerDelay = 150;
}

/// Constants for UI spacing
class _SpacingConstants {
  static const sectionSpacing = 24.0;
  static const headerBottomSpacing = 32.0;
  static const bottomSpacing = 32.0;
  static const contentPadding = 20.0;
}

/// Home page showcasing all SavePoints UI components
class ExampleHomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const ExampleHomePage({super.key, required this.onThemeChanged});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier<bool>(false);
  late AnimationController _gradientController;
  late AnimationController _headerController;
  late List<AnimationController> _sectionControllers;
  int _currentIndex = 0;

  /// The new bold variants the AppBar switcher cycles through.
  static const List<ContentDesignStyle> _switchableVariants = [
    ContentDesignStyle.glass,
    ContentDesignStyle.neon,
    ContentDesignStyle.minimal,
  ];

  /// Currently selected variant shown by the AppBar switcher. Drives the global
  /// default style so feature demos (those without an explicit style) follow it,
  /// while the labelled style-showcase buttons keep their pinned styles.
  ContentDesignStyle _variant = ContentDesignStyle.glass;

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
    _startStaggeredAnimations();
    _applyVariant(_variant);
  }

  /// Makes [variant] the global default for snackbars, dialogs and bottom
  /// sheets so the feature demos follow the AppBar switcher.
  void _applyVariant(ContentDesignStyle variant) {
    SnackDiaBottomConfig().snackbar.defaultDesignStyle = variant;
    SnackDiaBottomConfig().dialog.defaultDesignStyle = variant;
    SavePointsBottomsheet.defaultDesignStyle = variant;
  }

  /// Initializes all animation controllers
  void _initializeAnimationControllers() {
    _gradientController = AnimationController(
      vsync: this,
      duration: _AnimationConstants.gradientDuration,
    )..repeat();

    _headerController = AnimationController(
      vsync: this,
      duration: _AnimationConstants.headerAnimationDuration,
    )..forward();

    _sectionControllers = List.generate(
      _AnimationConstants.sectionCount,
      (index) => AnimationController(
        vsync: this,
        duration: _AnimationConstants.sectionAnimationDuration,
      ),
    );
  }

  /// Starts section animations with staggered delays for smooth entrance
  void _startStaggeredAnimations() {
    for (int i = 0; i < _sectionControllers.length; i++) {
      Future.delayed(
        Duration(
          milliseconds:
              _AnimationConstants.initialDelay +
              (i * _AnimationConstants.staggerDelay),
        ),
        () {
          if (mounted) {
            _sectionControllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _loadingNotifier.dispose();
    _gradientController.dispose();
    _headerController.dispose();
    for (final controller in _sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SavePoints Modern UI',
          style: TextStyle(fontWeight: .bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: IconButton(
              key: ValueKey(_variant),
              icon: Icon(_variantIcon(_variant)),
              tooltip: '${_variantLabel(_variant)} — tap to switch variant',
              onPressed: _cycleVariant,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: IconButton(
              key: ValueKey(isDark),
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              onPressed: () {
                widget.onThemeChanged(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final angle = _gradientController.value * 2 * math.pi;
          return Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                startAngle: angle,
                endAngle: angle + math.pi * 2,
                colors: isDark
                    ? [
                        Colors.grey[900]!,
                        Colors.grey[800]!,
                        Colors.grey[900]!,
                        Colors.grey[800]!,
                      ]
                    : [
                        Colors.blue[50]!,
                        Colors.indigo[50]!,
                        Colors.purple[50]!,
                        Colors.blue[50]!,
                      ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const .all(_SpacingConstants.contentPadding),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(
                      height: _SpacingConstants.headerBottomSpacing,
                    ),
                    ..._buildAllSections(context),
                    const SizedBox(height: _SpacingConstants.bottomSpacing),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Builds all sections with proper spacing
  List<Widget> _buildAllSections(BuildContext context) {
    return [
      _buildSection(
        context,
        index: 0,
        title: '🎭 Dialogs',
        icon: Icons.chat_bubble_outline,
        children: _buildDialogExamples(context),
      ),
      const SizedBox(height: _SpacingConstants.sectionSpacing),
      _buildSection(
        context,
        index: 1,
        title: '🍞 Snackbars',
        icon: Icons.notifications_outlined,
        children: _buildSnackbarExamples(context),
      ),
      const SizedBox(height: _SpacingConstants.sectionSpacing),
      _buildSection(
        context,
        index: 2,
        title: '📱 Bottom Sheets',
        icon: Icons.call_to_action_outlined,
        children: _buildBottomSheetExamples(context),
      ),
      const SizedBox(height: _SpacingConstants.sectionSpacing),
      _buildSection(
        context,
        index: 3,
        title: '🎨 More Examples',
        icon: Icons.auto_awesome,
        children: _buildMoreExamples(context),
      ),
    ];
  }

  /// Builds the bottom navigation bar with snackbar feedback
  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _handleNavigationSelection,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'Dialogs',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'Snackbars',
        ),
        NavigationDestination(
          icon: Icon(Icons.call_to_action_outlined),
          selectedIcon: Icon(Icons.call_to_action),
          label: 'Sheets',
        ),
      ],
    );
  }

  /// Icon representing a switchable variant.
  IconData _variantIcon(ContentDesignStyle variant) {
    switch (variant) {
      case ContentDesignStyle.glass:
        return Icons.blur_on;
      case ContentDesignStyle.neon:
        return Icons.bolt;
      case ContentDesignStyle.minimal:
        return Icons.crop_square;
      case ContentDesignStyle.solid:
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.tonal:
        return Icons.style;
    }
  }

  /// Human-readable name for a switchable variant.
  String _variantLabel(ContentDesignStyle variant) {
    switch (variant) {
      case ContentDesignStyle.glass:
        return 'Glass';
      case ContentDesignStyle.neon:
        return 'Neon';
      case ContentDesignStyle.minimal:
        return 'Minimal';
      case ContentDesignStyle.solid:
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.tonal:
        return variant.name;
    }
  }

  /// Cycles glass → neon → minimal, updates the global default, and previews
  /// the newly selected variant.
  void _cycleVariant() {
    final next =
        _switchableVariants[(_switchableVariants.indexOf(_variant) + 1) %
            _switchableVariants.length];
    setState(() => _variant = next);
    _applyVariant(next);
    SavePointsSnackbar.show(
      context,
      title: '${_variantLabel(next)} variant',
      subtitle: 'Feature demos now use the ${_variantLabel(next)} style.',
      type: SnackbarType.info,
      designStyle: next,
    );
  }

  /// Handles navigation bar selection and shows appropriate snackbar
  void _handleNavigationSelection(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        SavePointsSnackbar.show(
          context,
          title: 'Home',
          subtitle: 'Welcome to SavePoints UI',
          type: SnackbarType.info,
        );
        break;
      case 1:
        SavePointsSnackbar.showSuccess(
          context,
          title: 'Dialogs',
          subtitle: 'Explore dialog examples',
        );
        break;
      case 2:
        SavePointsSnackbar.show(
          context,
          title: 'Snackbars',
          subtitle: 'Check out snackbar examples',
          type: SnackbarType.warning,
        );
        break;
      case 3:
        SavePointsSnackbar.show(
          context,
          title: 'Bottom Sheets',
          subtitle: 'View bottom sheet examples',
          type: SnackbarType.info,
        );
        break;
    }
  }

  /// Builds the animated header widget
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerController,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _headerController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: const ExampleHeader(),
      ),
    );
  }

  /// Builds an animated section with fade and slide transitions
  Widget _buildSection(
    BuildContext context, {
    required int index,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final controller = _sectionControllers[index];
    return FadeTransition(
      opacity: controller,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
            ),
        child: ExampleSection(title: title, icon: icon, children: children),
      ),
    );
  }

  /// Builds all dialog example buttons demonstrating various dialog types
  List<Widget> _buildDialogExamples(BuildContext context) {
    return [
      _buildActionButton(
        context,
        icon: Icons.format_paint,
        label: 'Dialog Solid',
        color: Colors.indigo,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Solid Style',
            message: 'Classic filled background with shadow.',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            designStyle: ContentDesignStyle.solid,
            confirmText: 'OK',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.outlined_flag,
        label: 'Dialog Outlined',
        color: Colors.indigo,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Outlined Style',
            message: 'Light background with colored border and dark text.',
            icon: Icons.info,
            iconColor: Theme.of(context).colorScheme.primary,
            designStyle: ContentDesignStyle.outlined,
            confirmText: 'OK',
            showCancelButton: true,
            cancelText: 'Cancel',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Color Header',
        color: Colors.green,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Done',
            message: 'The device has been created successfully.',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            designStyle: ContentDesignStyle.colorHeader,
            confirmText: 'Continue',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.blur_on,
        label: 'Dialog Glass',
        color: Colors.cyan,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Frosted Glass',
            message: 'Translucent surface over a backdrop blur with a '
                'hairline highlight border.',
            icon: Icons.ac_unit_rounded,
            iconColor: Colors.cyan,
            designStyle: ContentDesignStyle.glass,
            confirmText: 'Nice',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.bolt,
        label: 'Dialog Neon',
        color: Colors.purpleAccent,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Neon Glow',
            message: 'Deep near-black surface with a glowing accent border '
                'and an intense colored bloom.',
            icon: Icons.flash_on_rounded,
            iconColor: Colors.purpleAccent,
            designStyle: ContentDesignStyle.neon,
            confirmText: 'Whoa',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.crop_square,
        label: 'Dialog Minimal',
        color: Colors.blueGrey,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Minimal',
            message: 'Opaque surface, single hairline border, perfectly flat.',
            icon: Icons.remove_rounded,
            iconColor: Colors.blueGrey,
            designStyle: ContentDesignStyle.minimal,
            confirmText: 'OK',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.warning_amber,
        label: 'Color Header Cancel',
        color: Colors.red,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Cancel',
            message: 'Are you sure you want to cancel? This can\'t be undone.',
            icon: Icons.warning,
            iconColor: Colors.red,
            designStyle: ContentDesignStyle.colorHeader,
            confirmText: 'Continue',
            showCancelButton: true,
            cancelText: 'Go Back',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.star_rate,
        label: 'Rating Dialog',
        color: Colors.amber,
        onPressed: () {
          int rating = 0;
          SavePointsDialog.show(
            context,
            title: 'Rate Your Experience',
            message: 'How would you rate our service?',
            icon: Icons.star_rounded,
            iconColor: Colors.amber,
            designStyle: ContentDesignStyle.colorHeader,
            confirmText: 'Submit Rating',
            cancelText: 'Skip',
            showCancelButton: true,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 40,
                      ),
                      color: Colors.amber,
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                    );
                  }),
                );
              },
            ),
            onConfirm: () {
              if (rating > 0) {
                SavePointsSnackbar.showSuccess(
                  context,
                  title: 'Thank You!',
                  subtitle: 'You rated us $rating star${rating > 1 ? 's' : ''}',
                );
              }
            },
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.border_color,
        label: 'Left Accent',
        color: Colors.teal,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Left Accent Style',
            message: 'Dialog with a colored vertical bar on the left edge.',
            icon: Icons.check_circle_rounded,
            iconColor: Colors.teal,
            designStyle: ContentDesignStyle.leftAccent,
            confirmText: 'OK',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.tonality,
        label: 'Tonal',
        color: Colors.indigo,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Tonal Style',
            message: 'Material 3 filled tonal — light tinted background.',
            icon: Icons.info_rounded,
            iconColor: Colors.indigo,
            designStyle: ContentDesignStyle.tonal,
            confirmText: 'OK',
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.widgets_outlined,
        label: 'With Custom Child',
        color: Colors.deepPurple,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'User Information',
            message: 'Please fill in your details below:',
            icon: Icons.person_add,
            iconColor: Colors.deepPurple,
            confirmText: 'Submit',
            cancelText: 'Cancel',
            showCancelButton: true,
            child: Column(
              mainAxisSize: .min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            onConfirm: () {},
            onCancel: () {},
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.science,
        label: 'Simple Child Test',
        color: Colors.orange,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Child Test',
            message: 'Testing if child widget appears',
            icon: Icons.bug_report,
            iconColor: Colors.orange,
            confirmText: 'OK',
            child: Container(
              height: 100,
              color: Colors.yellow,
              alignment: Alignment.center,
              child: const Text(
                '🎉 CHILD IS VISIBLE! 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: .bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.info_outline,
        label: 'Info Dialog',
        color: Colors.blue,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Information',
            message:
                'This is an informational dialog with a custom icon and message.',
            icon: Icons.info,
            iconColor: Colors.blue,
            onConfirm: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dialog confirmed!')),
              );
            },
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.check_circle_outline,
        label: 'Success',
        color: Colors.green,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Success!',
            message: 'Your action has been completed successfully.',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            confirmText: 'Great!',
            onConfirm: () {},
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.warning_amber_outlined,
        label: 'Confirmation',
        color: Colors.orange,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Confirm Action',
            message:
                'Are you sure you want to proceed? This action cannot be undone.',
            icon: Icons.warning,
            iconColor: Colors.orange,
            confirmText: 'Yes, Continue',
            cancelText: 'Cancel',
            showCancelButton: true,
            onConfirm: () {
              SavePointsSnackbar.showSuccess(
                context,
                title: 'Confirmed!',
                subtitle: 'Action has been completed',
              );
            },
            onCancel: () {
              SavePointsSnackbar.show(
                context,
                title: 'Cancelled',
                subtitle: 'Action was cancelled',
                type: SnackbarType.info,
              );
            },
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.error_outline,
        label: 'Error',
        color: Colors.red,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Error',
            message: 'Something went wrong. Please try again later.',
            icon: Icons.error,
            iconColor: Colors.red,
            confirmText: 'OK',
            onConfirm: () {},
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.hourglass_empty,
        label: 'Async Loading',
        color: Colors.purple,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Processing',
            message: 'Please wait while we process your request...',
            loadingNotifier: _loadingNotifier,
            onConfirmAsync: () async {
              _loadingNotifier.value = true;
              await Future.delayed(const Duration(seconds: 3));
              _loadingNotifier.value = false;
              return true; // Close dialog on success
            },
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.animation,
        label: 'Animated',
        color: Colors.indigo,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Animated Dialog',
            message: 'This dialog has custom enter and exit animations!',
            startAnimation: DialogAnimationDirection.fromLeft,
            endAnimation: DialogAnimationDirection.fromRight,
            icon: Icons.celebration,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.delete_outline,
        label: 'Delete Confirm',
        color: Colors.red,
        onPressed: () async {
          final result = await DialogPresets.showDeleteConfirmation(
            context,
            itemName: 'Document',
          );
          if (result == true && context.mounted) {
            SavePointsSnackbar.showSuccess(
              context,
              title: 'Deleted!',
              subtitle: 'Document has been deleted',
            );
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.logout,
        label: 'Logout',
        color: Colors.orange,
        onPressed: () async {
          final result = await DialogPresets.showLogoutConfirmation(context);
          if (result == true && context.mounted) {
            SavePointsSnackbar.show(
              context,
              title: 'Logged Out',
              subtitle: 'You have been logged out successfully',
              type: SnackbarType.info,
            );
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.system_update,
        label: 'Update',
        color: Colors.green,
        onPressed: () async {
          final result = await DialogPresets.showUpdateAvailable(
            context,
            version: '2.0.0',
          );
          if (result == true && context.mounted) {
            SavePointsSnackbar.show(
              context,
              title: 'Updating...',
              subtitle: 'Downloading update version 2.0.0',
              type: SnackbarType.info,
              duration: const Duration(seconds: 2),
            );
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.construction,
        label: 'Not Available',
        color: Colors.amber,
        onPressed: () {
          DialogPresets.showFeatureNotAvailable(context);
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.cancel_outlined,
        label: 'Discard',
        color: Colors.deepOrange,
        onPressed: () async {
          final result = await DialogPresets.showDiscardChangesConfirmation(
            context,
          );
          if (result == true && context.mounted) {
            SavePointsSnackbar.show(
              context,
              title: 'Discarded',
              subtitle: 'Changes have been discarded',
              type: SnackbarType.warning,
            );
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.scale,
        label: 'Scale',
        color: Colors.teal,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Scale Animation',
            message: 'This dialog uses scale animation!',
            startAnimation: DialogAnimationDirection.scale,
            endAnimation: DialogAnimationDirection.scale,
            icon: Icons.zoom_in,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.sports_volleyball,
        label: 'Bounce',
        color: Colors.pink,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Bounce Animation',
            message: 'This dialog bounces when appearing!',
            startAnimation: DialogAnimationDirection.bounce,
            endAnimation: DialogAnimationDirection.bounce,
            icon: Icons.sports_volleyball,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.blur_on,
        label: 'Blur + Animated',
        color: Colors.cyan,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Glassmorphism',
            message:
                'Custom backdrop blur with slide animation. Frosted glass effect!',
            blur: 24.0,
            startAnimation: DialogAnimationDirection.fromBottom,
            endAnimation: DialogAnimationDirection.fromTop,
            icon: Icons.blur_on,
            iconColor: Colors.cyan,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.credit_card,
        label: 'Header Dialog',
        color: const Color(0xFF2D1B69),
        onPressed: () {
          SavePointsDialog.showCustom(
            context: context,
            headerTitle: 'Payment Confirmation',
            headerColor: const Color(0xFF2D1B69),
            primaryButtonText: 'Confirm',
            secondaryButtonText: 'Change Plan',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '4 Installments',
                  style: TextStyle(fontSize: 18, fontWeight: .bold),
                ),
                const SizedBox(height: 16),
                const _PaymentItem(
                  amount: '\$54.04',
                  label: 'Due Today',
                  isActive: true,
                ),
                const _PaymentItem(amount: '\$54.01', date: 'Feb 19'),
                const _PaymentItem(amount: '\$54.01', date: 'Mar 19'),
                const _PaymentItem(amount: '\$54.01', date: 'Apr 19'),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(fontWeight: .bold, fontSize: 16),
                        ),
                        Text(
                          'Including \$2.47 fees',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '\$216.07',
                      style: TextStyle(fontSize: 20, fontWeight: .bold),
                    ),
                  ],
                ),
              ],
            ),
            onPrimaryPressed: () {
              Navigator.pop(context);
              SavePointsSnackbar.showSuccess(
                context,
                title: 'Payment Confirmed!',
                subtitle: 'Your payment has been processed',
              );
            },
          );
        },
      ),
    ];
  }

  /// Builds all snackbar example buttons demonstrating various snackbar types
  List<Widget> _buildSnackbarExamples(BuildContext context) {
    return [
      _buildActionButton(
        context,
        icon: Icons.format_paint,
        label: 'Toast Solid',
        color: Colors.indigo,
        onPressed: () {
          SavePointsSnackbar.showSuccess(
            context,
            title: 'Yuhu! Download Success',
            subtitle: 'Lorem ipsum dolor sit amet...',
            designStyle: ContentDesignStyle.solid,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.outlined_flag,
        label: 'Toast Outlined',
        color: Colors.indigo,
        onPressed: () {
          SavePointsSnackbar.showSuccess(
            context,
            title: 'Yuhu! Download Success',
            subtitle: 'Lorem ipsum dolor sit amet...',
            designStyle: ContentDesignStyle.outlined,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.error_outline,
        label: 'Error Outlined',
        color: Colors.red,
        onPressed: () {
          SavePointsSnackbar.showError(
            context,
            title: 'Oops! Error System',
            subtitle: 'Lorem ipsum dolor sit amet...',
            designStyle: ContentDesignStyle.outlined,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.warning_amber_outlined,
        label: 'Warning Outlined',
        color: Colors.orange,
        onPressed: () {
          SavePointsSnackbar.showWarning(
            context,
            title: 'Warning: System Disruption',
            subtitle: 'Lorem ipsum dolor sit amet...',
            designStyle: ContentDesignStyle.outlined,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.info_outline,
        label: 'Info Outlined',
        color: Colors.blue,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Update Found',
            subtitle: 'Lorem ipsum dolor sit amet...',
            type: SnackbarType.info,
            designStyle: ContentDesignStyle.outlined,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Color Header Success',
        color: Colors.green,
        onPressed: () {
          SavePointsSnackbar.showSuccess(
            context,
            title: 'Done',
            subtitle: 'The device has been created successfully.',
            designStyle: ContentDesignStyle.colorHeader,
            position: SnackbarPosition.top,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Color Header Error',
        color: Colors.red,
        onPressed: () {
          SavePointsSnackbar.showError(
            context,
            title: 'Cancel',
            subtitle: 'Are you sure you want to cancel? This can\'t be undone.',
            designStyle: ContentDesignStyle.colorHeader,
            position: SnackbarPosition.top,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Color Header Warning',
        color: Colors.orange,
        onPressed: () {
          SavePointsSnackbar.showWarning(
            context,
            title: 'Warning',
            subtitle: 'Please review your changes before proceeding.',
            designStyle: ContentDesignStyle.colorHeader,
            position: SnackbarPosition.top,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.border_color,
        label: 'Left Accent',
        color: Colors.teal,
        onPressed: () {
          SavePointsSnackbar.showSuccess(
            context,
            title: 'Left Accent',
            subtitle: 'Snackbar with a colored bar on the left.',
            designStyle: ContentDesignStyle.leftAccent,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.blur_on,
        label: 'Toast Glass',
        color: Colors.cyan,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Frosted Glass',
            subtitle: 'Translucent surface over a backdrop blur.',
            type: SnackbarType.info,
            designStyle: ContentDesignStyle.glass,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.bolt,
        label: 'Toast Neon',
        color: Colors.purpleAccent,
        onPressed: () {
          SavePointsSnackbar.showSuccess(
            context,
            title: 'Neon Glow',
            subtitle: 'Dark surface with a glowing accent border.',
            designStyle: ContentDesignStyle.neon,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.crop_square,
        label: 'Toast Minimal',
        color: Colors.blueGrey,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Minimal',
            subtitle: 'Hairline border, flat — clean and quiet.',
            type: SnackbarType.info,
            designStyle: ContentDesignStyle.minimal,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.tonality,
        label: 'Tonal',
        color: Colors.indigo,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Tonal Style',
            subtitle: 'Light tinted background, dark text.',
            type: SnackbarType.info,
            designStyle: ContentDesignStyle.tonal,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.notifications_none,
        label: 'Basic',
        color: Colors.blue,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Basic Snackbar',
            subtitle: 'Simple notification example',
            type: SnackbarType.info,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.check_circle_outline,
        label: 'Success',
        color: Colors.green,
        onPressed: () {
          SavePointsSnackbar.showSuccess(
            context,
            title: 'Success!',
            subtitle: 'Operation completed successfully',
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.error_outline,
        label: 'Error',
        color: Colors.red,
        onPressed: () {
          SavePointsSnackbar.showError(
            context,
            title: 'Error',
            subtitle: 'Failed to complete operation',
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.warning_amber_outlined,
        label: 'Warning',
        color: Colors.orange,
        onPressed: () {
          SavePointsSnackbar.showWarning(
            context,
            title: 'Warning',
            subtitle: 'Low balance remaining',
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.vertical_align_top,
        label: 'Top Position',
        color: Colors.teal,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Top Snackbar',
            subtitle: 'Displayed at the top of the screen',
            position: SnackbarPosition.top,
            showProgressIndicator: true,
            startAnimation: SnackbarAnimationDirection.fromTop,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Gradient',
        color: Colors.purple,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Gradient Snackbar',
            subtitle: 'Beautiful gradient background',
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.animation,
        label: 'Bounce',
        color: Colors.pink,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Bounce Animation',
            subtitle: 'Custom bounce effect',
            animation: SnackbarAnimation.bounce,
            type: SnackbarType.success,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.rotate_right,
        label: 'Slide Rotate',
        color: Colors.cyan,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Slide Rotate',
            subtitle: 'Combined animation effect',
            animation: SnackbarAnimation.slideRotate,
            type: SnackbarType.info,
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.touch_app,
        label: 'Tap to Dismiss',
        color: Colors.deepPurple,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Tap to Dismiss',
            subtitle: 'Touch anywhere to close',
            dismissOnTap: true,
            type: SnackbarType.info,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.border_color,
        label: 'Bordered',
        color: Colors.amber,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Bordered Snackbar',
            subtitle: 'With custom border styling',
            borderColor: Colors.orange,
            borderWidth: 2,
            borderRadius: .circular(12),
            type: SnackbarType.warning,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.trending_up,
        label: 'Elastic',
        color: Colors.lime,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Elastic Animation',
            subtitle: 'Smooth elastic effect',
            animation: SnackbarAnimation.elastic,
            type: SnackbarType.success,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.swap_horiz,
        label: 'Custom Direction',
        color: Colors.indigo,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Custom Animation',
            subtitle: 'Slides in from left',
            startAnimation: SnackbarAnimationDirection.fromLeft,
            endAnimation: SnackbarAnimationDirection.fromRight,
            type: SnackbarType.info,
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.blur_on,
        label: 'Blur + Bounce',
        color: Colors.cyan,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Glassmorphism Snackbar',
            subtitle: 'Backdrop blur with bounce animation',
            blur: 12.0,
            animation: SnackbarAnimation.bounce,
            type: SnackbarType.info,
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.timer,
        label: 'Long Duration',
        color: Colors.blueGrey,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Long Duration',
            subtitle: 'This snackbar stays for 8 seconds',
            duration: const Duration(seconds: 8),
            type: SnackbarType.info,
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.palette,
        label: 'Custom Colors',
        color: Colors.indigo,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Custom Colors',
            subtitle: 'Snackbar with gradient colors',
            gradient: LinearGradient(
              colors: [Colors.indigo[900]!, Colors.indigo[700]!],
            ),
            type: SnackbarType.info,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.scale,
        label: 'Scale Anim',
        color: Colors.teal,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Scale Animation',
            subtitle: 'Scales in and out smoothly',
            startAnimation: SnackbarAnimationDirection.scale,
            endAnimation: SnackbarAnimationDirection.scale,
            type: SnackbarType.success,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.opacity,
        label: 'Fade',
        color: Colors.grey,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Fade Animation',
            subtitle: 'Smooth fade in and out',
            startAnimation: SnackbarAnimationDirection.fade,
            endAnimation: SnackbarAnimationDirection.fade,
            type: SnackbarType.info,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.rotate_right,
        label: 'Rotate Scale',
        color: Colors.deepPurple,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Rotate Scale',
            subtitle: 'Combined rotation and scale',
            startAnimation: SnackbarAnimationDirection.rotateScale,
            endAnimation: SnackbarAnimationDirection.rotateScale,
            type: SnackbarType.success,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.notifications_active,
        label: 'Persistent',
        color: Colors.cyan,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Persistent',
            subtitle: 'Tap to dismiss (10 seconds)',
            duration: const Duration(seconds: 10),
            dismissOnTap: true,
            type: SnackbarType.warning,
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.color_lens,
        label: 'Rainbow',
        color: Colors.purple,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Rainbow Gradient',
            subtitle: 'Beautiful multi-color gradient',
            gradient: const LinearGradient(
              colors: [
                Color(0xFFff6b6b),
                Color(0xFFfeca57),
                Color(0xFF48dbfb),
                Color(0xFFff9ff3),
                Color(0xFF54a0ff),
              ],
            ),
            showProgressIndicator: true,
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.motion_photos_off,
        label: 'Dismiss Animation',
        color: Colors.deepOrange,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Animated Dismiss',
            subtitle: 'Tap close button or swipe to see exit animation',
            type: SnackbarType.info,
            animation: SnackbarAnimation.bounce,
            designStyle: ContentDesignStyle.outlined,
            duration: const Duration(seconds: 10),
          );
        },
      ),
    ];
  }

  /// Builds all bottom sheet example buttons demonstrating various bottom sheet types
  List<Widget> _buildBottomSheetExamples(BuildContext context) {
    return [
      _buildActionButton(
        context,
        icon: Icons.format_paint,
        label: 'Sheet Solid',
        color: Colors.indigo,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Solid Style',
            designStyle: ContentDesignStyle.solid,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Classic filled background with shadow. '
                'The default bottom sheet style.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.outlined_flag,
        label: 'Sheet Outlined',
        color: Colors.indigo,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Outlined Style',
            designStyle: ContentDesignStyle.outlined,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Light background with colored border and dark text. '
                'Clean, minimal look.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Color Header',
        color: Colors.green,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Success',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            designStyle: ContentDesignStyle.colorHeader,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Card style with colored header gradient, centered icon in circle, '
                'and modern design. Perfect for success states and confirmations.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.gradient,
        label: 'Color Header Info',
        color: Colors.blue,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Information',
            icon: Icons.info,
            iconColor: Colors.blue,
            designStyle: ContentDesignStyle.colorHeader,
            child: Column(
              mainAxisSize: .min,
              children: [
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('View Details'),
                  subtitle: const Text('See more information'),
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  subtitle: const Text('Share with others'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.border_color,
        label: 'Left Accent',
        color: Colors.teal,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Left Accent Sheet',
            icon: Icons.check_circle_rounded,
            iconColor: Colors.teal,
            designStyle: ContentDesignStyle.leftAccent,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Bottom sheet with a colored vertical bar on the left.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.tonality,
        label: 'Tonal',
        color: Colors.indigo,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Tonal Sheet',
            icon: Icons.info_rounded,
            iconColor: Colors.indigo,
            designStyle: ContentDesignStyle.tonal,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Material 3 tonal style — light tinted surface.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.blur_on,
        label: 'Sheet Glass',
        color: Colors.cyan,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Frosted Glass',
            icon: Icons.ac_unit_rounded,
            iconColor: Colors.cyan,
            designStyle: ContentDesignStyle.glass,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Translucent surface over a backdrop blur with a hairline '
                'highlight border.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.bolt,
        label: 'Sheet Neon',
        color: Colors.purpleAccent,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Neon Glow',
            icon: Icons.flash_on_rounded,
            iconColor: Colors.purpleAccent,
            designStyle: ContentDesignStyle.neon,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Deep near-black surface with a glowing accent border and an '
                'intense colored bloom.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.crop_square,
        label: 'Sheet Minimal',
        color: Colors.blueGrey,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Minimal',
            icon: Icons.remove_rounded,
            iconColor: Colors.blueGrey,
            designStyle: ContentDesignStyle.minimal,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Opaque surface, single hairline border, perfectly flat.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.vertical_align_bottom,
        label: 'Basic',
        color: Colors.blue,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Bottom Sheet',
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'This is a modern bottom sheet with glassmorphism design. '
                'It features beautiful backdrop blur effects and smooth animations.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.list,
        label: 'Options Menu',
        color: Colors.green,
        onPressed: () {
          SavePointsBottomsheet.show(
            maxHeight: 1222.8,
            context: context,
            title: 'Options',
            icon: Icons.more_vert,
            child: Column(
              mainAxisSize: .min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  subtitle: const Text('Modify this item'),
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  subtitle: const Text('Share with others'),
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Remove this item permanently'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.animation,
        label: 'Animated',
        color: Colors.purple,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Animated Bottom Sheet',
            startAnimation: BottomsheetAnimationDirection.fromLeft,
            endAnimation: BottomsheetAnimationDirection.fromRight,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'This bottom sheet slides in from the left and exits to the right.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.hourglass_empty,
        label: 'Loading',
        color: Colors.orange,
        onPressed: () {
          final loadingNotifier = ValueNotifier<bool>(false);
          SavePointsBottomsheet.show(
            context: context,
            title: 'Loading Data',
            loadingNotifier: loadingNotifier,
            child: const SizedBox(),
          );

          // Simulate loading
          Future.delayed(const Duration(milliseconds: 500), () {
            loadingNotifier.value = true;
            Future.delayed(const Duration(seconds: 2), () {
              loadingNotifier.value = false;
              if (context.mounted) {
                Navigator.pop(context);
                SavePointsSnackbar.showSuccess(
                  context,
                  title: 'Loaded!',
                  subtitle: 'Data loaded successfully',
                );
              }
            });
          });
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.format_list_bulleted,
        label: 'Scrollable',
        color: Colors.teal,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Scrollable Content',
            icon: Icons.swap_vert,
            isScrollControlled: true,
            child: Column(
              mainAxisSize: .min,
              children: List.generate(
                15,
                (index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('This is item number ${index + 1}'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.settings,
        label: 'Settings',
        color: Colors.indigo,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Settings',
            icon: Icons.settings,
            child: Column(
              mainAxisSize: .min,
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive push notifications'),
                  value: true,
                  onChanged: (_) {},
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  value: false,
                  onChanged: (_) {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.blur_on,
        label: 'Blur + Animated',
        color: Colors.cyan,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Glassmorphism',
            icon: Icons.blur_on,
            iconColor: Colors.cyan,
            blur: 16.0,
            startAnimation: BottomsheetAnimationDirection.fromBottom,
            endAnimation: BottomsheetAnimationDirection.fade,
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'Backdrop blur with slide animation. Frosted glass effect behind the sheet!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    ];
  }

  /// Builds advanced example buttons demonstrating component interactions
  List<Widget> _buildMoreExamples(BuildContext context) {
    return [
      _buildActionButton(
        context,
        icon: Icons.auto_awesome,
        label: 'Dialog Chain',
        color: Colors.purple,
        onPressed: () async {
          final result = await SavePointsDialog.show(
            context,
            title: 'First Dialog',
            message: 'This is the first dialog in a chain',
            icon: Icons.arrow_forward,
            confirmText: 'Next',
            onConfirm: () {},
          );
          if (result == true && context.mounted) {
            await Future.delayed(const Duration(milliseconds: 500));
            if (context.mounted) {
              SavePointsDialog.show(
                context,
                title: 'Second Dialog',
                message: 'This is the second dialog!',
                icon: Icons.check_circle,
                iconColor: Colors.green,
              );
            }
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.queue,
        label: 'Snackbar Queue',
        color: Colors.blue,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'First',
            subtitle: 'First snackbar',
            type: SnackbarType.info,
            duration: const Duration(seconds: 2),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              SavePointsSnackbar.showSuccess(
                context,
                title: 'Second',
                subtitle: 'Second snackbar',
                duration: const Duration(seconds: 2),
              );
            }
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (context.mounted) {
              SavePointsSnackbar.show(
                context,
                title: 'Third',
                subtitle: 'Third snackbar',
                type: SnackbarType.warning,
                duration: const Duration(seconds: 2),
              );
            }
          });
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.integration_instructions,
        label: 'Dialog → Snackbar',
        color: Colors.teal,
        onPressed: () async {
          final result = await SavePointsDialog.show(
            context,
            title: 'Confirm Action',
            message: 'Do you want to proceed?',
            showCancelButton: true,
            icon: Icons.question_mark,
            onConfirm: () {},
          );
          if (context.mounted) {
            if (result == true) {
              SavePointsSnackbar.showSuccess(
                context,
                title: 'Confirmed!',
                subtitle: 'Action has been completed',
              );
            } else {
              SavePointsSnackbar.show(
                context,
                title: 'Cancelled',
                subtitle: 'Action was cancelled',
                type: SnackbarType.info,
              );
            }
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.open_in_browser,
        label: 'Sheet → Dialog',
        color: Colors.orange,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Choose Action',
            child: Column(
              mainAxisSize: .min,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Item'),
                  onTap: () {
                    final navigatorContext = context;
                    Navigator.pop(navigatorContext);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (navigatorContext.mounted) {
                        DialogPresets.showDeleteConfirmation(navigatorContext);
                      }
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Item'),
                  onTap: () {
                    final navigatorContext = context;
                    Navigator.pop(navigatorContext);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (navigatorContext.mounted) {
                        SavePointsDialog.show(
                          navigatorContext,
                          title: 'Edit Item',
                          message: 'Edit dialog would appear here',
                          icon: Icons.edit,
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.celebration,
        label: 'Success Flow',
        color: Colors.green,
        onPressed: () async {
          final loadingNotifier = ValueNotifier<bool>(false);
          SavePointsDialog.show(
            context,
            title: 'Processing',
            message: 'Please wait...',
            loadingNotifier: loadingNotifier,
            onConfirmAsync: () async {
              loadingNotifier.value = true;
              await Future.delayed(const Duration(seconds: 2));
              loadingNotifier.value = false;
              return true;
            },
          );
          await Future.delayed(const Duration(milliseconds: 2500));
          if (context.mounted) {
            SavePointsSnackbar.showSuccess(
              context,
              title: 'Success!',
              subtitle: 'Operation completed successfully',
            );
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.error_outline,
        label: 'Error Flow',
        color: Colors.red,
        onPressed: () async {
          final loadingNotifier = ValueNotifier<bool>(false);
          SavePointsDialog.show(
            context,
            title: 'Processing',
            message: 'Attempting operation...',
            loadingNotifier: loadingNotifier,
            onConfirmAsync: () async {
              loadingNotifier.value = true;
              await Future.delayed(const Duration(seconds: 2));
              loadingNotifier.value = false;
              // Simulate error
              return false;
            },
          );
          await Future.delayed(const Duration(milliseconds: 2500));
          if (context.mounted) {
            SavePointsSnackbar.showError(
              context,
              title: 'Error',
              subtitle: 'Operation failed. Please try again.',
            );
          }
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.auto_stories,
        label: 'Story Flow',
        color: Colors.pink,
        onPressed: () async {
          // Step 1: Info dialog
          await SavePointsDialog.show(
            context,
            title: 'Welcome!',
            message: 'Let\'s explore the features',
            icon: Icons.waving_hand,
            confirmText: 'Continue',
          );
          if (!context.mounted) return;

          await Future.delayed(const Duration(milliseconds: 500));
          // Step 2: Success snackbar
          if (context.mounted) {
            SavePointsSnackbar.showSuccess(
              context,
              title: 'Great!',
              subtitle: 'Moving to next step',
              duration: const Duration(seconds: 2),
            );
          }

          await Future.delayed(const Duration(milliseconds: 2500));
          if (!context.mounted) return;

          // Step 3: Bottom sheet
          SavePointsBottomsheet.show(
            context: context,
            title: 'Final Step',
            child: const Padding(
              padding: .all(24.0),
              child: Text(
                'This completes the story flow!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      _buildActionButton(
        context,
        icon: Icons.speed,
        label: 'Quick Actions',
        color: Colors.cyan,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Quick Actions',
            child: Column(
              mainAxisSize: .min,
              children: [
                ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Show Success'),
                  onTap: () {
                    Navigator.pop(context);
                    SavePointsSnackbar.showSuccess(
                      context,
                      title: 'Quick Success!',
                      subtitle: 'Action completed',
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Show Info'),
                  onTap: () {
                    Navigator.pop(context);
                    SavePointsSnackbar.show(
                      context,
                      title: 'Quick Info',
                      subtitle: 'Here is some information',
                      type: SnackbarType.info,
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.chat_bubble),
                  title: const Text('Show Dialog'),
                  onTap: () {
                    Navigator.pop(context);
                    SavePointsDialog.show(
                      context,
                      title: 'Quick Dialog',
                      message: 'This is a quick dialog example',
                      icon: Icons.flash_on,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  /// Builds a reusable action button for examples
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ExampleActionButton(
      icon: icon,
      label: label,
      color: color,
      onPressed: onPressed,
    );
  }
}

/// Payment item widget for HeaderDialog example
class _PaymentItem extends StatelessWidget {
  const _PaymentItem({
    required this.amount,
    this.label,
    this.date,
    this.isActive = false,
  });

  final String amount;
  final String? label;
  final String? date;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF2D1B69) : Colors.grey[300],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label ?? date ?? '',
              style: TextStyle(
                color: isActive ? const Color(0xFF2D1B69) : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: isActive ? .bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
