import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.colour,
    super.key,
  });

  final Function() onPressed;

  final Widget child;

  final bool enabled;

  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final foregroundColour = colour ?? Theme.of(context).colorScheme.primary;

    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(12.0),
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return foregroundColour;
          },
        ),
        shape: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Colors.grey),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: foregroundColour),
            );
          },
        ),
      ),
      onPressed: !enabled ? null : onPressed,
      child: child,
    );
  }
}
