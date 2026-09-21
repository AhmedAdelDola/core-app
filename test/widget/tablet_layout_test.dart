import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:elhanbly/feature/home_layout/cubit/home_lay_out_cubit.dart';
import 'package:elhanbly/feature/home_layout/home_layout.dart';
import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repository.dart';
import '../helpers/test_bootstrap.dart';
import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('HomeLayout renders cleanly on tablet (768x1024)', (tester) async {
    final repository = FakeRepository()
      ..getHomeStub = () async => right(HomeResponse.fromJson({}));
    await configureTestDependencies(repository: repository);
    registerWidgetTestCubits();

    await pumpWidgetTestApp(
      tester,
      BlocProvider<BottomBarCubit>.value(
        value: di<BottomBarCubit>(),
        child: const HomeLayout(),
      ),
      size: const Size(768, 1024),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomeLayout), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);

    final navBarFinder = find.byKey(const ValueKey('nav_tab_0'));
    expect(navBarFinder, findsOneWidget);

    final RenderBox navRenderBox = tester.renderObject(navBarFinder);
    final navPos = navRenderBox.localToGlobal(Offset.zero);
    // Ensure the navigation bar is docked at the bottom of the screen, NOT in the middle
    expect(navPos.dy, greaterThan(900.0));
  });
}
