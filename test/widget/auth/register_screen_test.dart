import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/auth/complete_profile/register_imports.dart';
import 'package:elhanbly/models/general/register_stage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/register_fixtures.dart';
import '../../helpers/fake_repository.dart';
import '../../helpers/mock_platform_channels.dart';
import '../../helpers/test_bootstrap.dart';
import '../../helpers/widget_test_app.dart';

void main() {
  setUp(() {
    mockFlutterToastChannel();
  });

  tearDown(resetFlutterToastChannel);

  testWidgets('RegisterScreen shows loading while stages are loading', (tester) async {
    final completer = Completer<Either<dynamic, List<RegisterStage>>>();
    final repository = FakeRepository()
      ..fetchRegistrationStagesStub = () => completer.future;
    await configureTestDependencies(repository: repository);

    await pumpWidgetTestApp(
      tester,
      RegisterScreen(phone: '+201000000000'),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('RegisterScreen renders form after stages load', (tester) async {
    final repository = FakeRepository()
      ..fetchRegistrationStagesStub = () async => right(registerStagesFixture());
    await configureTestDependencies(repository: repository);

    await pumpWidgetTestApp(
      tester,
      RegisterScreen(phone: '+201000000000'),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.text('+201000000000'), findsOneWidget);
  });

  testWidgets('RegisterScreen shows retry state when stages fail', (tester) async {
    final repository = FakeRepository()
      ..fetchRegistrationStagesStub = () async => left('stages failed');
    await configureTestDependencies(repository: repository);

    await pumpWidgetTestApp(
      tester,
      RegisterScreen(phone: '+201000000000'),
    );
    await tester.pumpAndSettle();

    expect(find.text('stages failed'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
