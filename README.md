# SavePoints Modern UI 🎨

<div align="center">
  <img src="https://raw.githubusercontent.com/yourusername/savepoints_modern_ui/main/banner.jpeg" alt="SavePoints Modern UI Banner" width="100%">
</div>

<div align="center">

[![pub package](https://img.shields.io/pub/v/savepoints_modern_ui.svg)](https://pub.dev/packages/savepoints_modern_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white)](https://flutter.dev)

</div>

> A comprehensive Flutter package providing elegant, customizable UI components with stunning glassmorphism effects, smooth animations, and extensive customization options. Perfect for building modern, professional user interfaces.

## 🌟 Overview

**SavePoints Modern UI** is a production-ready Flutter package that offers three powerful, feature-rich UI components:

- **🎭 Dialogs** - Beautiful modal dialogs with glassmorphism design
- **🍞 Snackbars** - Enhanced notifications with rich animations and customization
- **📱 Bottom Sheets** - Modern bottom sheets with drag handles and scroll support

All components feature automatic dark mode support, extensive customization options, and are optimized for performance with built-in repaint boundaries and efficient animations.

## ✨ Key Features

### 🎭 SavePointsDialog

- **✨ Glassmorphism Design** - Beautiful frosted glass effects with backdrop blur
- **🎨 Fully Customizable** - Colors, icons, buttons, and animations
- **⚡ Smooth Animations** - Multiple animation types including fade, slide, scale, bounce, and more
- **🌓 Dark Mode Support** - Automatic theme adaptation
- **📱 Loading States** - Built-in support for async operations with loading indicators
- **🎯 Flexible Actions** - Single or dual button configurations
- **📳 Haptic Feedback** - Enhanced user experience with tactile responses
- **🔄 Async Support** - Handle asynchronous confirm callbacks with loading states
- **⭕ Circular Reveal Animation** - Optional circular reveal/hide effect for dramatic transitions

### 🍞 SavePointsSnackbar

- **📊 Multiple Types** - Success, Error, Warning, and Info variants with predefined styling
- **🎬 Rich Animations** - 7+ animation types: fade, slide, scale, bounce, rotate, elastic, slideRotate
- **📈 Progress Indicators** - Optional progress bars for timed notifications
- **🎨 Gradient Backgrounds** - Support for custom gradient designs
- **📍 Position Control** - Display at top or bottom of screen with smart margin calculation
- **👆 Interactive** - Tap to dismiss, custom tap handlers, and action buttons
- **🎯 Customizable Styling** - Borders, border radius, margins, colors, and more
- **📳 Haptic Feedback** - Configurable haptic responses
- **⚡ Performance Optimized** - Efficient animations with clamped values
- **⭕ Circular Reveal Animation** - Optional circular reveal/hide effect for stunning transitions

### 📱 SavePointsBottomsheet

- **✨ Modern Design** - Glassmorphism effects with backdrop blur
- **🎚️ Drag Handle** - Optional drag indicator for better UX
- **📜 Scrollable Content** - Built-in support for scrollable content with proper constraints
- **⏳ Loading States** - Support for loading indicators during async operations
- **🎬 Custom Animations** - Flexible enter and exit animations
- **📏 Flexible Sizing** - Customizable max height and constraints
- **🌓 Dark Mode Support** - Automatic theme adaptation
- **🎯 Dismissible & Draggable** - Full control over user interactions
- **⭕ Circular Reveal Animation** - Optional circular reveal/hide effect for dramatic transitions

## 📦 Installation

Add `savepoints_modern_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  savepoints_modern_ui: ^1.0.0
```

Install the package:

```bash
flutter pub get
```

Import the package:

```dart
import 'package:savepoints_modern_ui/savepoints_modern_ui.dart';
```

## 🚀 Quick Start

### Basic Dialog

```dart
SavePointsDialog.show(
  context,
  title: 'Success',
  message: 'Your changes have been saved successfully!',
  icon: Icons.check_circle,
  iconColor: Colors.green,
  onConfirm: () {
    // Handle confirmation
  },
);
```

### Basic Snackbar

```dart
SavePointsSnackbar.showSuccess(
  context,
  title: 'Success!',
  subtitle: 'Operation completed successfully',
  showProgressIndicator: true,
);
```

### Basic Bottom Sheet

```dart
SavePointsBottomsheet.show(
  context: context,
  title: 'Options',
  icon: Icons.more_vert,
  child: YourContentWidget(),
);
```

## 📚 Complete Documentation

### 🎭 SavePointsDialog

#### Method Signature

```dart
static Future<bool?> show(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  IconData? icon,
  Color? iconColor,
  Color? backgroundColor,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
  bool? showCancelButton,
  VoidCallback? onConfirm,
  Future<bool> Function()? onConfirmAsync,
  VoidCallback? onCancel,
  bool? barrierDismissible,
  DialogAnimationType? animationType,
  DialogAnimationDirection? startAnimation,
  DialogAnimationDirection? endAnimation,
  bool isLoading = false,
  ValueNotifier<bool>? loadingNotifier,
  bool hideLikeCircle = false,
})
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | `String` | ✅ Yes | - | Dialog title text |
| `message` | `String` | ✅ Yes | - | Dialog message/body text |
| `confirmText` | `String?` | No | `"OK"` | Confirm button text |
| `cancelText` | `String?` | No | `"Cancel"` | Cancel button text |
| `icon` | `IconData?` | No | `null` | Optional icon displayed at the top |
| `iconColor` | `Color?` | No | Theme-based | Icon color |
| `backgroundColor` | `Color?` | No | Theme-based | Dialog background color |
| `confirmButtonColor` | `Color?` | No | Theme-based | Confirm button color |
| `cancelButtonColor` | `Color?` | No | `Colors.grey` | Cancel button color |
| `showCancelButton` | `bool?` | No | `false` | Show cancel button |
| `onConfirm` | `VoidCallback?` | No | `null` | Callback when confirm is pressed |
| `onConfirmAsync` | `Future<bool> Function()?` | No | `null` | Async callback returning bool (true = close dialog) |
| `onCancel` | `VoidCallback?` | No | `null` | Callback when cancel is pressed |
| `barrierDismissible` | `bool?` | No | `true` | Allow dismissing by tapping outside |
| `animationType` | `DialogAnimationType?` | No | `fadeSlide` | Animation type (legacy) |
| `startAnimation` | `DialogAnimationDirection?` | No | `null` | Enter animation direction |
| `endAnimation` | `DialogAnimationDirection?` | No | `null` | Exit animation direction |
| `isLoading` | `bool` | No | `false` | Initial loading state |
| `loadingNotifier` | `ValueNotifier<bool>?` | No | `null` | External loading state control |
| `hideLikeCircle` | `bool` | No | `false` | Enable circular reveal/hide animation |

#### Examples

**1. Info Dialog**

```dart
SavePointsDialog.show(
  context,
  title: 'Information',
  message: 'This is an informational dialog with a custom icon and message.',
  icon: Icons.info,
  iconColor: Colors.blue,
  onConfirm: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dialog confirmed!')),
    );
  },
);
```

**2. Success Dialog**

```dart
SavePointsDialog.show(
  context,
  title: 'Success!',
  message: 'Your action has been completed successfully.',
  icon: Icons.check_circle,
  iconColor: Colors.green,
  confirmText: 'Great!',
  onConfirm: () {},
);
```

**3. Confirmation Dialog**

```dart
SavePointsDialog.show(
  context,
  title: 'Confirm Action',
  message: 'Are you sure you want to proceed? This action cannot be undone.',
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
```

**4. Error Dialog**

```dart
SavePointsDialog.show(
  context,
  title: 'Error',
  message: 'Something went wrong. Please try again later.',
  icon: Icons.error,
  iconColor: Colors.red,
  confirmText: 'OK',
  onConfirm: () {},
);
```

**5. Dialog with Async Loading State**

```dart
final loadingNotifier = ValueNotifier<bool>(false);

SavePointsDialog.show(
  context,
  title: 'Processing',
  message: 'Please wait while we process your request...',
  isLoading: false,
  loadingNotifier: loadingNotifier,
  onConfirmAsync: () async {
    loadingNotifier.value = true;
    await Future.delayed(const Duration(seconds: 3));
    loadingNotifier.value = false;
    return true; // Close dialog on success
  },
);
```

**6. Custom Animation Dialog**

```dart
SavePointsDialog.show(
  context,
  title: 'Animated Dialog',
  message: 'This dialog has custom enter and exit animations!',
  startAnimation: DialogAnimationDirection.fromLeft,
  endAnimation: DialogAnimationDirection.fromRight,
  icon: Icons.celebration,
);
```

**7. Circular Reveal Dialog**

```dart
SavePointsDialog.show(
  context,
  title: 'Circular Reveal',
  message: 'This dialog reveals/hides like a circle expanding!',
  hideLikeCircle: true,
  icon: Icons.radio_button_checked,
);
```

### 🍞 SavePointsSnackbar

#### Method Signature

```dart
static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
  BuildContext context, {
  required String title,
  String? subtitle,
  Color? background,
  Gradient? gradient,
  Duration? duration,
  IconData? icon,
  Color? iconColor,
  VoidCallback? onActionPressed,
  String? actionLabel,
  SnackbarType? type,
  SnackbarPosition? position,
  SnackbarAnimation? animation,
  SnackbarAnimationDirection? startAnimation,
  SnackbarAnimationDirection? endAnimation,
  bool? showProgressIndicator,
  bool? dismissible,
  bool? enableHapticFeedback,
  bool? dismissOnTap,
  double? maxWidth,
  EdgeInsets? margin,
  BorderRadius? borderRadius,
  Color? borderColor,
  double? borderWidth,
  bool hideLikeCircle = false,
  VoidCallback? onDismissed,
  VoidCallback? onTap,
})
```

#### Quick Methods

- `showSuccess(context, {...})` - Success variant with green styling
- `showError(context, {...})` - Error variant with red styling
- `showWarning(context, {...})` - Warning variant with orange styling

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | `String` | ✅ Yes | - | Snackbar title text |
| `subtitle` | `String?` | No | `null` | Optional subtitle text |
| `type` | `SnackbarType?` | No | `info` | Type: `info`, `success`, `error`, `warning` |
| `position` | `SnackbarPosition?` | No | `bottom` | Position: `top` or `bottom` |
| `animation` | `SnackbarAnimation?` | No | `fadeSlide` | Animation type (legacy) |
| `startAnimation` | `SnackbarAnimationDirection?` | No | `null` | Enter animation direction |
| `endAnimation` | `SnackbarAnimationDirection?` | No | `null` | Exit animation direction |
| `duration` | `Duration?` | No | `4 seconds` | Display duration |
| `showProgressIndicator` | `bool?` | No | `false` | Show progress bar |
| `gradient` | `Gradient?` | No | `null` | Custom gradient background |
| `borderColor` | `Color?` | No | `null` | Border color |
| `borderWidth` | `double?` | No | `0` | Border width |
| `dismissOnTap` | `bool?` | No | `false` | Dismiss when tapped |
| `hideLikeCircle` | `bool` | No | `false` | Enable circular reveal/hide animation |
| `onTap` | `VoidCallback?` | No | `null` | Custom tap handler |
| `onDismissed` | `VoidCallback?` | No | `null` | Callback when dismissed |

#### Examples

**1. Basic Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Basic Snackbar',
  subtitle: 'Simple notification example',
  type: SnackbarType.info,
);
```

**2. Success Snackbar**

```dart
SavePointsSnackbar.showSuccess(
  context,
  title: 'Success!',
  subtitle: 'Operation completed successfully',
  showProgressIndicator: true,
);
```

**3. Error Snackbar**

```dart
SavePointsSnackbar.showError(
  context,
  title: 'Error',
  subtitle: 'Failed to complete operation',
  showProgressIndicator: true,
);
```

**4. Warning Snackbar**

```dart
SavePointsSnackbar.showWarning(
  context,
  title: 'Warning',
  subtitle: 'Low balance remaining',
  showProgressIndicator: true,
);
```

**5. Top Position Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Top Snackbar',
  subtitle: 'Displayed at the top of the screen',
  position: SnackbarPosition.top,
  showProgressIndicator: true,
  startAnimation: SnackbarAnimationDirection.fromTop,
);
```

**6. Gradient Snackbar with Progress**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Gradient Snackbar',
  subtitle: 'Beautiful gradient background',
  gradient: const LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  ),
  showProgressIndicator: true,
);
```

**7. Bounce Animation Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Bounce Animation',
  subtitle: 'Custom bounce effect',
  animation: SnackbarAnimation.bounce,
  type: SnackbarType.success,
);
```

**8. Slide Rotate Animation Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Slide Rotate',
  subtitle: 'Combined animation effect',
  animation: SnackbarAnimation.slideRotate,
  type: SnackbarType.info,
  showProgressIndicator: true,
);
```

**9. Tap to Dismiss Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Tap to Dismiss',
  subtitle: 'Touch anywhere to close',
  dismissOnTap: true,
  type: SnackbarType.info,
);
```

**10. Bordered Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Bordered Snackbar',
  subtitle: 'With custom border styling',
  borderColor: Colors.orange,
  borderWidth: 2,
  borderRadius: BorderRadius.circular(12),
  type: SnackbarType.warning,
);
```

**11. Elastic Animation Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Elastic Animation',
  subtitle: 'Smooth elastic effect',
  animation: SnackbarAnimation.elastic,
  type: SnackbarType.success,
);
```

**12. Custom Direction Animation Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Custom Animation',
  subtitle: 'Slides in from left',
  startAnimation: SnackbarAnimationDirection.fromLeft,
  endAnimation: SnackbarAnimationDirection.fromRight,
  type: SnackbarType.info,
  showProgressIndicator: true,
);
```

**13. Circular Reveal Snackbar**

```dart
SavePointsSnackbar.show(
  context,
  title: 'Circular Reveal',
  subtitle: 'Reveals like a circle expanding',
  hideLikeCircle: true,
  type: SnackbarType.info,
  showProgressIndicator: true,
);
```

### 📱 SavePointsBottomsheet

#### Method Signature

```dart
static Future<T?> show<T>({
  required BuildContext context,
  String? title,
  Widget? child,
  IconData? icon,
  Color? iconColor,
  Color? backgroundColor,
  bool? isDismissible,
  bool? enableDrag,
  bool? showHandle,
  double? maxHeight,
  bool isScrollControlled = false,
  BottomsheetAnimationDirection? startAnimation,
  BottomsheetAnimationDirection? endAnimation,
  bool isLoading = false,
  ValueNotifier<bool>? loadingNotifier,
  bool hideLikeCircle = false,
})
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | `String?` | No | `null` | Bottom sheet title |
| `child` | `Widget?` | No | `null` | Content widget |
| `icon` | `IconData?` | No | `null` | Optional icon next to title |
| `iconColor` | `Color?` | No | Theme-based | Icon color |
| `backgroundColor` | `Color?` | No | Theme-based | Background color |
| `isDismissible` | `bool?` | No | `true` | Allow dismissing by tapping outside |
| `enableDrag` | `bool?` | No | `true` | Enable drag to dismiss |
| `showHandle` | `bool?` | No | `true` | Show drag handle indicator |
| `maxHeight` | `double?` | No | `90% of screen` | Maximum height |
| `isScrollControlled` | `bool` | No | `false` | Enable scroll control |
| `startAnimation` | `BottomsheetAnimationDirection?` | No | `null` | Enter animation |
| `endAnimation` | `BottomsheetAnimationDirection?` | No | `null` | Exit animation |
| `isLoading` | `bool` | No | `false` | Initial loading state |
| `loadingNotifier` | `ValueNotifier<bool>?` | No | `null` | External loading control |
| `hideLikeCircle` | `bool` | No | `false` | Enable circular reveal/hide animation |

#### Examples

**1. Basic Bottom Sheet**

```dart
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
```

**2. Options Menu Bottom Sheet**

```dart
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
        title: const Text('Delete', style: TextStyle(color: Colors.red)),
        subtitle: const Text('Remove this item permanently'),
        onTap: () => Navigator.pop(context),
      ),
    ],
  ),
);
```

**3. Animated Bottom Sheet**

```dart
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
```

**4. Bottom Sheet with Loading State**

```dart
final loadingNotifier = ValueNotifier<bool>(false);

SavePointsBottomsheet.show(
  context: context,
  title: 'Loading Data',
  isLoading: false,
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
```

**5. Scrollable Bottom Sheet**

```dart
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
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text('Item ${index + 1}'),
        subtitle: Text('This is item number ${index + 1}'),
        onTap: () => Navigator.pop(context),
      ),
    ),
  ),
);
```

**6. Settings Bottom Sheet**

```dart
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
```

**7. Circular Reveal Bottom Sheet**

```dart
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
```

## 🎨 Animation Types

### Dialog Animations

**DialogAnimationType** (Legacy):
- `fadeSlide` - Fade with slide (default)
- `scale` - Scale animation
- `slideBottom` - Slide from bottom
- `slideTop` - Slide from top
- `slideLeft` - Slide from left
- `slideRight` - Slide from right
- `bounce` - Bounce animation
- `rotateScale` - Rotate with scale
- `elastic` - Elastic animation
- `none` - No animation

**DialogAnimationDirection** (New):
- `fromTop`, `fromBottom`, `fromLeft`, `fromRight` - Slide directions
- `fade` - Fade in/out
- `scale` - Scale animation
- `rotateScale` - Rotate with scale
- `bounce` - Bounce animation
- `elastic` - Elastic animation
- `none` - No animation

### Snackbar Animations

**SnackbarAnimation** (Legacy):
- `fadeSlide` - Fade with slide (default)
- `scale` - Scale animation
- `slide` - Slide animation
- `bounce` - Bounce animation
- `rotate` - Rotate animation
- `elastic` - Elastic animation
- `slideRotate` - Slide with rotate
- `none` - No animation

**SnackbarAnimationDirection** (New):
- `fromTop`, `fromBottom`, `fromLeft`, `fromRight` - Slide directions
- `fade` - Fade in/out
- `scale` - Scale animation
- `rotateScale` - Rotate with scale
- `bounce` - Bounce animation
- `elastic` - Elastic animation
- `none` - No animation

### Bottom Sheet Animations

**BottomsheetAnimationDirection**:
- `fromBottom` - Slide from bottom (default)
- `fromLeft` - Slide from left
- `fromRight` - Slide from right
- `fade` - Fade in/out
- `scale` - Scale animation
- `none` - No animation

### Circular Reveal Animation

All three components (Dialogs, Snackbars, and Bottom Sheets) support a special **Circular Reveal** animation through the `hideLikeCircle` parameter:

- **Circular Reveal** - When `hideLikeCircle: true`, the widget reveals/hides by expanding/contracting like a circle from the center
- Creates a dramatic circular reveal effect that's perfect for special moments
- Works independently of other animation types
- The circle expands from the center point to reveal the widget, and contracts back when hiding

## ⚙️ Configuration

SavePoints Modern UI provides a centralized configuration system through `SavePointsConfig`:

```dart
// Configure global defaults
SavePointsConfig.instance.snackbar
  ..defaultDuration = Duration(seconds: 5)
  ..defaultType = SnackbarType.info
  ..defaultShowProgressIndicator = true;

SavePointsConfig.instance.dialog
  ..defaultConfirmText = 'Continue'
  ..defaultShowCancelButton = true;
```

See the [Configuration Guide](https://github.com/yourusername/savepoints_modern_ui/wiki/Configuration) for more details.

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| iOS | ✅ Fully Supported |
| Android | ✅ Fully Supported |
| Web | ✅ Fully Supported |
| macOS | ✅ Fully Supported |
| Linux | ✅ Fully Supported |
| Windows | ✅ Fully Supported |

## 🎯 Performance

- **Repaint Boundaries** - Strategic use of `RepaintBoundary` widgets to minimize repaints
- **Cached Configurations** - Color configs and MediaQuery values are cached
- **Optimized Animations** - Clamped animations prevent overflow errors
- **Efficient Builds** - Widgets extracted to prevent unnecessary rebuilds

## 🔧 Running the Example

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/savepoints_modern_ui.git
   cd savepoints_modern_ui
   ```

2. Navigate to the example directory:
   ```bash
   cd example
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the example:
   ```bash
   flutter run
   ```

## 📖 Additional Resources

- [Full API Documentation](https://pub.dev/documentation/savepoints_modern_ui/latest/)
- [Example App](https://github.com/yourusername/savepoints_modern_ui/tree/main/example)
- [Issue Tracker](https://github.com/yourusername/savepoints_modern_ui/issues)

## 🤝 Contributing

Contributions are welcome and greatly appreciated! Before submitting a pull request, please ensure:

1. ✅ Code follows the existing style and conventions
2. ✅ All tests pass (`flutter test`)
3. ✅ Documentation is updated
4. ✅ No breaking changes (or properly documented)

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Inspired by modern UI/UX design principles
- Glassmorphism effects using Flutter's `BackdropFilter`
- Performance optimizations based on Flutter best practices

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/savepoints_modern_ui/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/savepoints_modern_ui/discussions)
- **Email**: support@savepoints.dev

---

<div align="center">

**Made with ❤️ by the SavePoints team**

[⭐ Star us on GitHub](https://github.com/yourusername/savepoints_modern_ui) • [📦 Pub.dev](https://pub.dev/packages/savepoints_modern_ui) • [📚 Documentation](https://pub.dev/documentation/savepoints_modern_ui/latest/)

</div>
