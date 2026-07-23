// ignore_for_file: avoid_print
// =============================================================================
// frame_screenshots.dart
//
// Takes raw screenshots captured by test_driver/screenshot_driver.dart and
// frames them into professional store-ready assets with gradient backgrounds,
// marketing titles, and a realistic phone bezel.
//
// Usage:
//   dart scripts/frame_screenshots.dart --client Tasneem --input-dir raw_screenshots
// =============================================================================

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

const _screenshotTitles = <String, String>{
  '01_splash.png': 'شاشة البداية',
  '02_onboarding_or_login.png': 'محتوى تعليمي شامل',
  '03_guest_home.png': 'استكشف الكورسات والدورات',
  '04_main_screen.png': 'تابع دروسك بسهولة',
  '05_library_screen.png': 'مكتبتي ودوراتي',
  '06_profile_screen.png': 'إدارة الملف الشخصي',
};

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

  final clientConfigFile = File('clients/$client/client_config.json');
  img.Color brandColor = img.ColorRgb8(37, 99, 235);
  String appName = client;

  if (clientConfigFile.existsSync()) {
    final cfg = jsonDecode(await clientConfigFile.readAsString()) as Map;
    appName = (cfg['appName'] as String?) ?? client;
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

  final lightColor = img.ColorRgb8(
    math.min(255, brandColor.r.toInt() + 25),
    math.min(255, brandColor.g.toInt() + 25),
    math.min(255, brandColor.b.toInt() + 25),
  );
  final darkColor = img.ColorRgb8(
    math.max(0, brandColor.r.toInt() - 30),
    math.max(0, brandColor.g.toInt() - 30),
    math.max(0, brandColor.b.toInt() - 30),
  );

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

  final screenshotFiles = _screenshotTitles.keys.toList();
  var totalGenerated = 0;
  var totalSkipped = 0;

  for (final storeEntry in targets.entries) {
    final store = storeEntry.key;
    final sizes = storeEntry.value;
    final isTablet = store.contains('tablet') || store.contains('ipad');

    for (final sizeMap in sizes) {
      final sizeName = sizeMap['name'] as String;
      final tw = sizeMap['w'] as int;
      final th = sizeMap['h'] as int;

      final outFolder = Directory('$outputDir/$client/$store/$sizeName');
      if (!outFolder.existsSync()) outFolder.createSync(recursive: true);

      for (final fileName in screenshotFiles) {
        final rawFile = File('$inputDir/$fileName');
        if (!rawFile.existsSync()) {
          print('  ⚠️  Skipped (missing raw): $fileName');
          totalSkipped++;
          continue;
        }

        final rawImg = img.decodeImage(rawFile.readAsBytesSync());
        if (rawImg == null) {
          print('  ⚠️  Skipped (decode failed): $fileName');
          totalSkipped++;
          continue;
        }

        final canvas = img.Image(width: tw, height: th);
        _fillGradient(canvas, tw, th, lightColor, darkColor);
        _drawTitleBanner(
          canvas,
          tw,
          th,
          _screenshotTitles[fileName] ?? appName,
        );
        _compositePhoneFrame(
          canvas: canvas,
          rawImg: rawImg,
          tw: tw,
          th: th,
          isTablet: isTablet,
        );

        final outFile = File('${outFolder.path}/$fileName');
        outFile.writeAsBytesSync(img.encodePng(canvas));
        print('  ✅ ${tw}x$th → ${outFile.path}');
        totalGenerated++;
      }
    }
  }

  print('\n✅ Done — $totalGenerated screenshots generated, $totalSkipped skipped.');
}

void _fillGradient(
  img.Image canvas,
  int w,
  int h,
  img.Color top,
  img.Color bottom,
) {
  for (var y = 0; y < h; y++) {
    final t = y / h;
    final r = (top.r + (bottom.r - top.r) * t).round().clamp(0, 255);
    final g = (top.g + (bottom.g - top.g) * t).round().clamp(0, 255);
    final b = (top.b + (bottom.b - top.b) * t).round().clamp(0, 255);
    img.drawLine(
      canvas,
      x1: 0,
      y1: y,
      x2: w,
      y2: y,
      color: img.ColorRgb8(r, g, b),
    );
  }
}

void _drawTitleBanner(img.Image canvas, int tw, int th, String title) {
  final bannerHeight = (th * 0.09).toInt();
  final overlay = img.ColorRgba8(255, 255, 255, 28);
  img.fillRect(
    canvas,
    x1: 0,
    y1: 0,
    x2: tw,
    y2: bannerHeight,
    color: overlay,
  );

  final font = img.arial24;
  final estimatedTextWidth = title.length * 14;
  final textX = math.max(24, (tw - estimatedTextWidth) ~/ 2);
  const textY = 28;

  img.drawString(
    canvas,
    title,
    font: font,
    x: textX + 2,
    y: textY + 2,
    color: img.ColorRgba8(0, 0, 0, 90),
  );
  img.drawString(
    canvas,
    title,
    font: font,
    x: textX,
    y: textY,
    color: img.ColorRgb8(255, 255, 255),
  );
}

void _compositePhoneFrame({
  required img.Image canvas,
  required img.Image rawImg,
  required int tw,
  required int th,
  required bool isTablet,
}) {
  final headerMargin = (th * (isTablet ? 0.14 : 0.12)).toInt();
  final sideMargin = (tw * (isTablet ? 0.12 : 0.08)).toInt();
  final bottomMargin = (th * 0.05).toInt();

  var deviceWidth = tw - sideMargin * 2;
  var scale = deviceWidth / rawImg.width;
  var deviceHeight = (rawImg.height * scale).round();
  final maxDeviceHeight = th - headerMargin - bottomMargin;

  if (deviceHeight > maxDeviceHeight) {
    deviceHeight = maxDeviceHeight;
    scale = deviceHeight / rawImg.height;
    deviceWidth = (rawImg.width * scale).round();
  }

  final scaled = img.copyResize(
    rawImg,
    width: deviceWidth,
    height: deviceHeight,
    interpolation: img.Interpolation.cubic,
  );

  final deviceX = (tw - deviceWidth) ~/ 2;
  final deviceY = headerMargin + (maxDeviceHeight - deviceHeight) ~/ 2;
  final borderRadius = (tw * (isTablet ? 0.025 : 0.04)).round();
  final bezelPadding = (tw * 0.015).round();
  final bezelColor = img.ColorRgb8(15, 23, 42);

  _drawDeviceShadow(
    canvas,
    deviceX - bezelPadding,
    deviceY - bezelPadding,
    deviceWidth + bezelPadding * 2,
    deviceHeight + bezelPadding * 2,
    borderRadius + bezelPadding,
  );

  img.fillRect(
    canvas,
    x1: deviceX - bezelPadding,
    y1: deviceY - bezelPadding,
    x2: deviceX + deviceWidth + bezelPadding,
    y2: deviceY + deviceHeight + bezelPadding,
    color: bezelColor,
    radius: borderRadius + bezelPadding,
  );

  img.fillRect(
    canvas,
    x1: deviceX - bezelPadding + 2,
    y1: deviceY - bezelPadding + 2,
    x2: deviceX + deviceWidth + bezelPadding - 2,
    y2: deviceY + deviceHeight + bezelPadding - 2,
    color: img.ColorRgb8(30, 41, 59),
    radius: borderRadius + bezelPadding - 2,
  );

  final clipped = _clipRoundedCorners(scaled, borderRadius);
  img.compositeImage(canvas, clipped, dstX: deviceX, dstY: deviceY);

  if (!isTablet) {
    _drawDynamicIsland(canvas, deviceX, deviceY, deviceWidth);
  }

  img.drawRect(
    canvas,
    x1: deviceX,
    y1: deviceY,
    x2: deviceX + deviceWidth,
    y2: deviceY + deviceHeight,
    color: img.ColorRgba8(255, 255, 255, 35),
    radius: borderRadius,
  );
}

img.Image _clipRoundedCorners(img.Image source, int radius) {
  final output = img.Image.from(source);
  final mask = img.Image(width: source.width, height: source.height, numChannels: 1);
  img.fill(mask, color: img.ColorRgb8(0, 0, 0));
  img.fillRect(
    mask,
    x1: 0,
    y1: 0,
    x2: source.width,
    y2: source.height,
    color: img.ColorRgb8(255, 255, 255),
    radius: radius,
  );

  for (var y = 0; y < output.height; y++) {
    for (var x = 0; x < output.width; x++) {
      final alpha = mask.getPixel(x, y).r;
      if (alpha == 0) {
        output.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  return output;
}

void _drawDynamicIsland(img.Image canvas, int deviceX, int deviceY, int deviceWidth) {
  final islandW = (deviceWidth * 0.28).round();
  final islandH = (deviceWidth * 0.045).round().clamp(18, 34);
  final islandX = deviceX + (deviceWidth - islandW) ~/ 2;
  final islandY = deviceY + (deviceWidth * 0.025).round();

  img.fillRect(
    canvas,
    x1: islandX,
    y1: islandY,
    x2: islandX + islandW,
    y2: islandY + islandH,
    color: img.ColorRgb8(0, 0, 0),
    radius: islandH ~/ 2,
  );
}

void _drawDeviceShadow(
  img.Image canvas,
  int x,
  int y,
  int w,
  int h,
  int radius,
) {
  for (var spread = 18; spread > 0; spread--) {
    final opacity = (55 * (1 - spread / 18)).round().clamp(0, 55);
    img.drawRect(
      canvas,
      x1: x - spread,
      y1: y - spread + 6,
      x2: x + w + spread,
      y2: y + h + spread + 6,
      color: img.ColorRgba8(0, 0, 0, opacity),
      radius: radius + spread,
    );
  }
}
