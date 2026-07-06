import 'package:flutter/material.dart';

import '../loader/app_loader.dart';
import 'custom_button.dart';

class ConditionalBuilder extends StatelessWidget implements PreferredSizeWidget {
  final bool condition;
  final WidgetBuilder builder;
  final WidgetBuilder? fallback;

  const ConditionalBuilder({
    super.key,
    required this.condition,
    required this.builder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return condition
        ? builder(context)
        : fallback != null
            ? fallback!(context)
            : const SizedBox.shrink();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ConditionalBtn extends StatelessWidget {
  final bool condition;
  final VoidCallback onTap;
  final String text;
  final Widget? icon;

  const ConditionalBtn({
    super.key,
    required this.condition,
    required this.onTap,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return condition ? const AppLoader() : CustomButton(text: text, onTap: onTap);
  }
}
