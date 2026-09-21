import 'package:flutter/material.dart';

/// Screen width breakpoints for responsive design
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  static const double mobileMax = 599.0;
  static const double tabletPortraitMin = 600.0;
  static const double tabletLandscapeMin = 900.0;
  static const double desktopMin = 1200.0;

  // Max content width limits to avoid over-stretching on large displays
  static const double maxFormWidth = 540.0;
  static const double maxCardWidth = 650.0;
  static const double maxContentWidth = 1100.0;
  static const double maxDialogWidth = 450.0;
  static const double maxBottomSheetWidth = 560.0;
}

/// Centralized helper for responsive queries and value resolution
class AppResponsive {
  AppResponsive._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  static bool isMobile(BuildContext context) =>
      width(context) < ResponsiveBreakpoints.tabletPortraitMin;

  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= ResponsiveBreakpoints.tabletPortraitMin &&
        w < ResponsiveBreakpoints.desktopMin;
  }

  static bool isTabletPortrait(BuildContext context) {
    final w = width(context);
    return w >= ResponsiveBreakpoints.tabletPortraitMin &&
        w < ResponsiveBreakpoints.tabletLandscapeMin;
  }

  static bool isTabletLandscape(BuildContext context) {
    final w = width(context);
    return w >= ResponsiveBreakpoints.tabletLandscapeMin &&
        w < ResponsiveBreakpoints.desktopMin;
  }

  static bool isDesktop(BuildContext context) =>
      width(context) >= ResponsiveBreakpoints.desktopMin;

  static bool isTabletOrLarger(BuildContext context) =>
      width(context) >= ResponsiveBreakpoints.tabletPortraitMin;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// Resolves a value according to the current screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tabletPortrait,
    T? tabletLandscape,
    T? desktop,
    T? tablet,
  }) {
    final w = width(context);

    if (w >= ResponsiveBreakpoints.desktopMin) {
      return desktop ?? tabletLandscape ?? tablet ?? mobile;
    }
    if (w >= ResponsiveBreakpoints.tabletLandscapeMin) {
      return tabletLandscape ?? tablet ?? mobile;
    }
    if (w >= ResponsiveBreakpoints.tabletPortraitMin) {
      return tabletPortrait ?? tablet ?? mobile;
    }
    return mobile;
  }

  /// Calculates optimal grid column count
  static int gridColumns(
    BuildContext context, {
    int mobile = 2,
    int tabletPortrait = 3,
    int tabletLandscape = 4,
    int desktop = 4,
  }) {
    final w = width(context);
    if (w >= ResponsiveBreakpoints.desktopMin) return desktop;
    if (w >= ResponsiveBreakpoints.tabletLandscapeMin) return tabletLandscape;
    if (w >= ResponsiveBreakpoints.tabletPortraitMin) return tabletPortrait;
    return mobile;
  }
}

/// Widget that constrains content to a maximum width on tablets/desktops and centers it,
/// while allowing natural 100% width on phones.
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const AdaptiveContainer({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveBreakpoints.maxCardWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final isLarge = AppResponsive.isTabletOrLarger(context);

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (!isLarge) {
      return content;
    }

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      ),
    );
  }
}
