<div align="center">

# SavePoints Modern UI 🎨

### Dialogs, snackbars and bottom sheets that share one design language — twelve styles, one import, no native code

[![Pub Version](https://img.shields.io/pub/v/save_points_snackbar_dialog_bottomsheet?style=flat-square&logo=dart&color=0175C2)](https://pub.dev/packages/save_points_snackbar_dialog_bottomsheet)
[![Pub Points](https://img.shields.io/pub/points/save_points_snackbar_dialog_bottomsheet?style=flat-square&color=0175C2)](https://pub.dev/packages/save_points_snackbar_dialog_bottomsheet/score)
[![Likes](https://img.shields.io/pub/likes/save_points_snackbar_dialog_bottomsheet?style=flat-square&color=0175C2)](https://pub.dev/packages/save_points_snackbar_dialog_bottomsheet/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/m7hamed-dev/save-points-modern-ui/pulls)

[**📦 pub.dev**](https://pub.dev/packages/save_points_snackbar_dialog_bottomsheet) · [**📚 API reference**](https://pub.dev/documentation/save_points_snackbar_dialog_bottomsheet/latest/) · [**🧪 Example app**](https://github.com/m7hamed-dev/save-points-modern-ui/tree/main/example) · [**🐛 Report a bug**](https://github.com/m7hamed-dev/save-points-modern-ui/issues)

<img width="900" alt="The three components across the built-in design styles" src="https://github.com/user-attachments/assets/05a6eb09-54c2-4e49-8447-14aef43b28ea" />

</div>

---

## 🖼️ Preview

<div align="center">

<img width="900" alt="Dialogs rendered in several design styles" src="https://github.com/user-attachments/assets/de97592d-503e-4595-a8fd-6e0602c75535" />
<img width="900" alt="Snackbars rendered in several design styles" src="https://github.com/user-attachments/assets/f60ce6c6-ee79-4eaa-b638-d0af32fe4eae" />
<img width="900" alt="Bottom sheets rendered in several design styles" src="https://github.com/user-attachments/assets/bd6102c0-15dc-4026-9309-ebb9f1245653" />

</div>

> A comprehensive Flutter package providing elegant, customizable UI components with stunning glassmorphism effects, smooth animations, and extensive customization options. Perfect for building modern, professional user interfaces.

## Contents

| | |
|---|---|
| [Overview](#-overview) · [Key features](#-key-features) | what this is |
| [Installation](#-installation) · [Compatibility](#-compatibility) · [Quick start](#-quick-start) | five minutes in |
| **[Design styles](#design-styles)** | the twelve looks, and when to use each |
| [Dialog](#-savepointsdialog-1) · [Snackbar](#-savepointssnackbar-1) · [Bottom sheet](#-savepointsbottomsheet-1) | every parameter |
| [Dialog presets](#-dialog-presets) · [Animations](#-animation-types) | ready-made choices |
| [Configuration](#️-configuration) · [`SavePointsTheme`](#-scoped-defaults-with-savepointstheme) | defaults, app-wide or per subtree |
| [Building on the same styles](#-building-on-the-same-styles) | `SpStyles` for your own widgets |
| [Accessibility](#-accessibility) · [Performance](#-performance) | what the package guarantees |
| **[FAQ](#-faq)** | the questions people actually ask |

## 🌟 Overview

**SavePoints Modern UI** is a production-ready Flutter package that offers three powerful, feature-rich UI components:

- **🎭 Dialogs** - Beautiful modal dialogs with glassmorphism design
- **🍞 Snackbars** - Enhanced notifications with rich animations and customization
- **📱 Bottom Sheets** - Modern bottom sheets with drag handles and scroll support

All three share one **bold & expressive** design language and the same **12 visual styles**, from an understated `minimal` through frosted `glass` to a loud `brutalist`. Every style is resolved in one place, so it looks like itself on a dialog, a snackbar and a bottom sheet alike. See [Design styles](#design-styles).

All components feature automatic dark mode support, extensive customization options, and are optimized for performance with built-in repaint boundaries and efficient animations. The codebase follows professional Flutter best practices with comprehensive documentation, well-organized structure, and maintainable code.

## ✨ Key Features

### 🎭 SavePointsDialog

- **✨ Glassmorphism Design** - Beautiful frosted glass effects with backdrop blur
- **🎨 12 design styles** - `solid`, `outlined`, `tonal`, `colorHeader`, `leftAccent`, `glass`, `neon`, `minimal`, `brutalist`, `gradientBorder`, `aurora`, `soft` — `colorHeader` by default, all in light & dark. [See the table](#design-styles)
- **🎨 Fully Customizable** - Colors, icons, buttons, and animations
- **⚡ Smooth Animations** - Multiple animation types including fade, slide, scale, bounce, and more
- **🌓 Dark Mode Support** - Automatic theme adaptation
- **📱 Loading States** - Built-in support for async operations with loading indicators
- **🎯 Flexible Actions** - Single or dual button configurations
- **🧩 Custom Content** - Add custom widgets (forms, ratings, etc.) with the optional `child` parameter
- **📳 Haptic Feedback** - Enhanced user experience with tactile responses
- **🔄 Async Support** - Handle asynchronous confirm callbacks with loading states

### 🍞 SavePointsSnackbar

- **📊 Multiple Types** - Success, Error, Warning, and Info variants with predefined styling
- **🎨 12 design styles** - `solid`, `outlined`, `tonal`, `colorHeader`, `leftAccent`, `glass`, `neon`, `minimal`, `brutalist`, `gradientBorder`, `aurora`, `soft` — `solid` by default, all in light & dark. [See the table](#design-styles)
- **🎬 Rich Animations** - 7+ animation types: fade, slide, scale, bounce, rotate, elastic, slideRotate
- **📈 Progress Indicators** - Optional progress bars for timed notifications
- **🎨 Gradient Backgrounds** - Support for custom gradient designs
- **📍 Position Control** - Display at top or bottom of screen with smart margin calculation
- **👆 Interactive** - Tap to dismiss, custom tap handlers, and action buttons
- **🎯 Customizable Styling** - Borders, border radius, margins, colors, and more
- **📳 Haptic Feedback** - Configurable haptic responses
- **♿ Announced** - Snackbars are a `Semantics` live region, so TalkBack and VoiceOver read them on arrival
- **⚡ Performance Optimized** - Efficient animations with clamped values

### 📱 SavePointsBottomsheet

- **✨ Modern Design** - Glassmorphism effects with backdrop blur
- **🎨 12 design styles** - `solid`, `outlined`, `tonal`, `colorHeader`, `leftAccent`, `glass`, `neon`, `minimal`, `brutalist`, `gradientBorder`, `aurora`, `soft` — `colorHeader` by default, all in light & dark. [See the table](#design-styles)
- **🎚️ Drag Handle** - Optional drag indicator for better UX
- **📜 Scrollable Content** - Built-in support for scrollable content with proper constraints
- **⌨️ Keyboard Aware** - Automatically positions above keyboard when TextFormField is focused
- **⏳ Loading States** - Support for loading indicators during async operations
- **🎬 Custom Animations** - Flexible enter and exit animations
- **📏 Flexible Sizing** - Customizable max height and constraints
- **🌓 Dark Mode Support** - Automatic theme adaptation
- **🎯 Dismissible & Draggable** - Full control over user interactions

## 📦 Installation

```bash
flutter pub add save_points_snackbar_dialog_bottomsheet
```

Or add it to `pubspec.yaml` yourself:

```yaml
dependencies:
  save_points_snackbar_dialog_bottomsheet: ^2.0.0
```

Then one import gives you the whole API:

```dart
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';
```

> [!NOTE]
> There is nothing else to set up — no initialization call, no wrapper widget,
> no platform configuration. The only requirement is that a `ScaffoldMessenger`
> sits above the context you pass in, which `material_ui`'s `MaterialApp`
> already provides. It must be **`material_ui`'s**: see
> [Compatibility](#-compatibility).

## ✅ Compatibility

| Requirement | Version |
|---|---|
| Dart SDK | `^3.13.0` |
| Flutter | 3.47 or newer |
| Dependencies | [`material_ui`](https://pub.dev/packages/material_ui) `^1.11.0` |

| Platform | Status |
|---|---|
| Android · iOS | ✅ Supported |
| Web | ✅ Supported |
| macOS · Windows · Linux | ✅ Supported |

Pure Dart and Flutter: no platform channels and no native code, which is why
the package works unchanged on every target above.

> [!IMPORTANT]
> **2.0.0 requires that your app has migrated to `package:material_ui`.**
> Flutter 3.47 deprecated `package:flutter/material.dart` in favour of the
> standalone [`material_ui`](https://pub.dev/packages/material_ui) package,
> and 2.0.0 follows it. The two `ScaffoldMessenger` implementations are not
> interchangeable: under the legacy `MaterialApp` every snackbar fails with
> *"requires a ScaffoldMessenger ancestor"*.
>
> Migrate your app first — `dart fix --apply --code=migrate_design_widgets` —
> or stay on `^1.3.0`, which is the same package built on
> `package:flutter/material.dart` and carries every fix 2.0.0 has.

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

### Design styles

All three components share one **bold & expressive** design language and the same
set of visual styles via `ContentDesignStyle`. Every style adapts to light and
dark themes.

| Style | Look | Reach for it when |
|-------|------|-------------------|
| `solid` | Vivid gradient fill, white content, a same-hue glow — **snackbar default** | The message *is* the colour: a success, an error |
| `colorHeader` | Vivid gradient band across the top with a circular icon chip — **dialog & sheet default** | A moment deserves a header |
| `outlined` | Neutral surface inside a coloured border | You want the accent without the weight |
| `tonal` | Softly tinted surface (Material 3 tonal) | Quiet, but still carrying the intent colour |
| `leftAccent` | Neutral surface with a gradient bar down the leading edge | Lists and stacked notices, where a bar scans faster |
| `glass` | Frosted translucency over a backdrop blur, hairline highlight | There is something worth seeing behind it |
| `neon` | Near-black surface, glowing accent ring, wide bloom | Dark UIs, or anything that should look electric |
| `minimal` | Opaque surface, one hairline, perfectly flat | The component should get out of the way |
| `brutalist` | Flat punchy fill, thick hard border, an offset shadow with no blur | Graphic, loud, deliberately un-soft |
| `gradientBorder` | Neutral surface ringed by a vivid gradient stroke | Premium framing without tinting the content |
| `aurora` | A multi-stop wash of the accent bleeding across the surface | Hero moments; the most expressive of the set |
| `soft` | Pastel fill, generous rounding, light-from-above shadows | Friendly and tactile — onboarding, empty states |

Pick any style per call:

```dart
// Snackbar — solid vivid gradient (default)
SavePointsSnackbar.showSuccess(context, title: 'Done!', subtitle: 'Saved.');

// Dialog — frosted glass
SavePointsDialog.show(
  context,
  title: 'Frosted',
  message: 'Glassmorphism dialog.',
  designStyle: ContentDesignStyle.glass,
);

// Bottom sheet — neon
SavePointsBottomsheet.show(
  context: context,
  title: 'Neon',
  designStyle: ContentDesignStyle.neon,
  child: YourContentWidget(),
);
```

Or set the default once for a whole subtree — the recommended way, since it
covers all three surfaces at once and rebuilds descendants when it changes:

```dart
SavePointsTheme(
  data: const SavePointsThemeData(designStyle: ContentDesignStyle.glass),
  child: MaterialApp(/* ... */),
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
  ContentDesignStyle? designStyle,
  double? blur,
  ImageFilter? backdropFilter,
  Widget? child,
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
| `hideLikeCircle` | `bool` | No | `false` | Disable circular reveal exit animation |
| `designStyle` | `ContentDesignStyle?` | No | `colorHeader` | `solid` / `outlined` / `tonal` / `colorHeader` / `leftAccent` / `glass` / `neon` / `minimal` |
| `blur` | `double?` | No | `20.0` | Barrier blur sigma. Falls back to `SavePointsTheme`, then to `defaultBarrierBlurSigma`. Pass `0` to opt out |
| `backdropFilter` | `ImageFilter?` | No | `null` | Custom backdrop filter (overrides `blur` when set) |
| `enablePulse` | `bool?` | No | `false` | Loops a subtle scale + glow on the icon. Off by default: it never stops, so it repaints every frame and hangs `pumpAndSettle()` in tests |
| `child` | `Widget?` | No | `null` | Custom widget displayed between message and buttons |

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

**7. Dialog with Custom Backdrop Blur**

```dart
import 'dart:ui';

SavePointsDialog.show(
  context,
  title: 'Glassmorphism',
  message: 'Custom blur intensity for the frosted glass effect.',
  blur: 24.0,
  icon: Icons.blur_on,
);
// Or disable blur: blur: 0
```

**8. Dialog with Custom Child Widget (Form)**

```dart
final nameController = TextEditingController();
final emailController = TextEditingController();

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
        controller: nameController,
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'Enter your name',
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: .circular(12),
          ),
          filled: true,
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: .circular(12),
          ),
          filled: true,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    ],
  ),
  onConfirm: () {
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      // Process form data
      print('Name: ${nameController.text}, Email: ${emailController.text}');
    }
    nameController.dispose();
    emailController.dispose();
  },
  onCancel: () {
    nameController.dispose();
    emailController.dispose();
  },
);
```

**9. Dialog with Interactive Rating Widget**

```dart
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
        mainAxisAlignment: MainAxis.center,
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
      print('User rated: $rating stars');
    }
  },
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
  VoidCallback? onDismissed,
  VoidCallback? onTap,
  ContentDesignStyle? designStyle,
  double? blur,
  ImageFilter? backdropFilter,
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
| `position` | `SnackbarPosition?` | No | `top` | Position: `top` or `bottom` |
| `animation` | `SnackbarAnimation?` | No | `fadeSlide` | Animation type (legacy) |
| `startAnimation` | `SnackbarAnimationDirection?` | No | `null` | Enter animation direction |
| `endAnimation` | `SnackbarAnimationDirection?` | No | `null` | Exit animation direction |
| `duration` | `Duration?` | No | `4 seconds` | Display duration |
| `showProgressIndicator` | `bool?` | No | `false` | Show progress bar |
| `gradient` | `Gradient?` | No | `null` | Custom gradient background |
| `borderColor` | `Color?` | No | `null` | Border color |
| `borderWidth` | `double?` | No | `0` | Border width |
| `dismissOnTap` | `bool?` | No | `false` | Dismiss when tapped |
| `onTap` | `VoidCallback?` | No | `null` | Custom tap handler |
| `onDismissed` | `VoidCallback?` | No | `null` | Callback when dismissed |
| `designStyle` | `ContentDesignStyle?` | No | `solid` | `solid` / `outlined` / `tonal` / `colorHeader` / `leftAccent` / `glass` / `neon` / `minimal` |
| `blur` | `double?` | No | `null` | Surface blur sigma. Unlike dialogs and sheets a snackbar has no barrier, so leaving it unset applies **no** blur |
| `backdropFilter` | `ImageFilter?` | No | `null` | Custom backdrop filter (overrides `blur` when set) |
| `enablePulse` | `bool?` | No | `false` | Loops a subtle scale + glow on the icon. Off by default: it never stops, so it repaints every frame and hangs `pumpAndSettle()` in tests |

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
  borderRadius: .circular(12),
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

**13. Snackbar with Backdrop Blur**

```dart
import 'dart:ui';

SavePointsSnackbar.show(
  context,
  title: 'Glassmorphism Snackbar',
  subtitle: 'Frosted glass effect behind the snackbar',
  blur: 12.0,
  type: SnackbarType.info,
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
  ContentDesignStyle? designStyle,
  double? blur,
  ImageFilter? backdropFilter,
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
| `hideLikeCircle` | `bool` | No | `false` | Disable circular reveal exit animation |
| `designStyle` | `ContentDesignStyle?` | No | `colorHeader` | `solid` / `outlined` / `tonal` / `colorHeader` / `leftAccent` / `glass` / `neon` / `minimal` |
| `blur` | `double?` | No | `20.0` | Barrier blur sigma. Falls back to `SavePointsTheme`, then to `defaultBarrierBlurSigma`. Pass `0` to opt out |
| `backdropFilter` | `ImageFilter?` | No | `null` | Custom backdrop filter (overrides `blur` when set) |
| `enablePulse` | `bool?` | No | `false` | Loops a subtle scale + glow on the icon. Off by default: it never stops, so it repaints every frame and hangs `pumpAndSettle()` in tests |

#### Examples

**1. Basic Bottom Sheet**

```dart
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
```

**2. Options Menu Bottom Sheet**

```dart
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
    padding: .all(24.0),
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
    mainAxisSize: .min,
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
```

**7. Bottom Sheet with Custom Blur**

```dart
import 'dart:ui';

SavePointsBottomsheet.show(
  context: context,
  title: 'Glassmorphism',
  icon: Icons.blur_on,
  blur: 16.0,
  child: const Padding(
    padding: .all(24.0),
    child: Text(
      'Backdrop blur can be customized with the blur parameter.',
      style: TextStyle(fontSize: 16),
    ),
  ),
);
```

## 🎭 Dialog Presets

Use predefined configurations for common dialog flows:

```dart
import 'package:save_points_snackbar_dialog_bottomsheet/presets/presets.dart';
```

**Delete confirmation**

```dart
final confirmed = await DialogPresets.showDeleteConfirmation(
  context,
  itemName: 'My Document',
);
if (confirmed == true) {
  // Delete the item
}
```

**Logout confirmation**

```dart
final confirmed = await DialogPresets.showLogoutConfirmation(context);
if (confirmed == true) {
  // Perform logout
}
```

**Discard changes**

```dart
final confirmed = await DialogPresets.showDiscardChangesConfirmation(context);
if (confirmed == true) {
  Navigator.pop(context);
}
```

**Update available**

```dart
DialogPresets.showUpdateAvailable(context);
```

**Feature not available**

```dart
DialogPresets.showFeatureNotAvailable(context);
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

## ⚙️ Configuration

SavePoints Modern UI provides a centralized configuration system through `SnackDiaBottomConfig`:

```dart
// Configure global defaults
final config = SnackDiaBottomConfig();
config.snackbar
  ..defaultDuration = Duration(seconds: 5)
  ..defaultType = SnackbarType.info
  ..defaultShowProgressIndicator = true
  ..defaultDesignStyle = ContentDesignStyle.solid; // any ContentDesignStyle

config.dialog
  ..defaultConfirmText = 'Continue'
  ..defaultShowCancelButton = true
  ..defaultDesignStyle = ContentDesignStyle.colorHeader; // any ContentDesignStyle

```

> [!WARNING]
> `SavePointsBottomsheet.defaultDesignStyle` is deprecated as of 1.2.1. A
> mutable static is process-wide and notifies nothing already on screen — use
> [`SavePointsTheme`](#-scoped-defaults-with-savepointstheme) instead, which
> also sets the default for dialogs and snackbars in one place.

Resolution order for every component is **explicit argument → nearest
`SavePointsTheme` → this config**.

See the [Configuration Guide](https://github.com/m7hamed-dev/save-points-modern-ui/wiki/Configuration) for more details.

### 🎨 Scoped defaults with `SavePointsTheme`

`SnackDiaBottomConfig` sets defaults **globally** by mutating a singleton. When
you'd rather declare defaults **once in your widget tree** — scoped, overridable
per subtree, and without touching global state — wrap your app in a
`SavePointsTheme`:

```dart
SavePointsTheme(
  data: const SavePointsThemeData(
    designStyle: ContentDesignStyle.glass,
    blur: 24,
    snackbarPosition: SnackbarPosition.top,
    enableHapticFeedback: true,
  ),
  child: MaterialApp(/* ... */),
);
```

Now every dialog, snackbar and bottom sheet below it defaults to the glass style
with a 24px backdrop blur — no need to repeat those arguments on each call:

```dart
// Uses the themed glass style + blur automatically.
SavePointsDialog.show(context, title: 'Saved', message: 'All set!');

// Explicit arguments still win over the theme.
SavePointsDialog.show(
  context,
  title: 'Heads up',
  message: 'This one is different',
  designStyle: ContentDesignStyle.neon,
);
```

Resolution order for every field is **explicit argument → nearest
`SavePointsTheme` → built-in default**, so adopting a theme is fully backward
compatible. Any field left `null` in `SavePointsThemeData` falls through to the
component's own default. Because it is a standard `InheritedWidget`, a subtree
can wrap itself in another `SavePointsTheme` to override just that branch.

Supported fields: `designStyle`, `blur`, `snackbarPosition`,
`snackbarDuration`, `enableHapticFeedback`, `barrierDismissible`,
`enablePulse`.

## 🎨 Building on the same styles

Every style resolves through one public helper, so you can decorate your own
surfaces in the package's language instead of eyeballing its colours:

```dart
final spec = SpStyles.of(
  ContentDesignStyle.aurora,
  Theme.of(context).colorScheme.primary,
  Theme.of(context).brightness == Brightness.dark,
);

Container(
  decoration: BoxDecoration(
    color: spec.fillGradient == null ? spec.fill : null,
    gradient: spec.fillGradient,
    borderRadius: BorderRadius.circular(24 * spec.radiusScale),
    border: spec.hasBorder
        ? Border.all(color: spec.borderColor!, width: spec.borderWidth)
        : null,
    boxShadow: spec.shadows,
  ),
  child: Text('Matches the family', style: TextStyle(color: spec.onSurface)),
);
```

`SpStyleSpec` carries everything a style decides: `fill`, `fillGradient`,
`onSurface`, `onSurfaceMuted`, `shadows`, `borderColor`, `borderWidth`,
`borderGradient`, `radiusScale` and `blurSigma`.

The underlying tokens are public too — `SpRadius`, `SpSpacing`, `SpType`,
`SpMotion`, `SpSurface`, `SpPalette`, `SpShadows` and `SpContrast` — if you
would rather compose your own.

## ♿ Accessibility

- Snackbars are announced by TalkBack and VoiceOver on arrival (they render
  inside a `Semantics` live region).
- Every icon-only close button carries a localized label, taken from
  `MaterialLocalizations`, so it reads correctly in all supported locales.
- Reveal and slide animations resolve against `Directionality.of(context)`, so
  directional alignments mirror correctly in RTL layouts.

## 🎯 Performance

- **Repaint Boundaries** - Strategic use of `RepaintBoundary` widgets to minimize repaints
- **Cached Configurations** - Color configs and MediaQuery values are cached
- **Optimized Animations** - Clamped animations prevent overflow errors
- **Efficient Builds** - Widgets extracted to prevent unnecessary rebuilds
- **Code Quality** - Professional code structure with constants extraction and optimized helper methods

## 🔧 Running the Example

The runnable demo lives in [`example/`](https://github.com/m7hamed-dev/save-points-modern-ui/tree/main/example).

```bash
git clone https://github.com/m7hamed-dev/save-points-modern-ui.git
cd save-points-modern-ui/example
flutter run
```

It ships **more than 80 one-tap examples**, grouped by component:

- every one of the twelve design styles, side by side on all three components
- dialog presets, async confirm flows, and custom `child` content
- snackbars at the top and bottom, with progress bars, queues and actions
- bottom sheets with handles, scrollable content and loading states
- an app-bar switcher that flips the global default style at runtime

Its smoke tests (`example/test/`) drive those same buttons, so the demo is
verified to work, not just to compile.

## ❓ FAQ

<details>
<summary><b>Since 1.3.0 tapping outside my dialog closes it. How do I stop that?</b></summary>

Pass `barrierDismissible: false`, per call or for a whole subtree:

```dart
SavePointsDialog.show(
  context,
  title: 'Pick one',
  message: 'You must choose to continue.',
  barrierDismissible: false,
);

// or, for every dialog below this point:
SavePointsTheme(
  data: const SavePointsThemeData(barrierDismissible: false),
  child: const MyApp(),
);
```

Before 1.3.0 the flag did nothing: the dialog's transparent backing layer
covered the whole screen and absorbed the tap before it reached the barrier,
so dialogs never closed on an outside tap regardless of what you passed. The
layer is now sized to the card, so `barrierDismissible` finally behaves as
documented — and it has always defaulted to `true`.

</details>

<details>
<summary><b>My action button never appears on a top snackbar. Why?</b></summary>

A bottom snackbar is a real `SnackBar`, so it has Flutter's `SnackBarAction`
slot. A top snackbar is an overlay toast — there is no such slot, so
`actionLabel` and `onActionPressed` are ignored there, and so is `margin`
(the toast positions itself under the status bar and app bar instead).

Either keep the action and use `SnackbarPosition.bottom`, or use `onTap` on
the toast itself:

```dart
SavePointsSnackbar.show(
  context,
  title: 'Saved',
  position: SnackbarPosition.top,
  onTap: () => context.go('/details'), // works at the top
);
```

</details>

<details>
<summary><b>I get "requires a ScaffoldMessenger ancestor".</b></summary>

Every snackbar needs a `ScaffoldMessenger` above the `BuildContext` you pass
in. A normal `MaterialApp` provides one, so this almost always means the
context came from above the `MaterialApp` — for example the `BuildContext` of
the widget that *builds* `MaterialApp`.

Take the context from inside, with a `Builder` or from the page's own
`build`:

```dart
MaterialApp(
  home: Builder( // this context is below the MaterialApp
    builder: (context) => ElevatedButton(
      onPressed: () => SavePointsSnackbar.showSuccess(context, title: 'Hi'),
      child: const Text('Show'),
    ),
  ),
);
```

</details>

<details>
<summary><b><code>pumpAndSettle()</code> hangs in my widget tests.</b></summary>

Something on screen is animating forever. The package itself never does this
by default: the looping icon pulse is **off** unless you ask for it with
`enablePulse: true` (per call) or `SavePointsThemeData(enablePulse: true)`
(per subtree). If you have turned it on, the frame queue never goes quiet and
`pumpAndSettle` times out by design.

In tests either leave the pulse off, or drive the clock yourself:

```dart
await tester.pump();
await tester.pump(const Duration(milliseconds: 600));
```

</details>

<details>
<summary><b>How do I set one design style for my whole app?</b></summary>

Three levels, highest priority first:

1. **Per call** — `designStyle: ContentDesignStyle.glass`
2. **Per subtree** — wrap it in `SavePointsTheme`; it rebuilds descendants
   when it changes and covers all three components at once
3. **Process-wide** — `SnackDiaBottomConfig().snackbar.defaultDesignStyle`,
   set once in `main()`

```dart
SavePointsTheme(
  data: const SavePointsThemeData(designStyle: ContentDesignStyle.glass),
  child: const MyApp(),
);
```

Prefer `SavePointsTheme`. The config singleton notifies nothing that is
already on screen.

</details>

<details>
<summary><b>How do I show a spinner while an async action runs?</b></summary>

For a dialog's confirm button, return a `Future<bool>` from `onConfirmAsync`
— the button swaps itself for a spinner until it completes, and the dialog
closes only if you return `true`:

```dart
SavePointsDialog.show(
  context,
  title: 'Delete file',
  message: 'This cannot be undone.',
  showCancelButton: true,
  onConfirmAsync: () async {
    await api.delete(id);
    return true; // false keeps the dialog open
  },
);
```

To drive the spinner from outside, pass a `loadingNotifier` and flip its
value. Its current value is honoured from the first frame, and an unrelated
rebuild will not cancel it.

</details>

<details>
<summary><b>How do I close a snackbar before it expires?</b></summary>

Keep the controller that every show method returns — including the
`BuildContext` extensions:

```dart
final controller = context.showInfoSnackbar(title: 'Uploading…');
await upload();
controller.close();            // or: await controller.closed;
```

`context.dismissAllSnackbars()` clears everything at once, top toasts
included.

</details>

<details>
<summary><b>Why is my <code>glass</code> snackbar not blurred?</b></summary>

Blur defaults differ on purpose. Dialogs and bottom sheets have a barrier to
blur, so they blur it by default (`blur: 0` opts out). A snackbar has no
barrier, so it applies no blur unless you ask:

```dart
SavePointsSnackbar.show(
  context,
  title: 'Frosted',
  designStyle: ContentDesignStyle.glass,
  blur: 18, // required for snackbars
);
```

</details>

<details>
<summary><b>Can I style my own widgets to match?</b></summary>

Yes — `SpStyles.of` is the same resolver the package uses internally, and it
is exported. See
[Building on the same styles](#-building-on-the-same-styles).

</details>

<details>
<summary><b>Does it support RTL and Arabic layouts?</b></summary>

Yes. Reveal and slide animations resolve against `Directionality.of(context)`
so directional alignments mirror, and close-button labels come from
`MaterialLocalizations`, so they are read out in the user's own locale.

</details>

<details>
<summary><b>Does it work with Flutter 3.50 / <code>package:material_ui</code>?</b></summary>

That is exactly what 2.0.0 is for: it is built on `package:material_ui`, so
your app must be too. If your app still imports
`package:flutter/material.dart`, stay on `^1.3.0` — same package, same fixes,
built on the legacy import. See [Compatibility](#-compatibility).

</details>

## 📖 Additional Resources

- [Full API Documentation](https://pub.dev/documentation/save_points_snackbar_dialog_bottomsheet/latest/)
- [Example App](https://github.com/m7hamed-dev/save-points-modern-ui/tree/main/example)
- [Issue Tracker](https://github.com/m7hamed-dev/save-points-modern-ui/issues)

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

- **Issues**: [GitHub Issues](https://github.com/m7hamed-dev/save-points-modern-ui/issues)
- **Email**: support@savepoints.dev

---

<div align="center">

**Made with ❤️ by the SavePoints team**

[⭐ Star us on GitHub](https://github.com/m7hamed-dev/save-points-modern-ui) • [📦 Pub.dev](https://pub.dev/packages/save_points_snackbar_dialog_bottomsheet) • [📚 Documentation](https://pub.dev/documentation/save_points_snackbar_dialog_bottomsheet/latest/)

</div>
