import 'package:elhanbly/core/util/responsive/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_test_app.dart';

void main() {
  group('AppResponsive Unit Tests', () {
    testWidgets('identifies mobile screens correctly (375x812)', (tester) async {
      late bool isMobile;
      late bool isTablet;
      late bool isTabletOrLarger;
      late int columns;

      await pumpWidgetTestApp(
        tester,
        Builder(
          builder: (context) {
            isMobile = AppResponsive.isMobile(context);
            isTablet = AppResponsive.isTablet(context);
            isTabletOrLarger = AppResponsive.isTabletOrLarger(context);
            columns = AppResponsive.gridColumns(context);
            return const SizedBox();
          },
        ),
        size: const Size(375, 812),
      );

      expect(isMobile, isTrue);
      expect(isTablet, isFalse);
      expect(isTabletOrLarger, isFalse);
      expect(columns, equals(2));
    });

    testWidgets('identifies tablet portrait screens correctly (768x1024)', (tester) async {
      late bool isMobile;
      late bool isTablet;
      late bool isTabletPortrait;
      late bool isTabletLandscape;
      late int columns;
      late String testValue;

      await pumpWidgetTestApp(
        tester,
        Builder(
          builder: (context) {
            isMobile = AppResponsive.isMobile(context);
            isTablet = AppResponsive.isTablet(context);
            isTabletPortrait = AppResponsive.isTabletPortrait(context);
            isTabletLandscape = AppResponsive.isTabletLandscape(context);
            columns = AppResponsive.gridColumns(context);
            testValue = AppResponsive.value<String>(
              context,
              mobile: 'mobile',
              tablet: 'tablet',
            );
            return const SizedBox();
          },
        ),
        size: const Size(768, 1024),
      );

      expect(isMobile, isFalse);
      expect(isTablet, isTrue);
      expect(isTabletPortrait, isTrue);
      expect(isTabletLandscape, isFalse);
      expect(columns, equals(2));
      expect(testValue, equals('tablet'));
    });

    testWidgets('identifies tablet landscape screens correctly (1024x768)', (tester) async {
      late bool isTabletLandscape;
      late bool isTabletOrLarger;
      late int columns;

      await pumpWidgetTestApp(
        tester,
        Builder(
          builder: (context) {
            isTabletLandscape = AppResponsive.isTabletLandscape(context);
            isTabletOrLarger = AppResponsive.isTabletOrLarger(context);
            columns = AppResponsive.gridColumns(context);
            return const SizedBox();
          },
        ),
        size: const Size(1024, 768),
      );

      expect(isTabletLandscape, isTrue);
      expect(isTabletOrLarger, isTrue);
      expect(columns, equals(3));
    });

    testWidgets('identifies mobile landscape screens correctly (843x411)', (tester) async {
      late bool isMobile;
      late bool isTablet;
      late bool isMobileLandscape;
      late bool isTabletLandscape;
      late int columns;

      await pumpWidgetTestApp(
        tester,
        Builder(
          builder: (context) {
            isMobile = AppResponsive.isMobile(context);
            isTablet = AppResponsive.isTablet(context);
            isMobileLandscape = AppResponsive.isMobileLandscape(context);
            isTabletLandscape = AppResponsive.isTabletLandscape(context);
            columns = AppResponsive.gridColumns(context);
            return const SizedBox();
          },
        ),
        size: const Size(843, 411),
      );

      expect(isMobile, isTrue);
      expect(isTablet, isFalse);
      expect(isMobileLandscape, isTrue);
      expect(isTabletLandscape, isFalse);
      expect(columns, equals(2));
    });

    testWidgets('AdaptiveContainer enforces maxWidth on wide screens', (tester) async {
      await pumpWidgetTestApp(
        tester,
        const AdaptiveContainer(
          maxWidth: 500,
          child: SizedBox(key: Key('inner_box'), width: double.infinity, height: 100),
        ),
        size: const Size(1024, 768),
      );

      final boxFinder = find.byKey(const Key('inner_box'));
      expect(boxFinder, findsOneWidget);
      final RenderBox renderBox = tester.renderObject(boxFinder);
      expect(renderBox.size.width, equals(500));
    });

    testWidgets('AdaptiveContainer uses full width on narrow screens', (tester) async {
      await pumpWidgetTestApp(
        tester,
        const AdaptiveContainer(
          maxWidth: 600,
          child: SizedBox(key: Key('inner_box_mobile'), width: double.infinity, height: 100),
        ),
        size: const Size(375, 812),
      );

      final boxFinder = find.byKey(const Key('inner_box_mobile'));
      expect(boxFinder, findsOneWidget);
      final RenderBox renderBox = tester.renderObject(boxFinder);
      expect(renderBox.size.width, equals(375));
    });
  });
}
