// ignore_for_file: avoid_print
// =============================================================================
// frame_screenshots.dart
//
// Takes raw screenshots captured by test_driver/screenshot_driver.dart and
// frames them into professional store-ready assets at all required dimensions.
//
// If a raw screenshot is missing, it skips that file (no blank placeholders).
//
// Usage:
//   dart scripts/frame_screenshots.dart --client Tasneem --input-dir raw_screenshots
// =============================================================================

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main(List<String> args) async {
  String client = 'Tasneem';
  String inputDir = 'raw_screenshots';
  String outputDir = 'output/store_assets';

  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--client' && i + 1 < args.length) client = args[i + 1];
    if (args[i] == '--input-dir' && i + 1 < args.length) inputDir = args[i + 1];
    if (args[i] == '--output-dir' && i + 1 < args.length) outputDir = args[i + 1];
  }

  print('Framing store screenshots for client: $client');

  // ── Load client branding ──────────────────────────────────────────────────
  final clientConfigFile = File('clients/$client/client_config.json');
  img.Color brandColor = img.ColorRgb8(37, 99, 235);

  if (clientConfigFile.existsSync()) {
    final cfg = jsonDecode(await clientConfigFile.readAsString()) as Map;
    final hex = cfg['fallbackPrimaryColor'] as String?;
    if (hex != null) {
      final cleaned = hex.replaceAll(RegExp(r'^0xFF|^0xff|^#'), '');
      if (cleaned.length >= 6) {
        final r = int.parse(cleaned.substring(0, 2), radix: 16);
        final g = int.parse(cleaned.substring(2, 4), radix: 16);
        final b = int.parse(cleaned.substring(4, 6), radix: 16);
        brandColor = img.ColorRgb8(r, g, b);
      }
    }
  }

  // Slightly darker version for gradient bottom
  final darkColor = img.ColorRgb8(
    math.max(0, brandColor.r.toInt() - 45),
    math.max(0, brandColor.g.toInt() - 45),
    math.max(0, brandColor.b.toInt() - 45),
  );

  // ── Store target dimensions ───────────────────────────────────────────────
  final targets = {
    'android': [
      {'name': 'phone_1080x1920', 'w': 1080, 'h': 1920},
      {'name': 'tablet_7in_1200x1920', 'w': 1200, 'h': 1920},
      {'name': 'tablet_10in_1600x2560', 'w': 1600, 'h': 2560},
    ],
    'ios': [
      {'name': 'iphone_6.7in_1290x2796', 'w': 1290, 'h': 2796},
      {'name': 'iphone_6.5in_1242x2688', 'w': 1242, 'h': 2688},
      {'name': 'ipad_12.9in_2048x2732', 'w': 2048, 'h': 2732},
    ],
  };

  // ── Raw screenshot filenames (produced by screenshot_driver.dart) ─────────
  // Map raw name → output name
  final screenshotFiles = [
    '01_splash.png',
    '02_onboarding_or_login.png',
    '03_guest_home.png',
    '04_main_screen.png',
    '05_library_screen.png',
    '06_profile_screen.png',
  ];

  int totalGenerated = 0;
  int totalSkipped = 0;

  for (final storeEntry in targets.entries) {
    final store = storeEntry.key;
    final sizes = storeEntry.value;

    for (final sizeMap in sizes) {
      final sizeName = sizeMap['name'] as String;
      final tw = sizeMap['w'] as int;
      final th = sizeMap['h'] as int;

      final outFolder = Directory('$outputDir/$client/$store/$sizeName');
      if (!outFolder.existsSync()) outFolder.createSync(recursive: true);

      for (final fileName in screenshotFiles) {
        final rawFile = File('$inputDir/$fileName');

        // Skip missing raw screenshots — don't produce blank placeholders
        if (!rawFile.existsSync()) {
          print('  ⚠️  Skipped (missing raw): $fileName');
          totalSkipped++;
          continue;
        }

        final rawBytes = rawFile.readAsBytesSync();
        final rawImg = img.decodeImage(rawBytes);
        if (rawImg == null) {
          print('  ⚠️  Skipped (decode failed): $fileName');
          totalSkipped++;
          continue;
        }

        // ── Build canvas with gradient background ──────────────────────────
        final canvas = img.Image(width: tw, height: th);
        _fillGradient(canvas, tw, th, brandColor, darkColor);

        // ── Scale screenshot to fit inside canvas ─────────────────────────
        // Leave 3% padding sides, 4% top, 2% bottom for optimal store display
        final padX = (tw * 0.03).toInt();
        final padTop = (th * 0.04).toInt();
        final padBottom = (th * 0.02).toInt();
        final maxW = tw - padX * 2;
        final maxH = th - padTop - padBottom;

        // Scale proportionally to fit maxW × maxH
        double scale = math.min(maxW / rawImg.width, maxH / rawImg.height);
        final scaledW = (rawImg.width * scale).toInt();
        final scaledH = (rawImg.height * scale).toInt();
        final scaled = img.copyResize(rawImg, width: scaledW, height: scaledH,
            interpolation: img.Interpolation.cubic);

        // Center horizontally; align to top of available area
        final posX = (tw - scaledW) ~/ 2;
        final posY = padTop;

        // Draw subtle white shadow behind the device screenshot
        _drawShadow(canvas, posX, posY, scaledW, scaledH);

        img.compositeImage(canvas, scaled, dstX: posX, dstY: posY);

        final outFile = File('${outFolder.path}/$fileName');
        outFile.writeAsBytesSync(img.encodePng(canvas));
        print('  ✅ ${tw}x${th} → ${outFile.path}'); // ignore: unnecessary_brace_in_string_interps
        totalGenerated++;
      }
    }
  }

  print('\n✅ Done — $totalGenerated screenshots generated, $totalSkipped skipped.');
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Fills [canvas] with a vertical gradient from [top] to [bottom].
void _fillGradient(img.Image canvas, int w, int h, img.Color top, img.Color bottom) {
  for (int y = 0; y < h; y++) {
    final t = y / h;
    final r = (top.r + (bottom.r - top.r) * t).round().clamp(0, 255);
    final g = (top.g + (bottom.g - top.g) * t).round().clamp(0, 255);
    final b = (top.b + (bottom.b - top.b) * t).round().clamp(0, 255);
    img.drawLine(canvas, x1: 0, y1: y, x2: w, y2: y, color: img.ColorRgb8(r, g, b));
  }
}

/// Draws a semi-transparent shadow around the screenshot for depth.
void _drawShadow(img.Image canvas, int x, int y, int w, int h) {
  const shadowOpacity = 60; // 0-255
  const shadowSpread = 12;
  for (int s = shadowSpread; s > 0; s--) {
    final opacity = (shadowOpacity * (1 - s / shadowSpread)).toInt();
    img.drawRect(
      canvas,
      x1: x - s,
      y1: y - s,
      x2: x + w + s,
      y2: y + h + s,
      color: img.ColorRgba8(0, 0, 0, opacity),
    );
  }
}
