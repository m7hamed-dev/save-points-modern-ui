import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/presets/dialog_presets.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/example/widgets/widgets.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: ExampleHomePage(onThemeChanged: _changeTheme),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // Create controllers for each section with staggered delays
    _sectionControllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    // Start section animations with stagger
    for (int i = 0; i < _sectionControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 150)), () {
        if (mounted) {
          _sectionControllers[i].forward();
        }
      });
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
          style: TextStyle(fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildSection(
                      context,
                      index: 0,
                      title: '🎭 Dialogs',
                      icon: Icons.chat_bubble_outline,
                      children: _buildDialogExamples(context),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      index: 1,
                      title: '🍞 Snackbars',
                      icon: Icons.notifications_outlined,
                      children: _buildSnackbarExamples(context),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      index: 2,
                      title: '📱 Bottom Sheets',
                      icon: Icons.call_to_action_outlined,
                      children: _buildBottomSheetExamples(context),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      index: 3,
                      title: '🎨 More Examples',
                      icon: Icons.auto_awesome,
                      children: _buildMoreExamples(context),
                    ),
                    const SizedBox(height: 32),
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

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
        // Show snackbar based on selection
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
      },
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

  List<Widget> _buildDialogExamples(BuildContext context) {
    return [
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
    ];
  }

  List<Widget> _buildSnackbarExamples(BuildContext context) {
    return [
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
            borderRadius: BorderRadius.circular(12),
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
    ];
  }

  List<Widget> _buildBottomSheetExamples(BuildContext context) {
    return [
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
              padding: EdgeInsets.all(24.0),
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
            context: context,
            title: 'Options',
            icon: Icons.more_vert,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
              padding: EdgeInsets.all(24.0),
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
              mainAxisSize: MainAxisSize.min,
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
              mainAxisSize: MainAxisSize.min,
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
    ];
  }

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
              mainAxisSize: MainAxisSize.min,
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
              padding: EdgeInsets.all(24.0),
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
              mainAxisSize: MainAxisSize.min,
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
