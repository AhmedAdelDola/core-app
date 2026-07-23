import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes,
          [Map<String, dynamic>? args]) async {
        final File image =
            await File('raw_screenshots/$screenshotName.png').create(recursive: true);
        await image.writeAsBytes(screenshotBytes);
        return true;
      },
    );
