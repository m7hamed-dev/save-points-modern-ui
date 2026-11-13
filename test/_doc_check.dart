// Not a test: a type-check for the code snippets in README.md's FAQ.
// `flutter analyze` compiles it; `flutter test` ignores it (no _test suffix).
// Delete it only together with the snippets it mirrors.
import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

class _Api {
  Future<void> delete(String id) async {}
}

final _api = _Api();
const _id = 'id';
Future<void> _upload() async {}
void _go(String route) {}

// FAQ: "My action button never appears on a top snackbar."
void snippetTopOnTap(BuildContext context) {
  SavePointsSnackbar.show(
    context,
    title: 'Saved',
    position: SnackbarPosition.top,
    onTap: () => _go('/details'), // works at the top
  );
}

// FAQ: "I get requires a ScaffoldMessenger ancestor."
Widget snippetBuilderContext() {
  return MaterialApp(
    home: Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => SavePointsSnackbar.showSuccess(context, title: 'Hi'),
        child: const Text('Show'),
      ),
    ),
  );
}

// FAQ: "How do I set one design style for my whole app?"
Widget snippetScopedTheme(Widget app) {
  return SavePointsTheme(
    data: const SavePointsThemeData(designStyle: ContentDesignStyle.glass),
    child: app,
  );
}

void snippetProcessWideDefault() {
  SnackDiaBottomConfig().snackbar.defaultDesignStyle = ContentDesignStyle.glass;
}

// FAQ: "How do I show a spinner while an async action runs?"
void snippetAsyncConfirm(BuildContext context) {
  SavePointsDialog.show(
    context,
    title: 'Delete file',
    message: 'This cannot be undone.',
    showCancelButton: true,
    onConfirmAsync: () async {
      await _api.delete(_id);
      return true; // false keeps the dialog open
    },
  );
}

// FAQ: "How do I close a snackbar before it expires?"
Future<void> snippetCloseEarly(BuildContext context) async {
  final controller = context.showInfoSnackbar(title: 'Uploading…');
  await _upload();
  controller.close(); // or: await controller.closed;
}

void snippetDismissAll(BuildContext context) {
  context.dismissAllSnackbars();
}

// FAQ: "Why is my glass snackbar not blurred?"
void snippetSnackbarBlur(BuildContext context) {
  SavePointsSnackbar.show(
    context,
    title: 'Frosted',
    designStyle: ContentDesignStyle.glass,
    blur: 18, // required for snackbars
  );
}

// FAQ: "Can I style my own widgets to match?"
Color snippetSpStyles(bool isDark) {
  return SpStyles.of(ContentDesignStyle.glass, const Color(0xFF6366F1), isDark)
      .onSurface;
}
