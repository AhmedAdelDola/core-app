import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/modules/home/home_screen.dart';
import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repository.dart';
import '../../helpers/test_bootstrap.dart';
import '../../helpers/widget_test_app.dart';

void main() {
  testWidgets('HomeScreen shows loading while home data is loading', (tester) async {
    final completer = Completer<Either<dynamic, HomeResponse>>();
    final repository = FakeRepository()..getHomeStub = () => completer.future;
    await configureTestDependencies(repository: repository);
    registerWidgetTestCubits();

    await pumpWidgetTestApp(tester, const HomeScreen());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomeScreen renders content after home data loads', (tester) async {
    final repository = FakeRepository()
      ..getHomeStub = () async => right(HomeResponse.fromJson({}));
    await configureTestDependencies(repository: repository);
    registerWidgetTestCubits();

    await pumpWidgetTestApp(tester, const HomeScreen());
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
