import 'package:flutter/material.dart';

class MyInputAlretBox extends StatelessWidget {
  const MyInputAlretBox({
    super.key,
    required this.textController,
    required this.onPressed,
    required this.onPressedText,
    required this.hintText,
  });

  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: theme.surface,
      content: TextField(
        controller: textController,
        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: theme.primary),
          fillColor: theme.secondary,
          filled: true,
          counterStyle: TextStyle(color: theme.primary),
        ),
      ),
      actions: [
        // cancel button
        TextButton(
          onPressed: () {
            // pop the dialog
            Navigator.pop(context);

            // clear controller
            textController.clear();
          },
          child: const Text("Cancel"),
        ),

        // save button
        TextButton(
          onPressed: () {
            // pop the dialog
            Navigator.pop(context);

            // excute function
            onPressed!();

            // clear controller
            textController.clear();
          },
          child: Text(onPressedText),
        ),
      ],
    );
  }
}
