import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/auth/login/login_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/auth_fixtures.dart';
import '../../helpers/fake_repository.dart';
import '../../helpers/mock_platform_channels.dart';
import '../../helpers/test_bootstrap.dart';
import '../../helpers/widget_test_app.dart';

void main() {
  setUp(() {
    mockFlutterToastChannel();
  });

  tearDown(resetFlutterToastChannel);

  testWidgets('LoginScreen renders phone form initially', (tester) async {
    final repository = FakeRepository()
      ..loginStub = () async => right(loginResponseFixture());
    await configureTestDependencies(repository: repository);
    registerWidgetTestCubits();

    await pumpWidgetTestApp(tester, const LoginScreen());

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('+20'), findsOneWidget);
  });

  testWidgets('LoginScreen reveals password field after invalid login response', (tester) async {
    final repository = FakeRepository()
      ..loginStub = () async => left('Invalid credentials');
    await configureTestDependencies(repository: repository);
    registerWidgetTestCubits();

    await pumpWidgetTestApp(tester, const LoginScreen());

    await tester.enterText(find.byType(TextFormField), '1000000000');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(repository.lastLoginRequest?.phone, '+201000000000');
    expect(repository.lastLoginRequest?.password, isNull);
  });
}
