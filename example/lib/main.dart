import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

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
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
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
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
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

class _ExampleHomePageState extends State<ExampleHomePage> {
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _loadingNotifier.dispose();
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
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              widget.onThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[850]!]
                : [Colors.blue[50]!, Colors.indigo[50]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildSection(
                  context,
                  title: '🎭 Dialogs',
                  icon: Icons.chat_bubble_outline,
                  children: _buildDialogExamples(context),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: '🍞 Snackbars',
                  icon: Icons.notifications_outlined,
                  children: _buildSnackbarExamples(context),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: '📱 Bottom Sheets',
                  icon: Icons.call_to_action_outlined,
                  children: _buildBottomSheetExamples(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'SavePoints Modern UI',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: .center,
              runAlignment: .center,
              crossAxisAlignment: .center,
              children: children,
            ),
          ],
        ),
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
        icon: Icons.radio_button_unchecked,
        label: 'Circle Reveal',
        color: Colors.deepPurple,
        onPressed: () {
          SavePointsDialog.show(
            context,
            title: 'Circular Reveal',
            message: 'This dialog reveals/hides like a circle expanding!',
            hideLikeCircle: true,
            icon: Icons.radio_button_checked,
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
        icon: Icons.radio_button_unchecked,
        label: 'Circle Reveal',
        color: Colors.deepPurple,
        onPressed: () {
          SavePointsSnackbar.show(
            context,
            title: 'Circular Reveal',
            subtitle: 'Reveals like a circle expanding',
            hideLikeCircle: true,
            type: SnackbarType.info,
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
        icon: Icons.radio_button_unchecked,
        label: 'Circle Reveal',
        color: Colors.deepPurple,
        onPressed: () {
          SavePointsBottomsheet.show(
            context: context,
            title: 'Circular Reveal',
            hideLikeCircle: true,
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'This bottom sheet reveals/hides like a circle expanding!',
                style: TextStyle(fontSize: 16),
              ),
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
    return SizedBox(
      width: 140,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: .circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
