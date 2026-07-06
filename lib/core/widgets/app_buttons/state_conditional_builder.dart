import 'package:flutter/material.dart';

class StateConditionalBuilder extends StatelessWidget implements PreferredSizeWidget {
  final bool loadingCondition, errorCondition;
  final WidgetBuilder loadingBuilder, errorBuilder;
  final WidgetBuilder? fallback;

  const StateConditionalBuilder({
    super.key,
    required this.loadingCondition,
    required this.errorCondition,
    required this.errorBuilder,
    required this.loadingBuilder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) => loadingCondition
      ? loadingBuilder(context)
      : errorCondition
          ? errorBuilder(context)
          : fallback != null
              ? fallback!(context)
              : const SizedBox.shrink();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
