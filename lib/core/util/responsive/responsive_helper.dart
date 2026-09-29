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

  static double shortestSide(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width < size.height ? size.width : size.height;
  }

  static bool isLandscape(BuildContext context) =>
      width(context) > height(context);

  static bool isTablet(BuildContext context) {
    return shortestSide(context) >= ResponsiveBreakpoints.tabletPortraitMin;
  }

  static bool isMobile(BuildContext context) => !isTablet(context);

  static bool isMobileLandscape(BuildContext context) =>
      isMobile(context) && isLandscape(context);

  static bool isMobilePortrait(BuildContext context) =>
      isMobile(context) && !isLandscape(context);

  static bool isTabletPortrait(BuildContext context) =>
      isTablet(context) && !isLandscape(context);

  static bool isTabletLandscape(BuildContext context) =>
      isTablet(context) && isLandscape(context);

  static bool isDesktop(BuildContext context) =>
      width(context) >= ResponsiveBreakpoints.desktopMin;

  static bool isTabletOrLarger(BuildContext context) =>
      isTablet(context) || isDesktop(context);

  /// Resolves a value according to the current screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? mobileLandscape,
    T? tabletPortrait,
    T? tabletLandscape,
    T? desktop,
    T? tablet,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tabletLandscape ?? tablet ?? mobile;
    }
    if (isTabletLandscape(context)) {
      return tabletLandscape ?? tablet ?? mobile;
    }
    if (isTabletPortrait(context)) {
      return tabletPortrait ?? tablet ?? mobile;
    }
    if (isMobileLandscape(context)) {
      return mobileLandscape ?? mobile;
    }
    if (isLandscape(context)) {
      return mobileLandscape ?? mobile;
    }
    return mobile;
  }

  /// Calculates optimal grid column count
  static int gridColumns(
    BuildContext context, {
    int mobile = 2,
    int? mobileLandscape,
    int tabletPortrait = 2,
    int tabletLandscape = 3,
    int desktop = 4,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTabletLandscape(context)) return tabletLandscape;
    if (isTabletPortrait(context)) return tabletPortrait;
    if (isMobileLandscape(context)) return mobileLandscape ?? 2;
    if (isLandscape(context)) return mobileLandscape ?? 2;
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
    final shouldConstrain =
        AppResponsive.isTabletOrLarger(context) || AppResponsive.isLandscape(context);

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (!shouldConstrain) {
      return content;
    }

    return Align(
      alignment: alignment,
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      ),
    );
  }
}
