// ignore_for_file: avoid_print
// =============================================================================
// generate_store_screenshots.dart
//
// Generates professional store screenshots WITHOUT an emulator.
// Draws beautiful UI mockups for each client using their logo & brand colors.
//
// Usage:
//   dart scripts/generate_store_screenshots.dart --client Tasneem
//   dart scripts/generate_store_screenshots.dart  (generates all clients)
// =============================================================================

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------
void main(List<String> args) async {
  String? targetClient;
  String outputDir = 'output/store_assets';

  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--client' && i + 1 < args.length) targetClient = args[i + 1];
    if (args[i] == '--output-dir' && i + 1 < args.length) outputDir = args[i + 1];
  }

  final clientsDir = Directory('clients');
  final clients = targetClient != null
      ? [targetClient]
      : clientsDir
          .listSync()
          .whereType<Directory>()
          .map((d) => d.uri.pathSegments.lastWhere((s) => s.isNotEmpty))
          .toList();

  for (final client in clients) {
    print('\n📱 Generating screenshots for: $client');
    await generateForClient(client, outputDir);
  }

  print('\n✅ All store screenshots generated in: $outputDir/');
}

// ---------------------------------------------------------------------------
// Client config + brand color
// ---------------------------------------------------------------------------
Future<ClientConfig> loadConfig(String client) async {
  final file = File('clients/$client/client_config.json');
  String appName = client;
  String slogan = 'Your learning partner';
  img.Color primary = img.ColorRgb8(37, 99, 235);
  img.Color secondary = img.ColorRgb8(99, 155, 255);

  if (file.existsSync()) {
    final cfg = jsonDecode(await file.readAsString()) as Map;
    appName = cfg['appName'] ?? client;
    slogan = cfg['slogan'] ?? slogan;
    final hex = cfg['fallbackPrimaryColor'] as String?;
    if (hex != null) {
      final cleaned = hex.replaceAll(RegExp(r'^0xFF|^0xff|^#'), '');
      if (cleaned.length == 6) {
        final r = int.parse(cleaned.substring(0, 2), radix: 16);
        final g = int.parse(cleaned.substring(2, 4), radix: 16);
        final b = int.parse(cleaned.substring(4, 6), radix: 16);
        primary = img.ColorRgb8(r, g, b);
        // Slightly lighter secondary
        secondary = img.ColorRgb8(
          math.min(r + 40, 255),
          math.min(g + 40, 255),
          math.min(b + 40, 255),
        );
      }
    }
  }

  img.Image? logo;
  final logoFile = File('clients/$client/logo/logo.png');
  if (logoFile.existsSync()) {
    logo = img.decodeImage(logoFile.readAsBytesSync());
  }

  return ClientConfig(
    name: client,
    appName: appName,
    slogan: slogan,
    primary: primary,
    secondary: secondary,
    logo: logo,
  );
}

class ClientConfig {
  final String name;
  final String appName;
  final String slogan;
  final img.Color primary;
  final img.Color secondary;
  final img.Image? logo;
  const ClientConfig({
    required this.name,
    required this.appName,
    required this.slogan,
    required this.primary,
    required this.secondary,
    required this.logo,
  });
}

// ---------------------------------------------------------------------------
// Store sizes
// ---------------------------------------------------------------------------
const storeSizes = {
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

// ---------------------------------------------------------------------------
// Screen definitions
// ---------------------------------------------------------------------------
typedef ScreenPainter = img.Image Function(int w, int h, ClientConfig cfg);

final List<Map<String, dynamic>> screens = [
  {'name': '01_splash.png', 'label': 'Welcome', 'painter': paintSplash},
  {'name': '02_onboarding.png', 'label': 'Onboarding', 'painter': paintOnboarding},
  {'name': '03_home.png', 'label': 'Home', 'painter': paintHome},
  {'name': '04_courses.png', 'label': 'Courses', 'painter': paintCourses},
  {'name': '05_video_player.png', 'label': 'Video', 'painter': paintVideoPlayer},
  {'name': '06_profile.png', 'label': 'Profile', 'painter': paintProfile},
];

// ---------------------------------------------------------------------------
// Main generator
// ---------------------------------------------------------------------------
Future<void> generateForClient(String client, String outputDir) async {
  final cfg = await loadConfig(client);

  for (final storeEntry in storeSizes.entries) {
    final store = storeEntry.key;
    for (final sizeMap in storeEntry.value) {
      final sizeName = sizeMap['name'] as String;
      final tw = sizeMap['w'] as int;
      final th = sizeMap['h'] as int;
      final outFolder = Directory('$outputDir/$client/$store/$sizeName');
      if (!outFolder.existsSync()) outFolder.createSync(recursive: true);

      for (final screen in screens) {
        final painter = screen['painter'] as ScreenPainter;
        final canvas = painter(tw, th, cfg);
        final outFile = File('${outFolder.path}/${screen['name']}');
        outFile.writeAsBytesSync(img.encodePng(canvas));
        print('  ✅ ${outFile.path}');
      }
    }
  }
}

// ===========================================================================
// DRAWING HELPERS
// ===========================================================================

img.Color lighten(img.Color c, double factor) => img.ColorRgb8(
      math.min(255, (c.r + (255 - c.r) * factor).toInt()),
      math.min(255, (c.g + (255 - c.g) * factor).toInt()),
      math.min(255, (c.b + (255 - c.b) * factor).toInt()),
    );

img.Color darken(img.Color c, double factor) => img.ColorRgb8(
      math.max(0, (c.r * (1 - factor)).toInt()),
      math.max(0, (c.g * (1 - factor)).toInt()),
      math.max(0, (c.b * (1 - factor)).toInt()),
    );

img.Color white() => img.ColorRgb8(255, 255, 255);
img.Color lightGray() => img.ColorRgb8(240, 243, 247);
img.Color gray() => img.ColorRgb8(180, 186, 194);
img.Color darkGray() => img.ColorRgb8(80, 90, 105);
img.Color nearBlack() => img.ColorRgb8(18, 24, 38);

/// Filled rounded rectangle
void fillRoundRect(img.Image canvas, int x, int y, int w, int h, int radius, img.Color color) {
  // Fill center
  img.fillRect(canvas, x1: x + radius, y1: y, x2: x + w - radius, y2: y + h, color: color);
  img.fillRect(canvas, x1: x, y1: y + radius, x2: x + w, y2: y + h - radius, color: color);
  // Corners (crude approximation using circles)
  img.fillCircle(canvas, x: x + radius, y: y + radius, radius: radius, color: color);
  img.fillCircle(canvas, x: x + w - radius, y: y + radius, radius: radius, color: color);
  img.fillCircle(canvas, x: x + radius, y: y + h - radius, radius: radius, color: color);
  img.fillCircle(canvas, x: x + w - radius, y: y + h - radius, radius: radius, color: color);
}

/// Place logo centered at (cx, cy) with max width maxW
void placeLogo(img.Image canvas, img.Image? logo, int cx, int cy, int maxW) {
  if (logo == null) return;
  final scale = maxW / logo.width;
  final newH = (logo.height * scale).toInt();
  final scaled = img.copyResize(logo, width: maxW, height: newH);
  final dx = cx - maxW ~/ 2;
  final dy = cy - newH ~/ 2;
  img.compositeImage(canvas, scaled, dstX: dx, dstY: dy, blend: img.BlendMode.alpha);
}

/// Draw simple horizontal nav bar at bottom
void drawBottomNav(img.Image canvas, int w, int h, img.Color primary) {
  final navH = (h * 0.09).toInt();
  final navY = h - navH;
  img.fillRect(canvas, x1: 0, y1: navY, x2: w, y2: h, color: white());
  // Top divider
  img.drawLine(canvas, x1: 0, y1: navY, x2: w, y2: navY, color: lightGray());
  // 4 icon dots
  final tabs = 4;
  for (int i = 0; i < tabs; i++) {
    final cx = (w / tabs * i + w / tabs / 2).toInt();
    final cy = navY + navH ~/ 2;
    final isActive = i == 0;
    final col = isActive ? primary : gray();
    img.fillCircle(canvas, x: cx, y: cy - (navH * 0.1).toInt(), radius: (navH * 0.16).toInt(), color: col);
    img.fillRect(canvas, x1: cx - (w * 0.04).toInt(), y1: cy + (navH * 0.08).toInt(), x2: cx + (w * 0.04).toInt(), y2: cy + (navH * 0.18).toInt(), color: col);
  }
}

/// Draw simple status bar at top
void drawStatusBar(img.Image canvas, int w, bool dark) {
  final h = (canvas.height * 0.04).toInt();
  final col = dark ? white() : nearBlack();
  // Battery block
  img.fillRect(canvas, x1: w - (w * 0.07).toInt(), y1: h ~/ 4, x2: w - (w * 0.02).toInt(), y2: h * 3 ~/ 4, color: col);
  // Signal dots
  for (int i = 0; i < 3; i++) {
    img.fillCircle(canvas, x: (w * 0.05).toInt() + i * (w * 0.025).toInt(), y: h ~/ 2, radius: 4, color: col);
  }
}

/// Draw a card (white rounded rectangle with shadow effect)
void drawCard(img.Image canvas, int x, int y, int w, int h, {int radius = 24}) {
  // Shadow
  fillRoundRect(canvas, x + 4, y + 4, w, h, radius, img.ColorRgba8(0, 0, 0, 30));
  fillRoundRect(canvas, x, y, w, h, radius, white());
}

/// Draw text-like horizontal bars (since package:image doesn't do text rendering)
void drawTextBar(img.Image canvas, int x, int y, int length, int thickness, img.Color color, {double opacity = 1.0}) {
  final c = opacity < 1.0
      ? img.ColorRgba8(color.r.toInt(), color.g.toInt(), color.b.toInt(), (255 * opacity).toInt())
      : color;
  img.fillRect(canvas, x1: x, y1: y, x2: x + length, y2: y + thickness, color: c);
}

/// Draw multiple text lines to simulate paragraph
void drawTextBlock(img.Image canvas, int x, int y, int maxW, int lineHeight, int lines, img.Color color, {double firstLineWidthFactor = 0.9, double opacity = 1.0}) {
  final widths = [1.0, 0.75, 0.85, 0.6, 0.8];
  for (int i = 0; i < lines; i++) {
    final w = (maxW * (i == 0 ? firstLineWidthFactor : widths[i % widths.length])).toInt();
    drawTextBar(canvas, x, y + i * lineHeight, w, (lineHeight * 0.5).toInt(), color, opacity: opacity);
  }
}

// ===========================================================================
// SCREEN PAINTERS
// ===========================================================================

/// 01 - Splash / Welcome
img.Image paintSplash(int w, int h, ClientConfig cfg) {
  final canvas = img.Image(width: w, height: h);
  // Gradient background: primary top -> slightly darker bottom
  for (int y = 0; y < h; y++) {
    final t = y / h;
    final c = img.ColorRgb8(
      (cfg.primary.r + (darken(cfg.primary, 0.25).r - cfg.primary.r) * t).toInt(),
      (cfg.primary.g + (darken(cfg.primary, 0.25).g - cfg.primary.g) * t).toInt(),
      (cfg.primary.b + (darken(cfg.primary, 0.25).b - cfg.primary.b) * t).toInt(),
    );
    img.drawLine(canvas, x1: 0, y1: y, x2: w, y2: y, color: c);
  }

  // Decorative circles
  img.fillCircle(canvas, x: -w ~/ 4, y: -h ~/ 8, radius: (w * 0.5).toInt(), color: lighten(cfg.primary, 0.15));
  img.fillCircle(canvas, x: w + w ~/ 4, y: h + h ~/ 8, radius: (w * 0.45).toInt(), color: darken(cfg.primary, 0.15));

  // Logo centered
  placeLogo(canvas, cfg.logo, w ~/ 2, h ~/ 2 - (h * 0.07).toInt(), (w * 0.45).toInt());

  // App name bar (simulated text)
  final nameBarW = (w * 0.45).toInt();
  drawTextBar(canvas, w ~/ 2 - nameBarW ~/ 2, h ~/ 2 + (h * 0.09).toInt(), nameBarW, (h * 0.025).toInt(), white());

  // Slogan bar
  final sloganW = (w * 0.55).toInt();
  drawTextBar(canvas, w ~/ 2 - sloganW ~/ 2, h ~/ 2 + (h * 0.13).toInt(), sloganW, (h * 0.014).toInt(), white(), opacity: 0.7);

  // Loading bar at bottom
  final barW = (w * 0.35).toInt();
  final barH = (h * 0.006).toInt();
  final barY = h - (h * 0.08).toInt();
  img.fillRect(canvas, x1: w ~/ 2 - barW ~/ 2, y1: barY, x2: w ~/ 2 + barW ~/ 2, y2: barY + barH, color: img.ColorRgba8(255, 255, 255, 60));
  img.fillRect(canvas, x1: w ~/ 2 - barW ~/ 2, y1: barY, x2: w ~/ 2 - barW ~/ 2 + (barW * 0.65).toInt(), y2: barY + barH, color: white());

  drawStatusBar(canvas, w, true);
  return canvas;
}

/// 02 - Onboarding
img.Image paintOnboarding(int w, int h, ClientConfig cfg) {
  final canvas = img.Image(width: w, height: h);
  img.fill(canvas, color: lightGray());

  // Top colored hero section
  final heroH = (h * 0.5).toInt();
  for (int y = 0; y < heroH; y++) {
    final t = y / heroH;
    final c = img.ColorRgb8(
      (cfg.primary.r + (lighten(cfg.primary, 0.2).r - cfg.primary.r) * t).toInt(),
      (cfg.primary.g + (lighten(cfg.primary, 0.2).g - cfg.primary.g) * t).toInt(),
      (cfg.primary.b + (lighten(cfg.primary, 0.2).b - cfg.primary.b) * t).toInt(),
    );
    img.drawLine(canvas, x1: 0, y1: y, x2: w, y2: y, color: c);
  }

  // Wavy divider
  fillRoundRect(canvas, 0, heroH - (h * 0.04).toInt(), w, (h * 0.06).toInt(), (w * 0.05).toInt(), lightGray());

  // Logo in hero
  placeLogo(canvas, cfg.logo, w ~/ 2, heroH ~/ 2, (w * 0.38).toInt());

  // Content card below hero
  final cardX = (w * 0.06).toInt();
  final cardY = heroH + (h * 0.04).toInt();
  final cardW = (w * 0.88).toInt();
  final cardH = (h * 0.32).toInt();
  drawCard(canvas, cardX, cardY, cardW, cardH);

  final contentX = cardX + (cardW * 0.1).toInt();
  final contentY = cardY + (cardH * 0.12).toInt();
  final contentW = (cardW * 0.8).toInt();
  // Title
  drawTextBar(canvas, contentX, contentY, (contentW * 0.7).toInt(), (h * 0.022).toInt(), nearBlack());
  // Body text
  drawTextBlock(canvas, contentX, contentY + (h * 0.04).toInt(), contentW, (h * 0.02).toInt(), 3, darkGray(), opacity: 0.6);

  // CTA button
  final btnY = cardY + cardH - (h * 0.065).toInt();
  final btnH = (h * 0.045).toInt();
  final btnX = contentX;
  final btnW = (contentW * 0.6).toInt();
  fillRoundRect(canvas, btnX, btnY, btnW, btnH, btnH ~/ 2, cfg.primary);
  drawTextBar(canvas, btnX + (btnW * 0.25).toInt(), btnY + btnH ~/ 2 - (h * 0.007).toInt(), (btnW * 0.5).toInt(), (h * 0.013).toInt(), white());

  // Dots indicator
  final dotsY = cardY + cardH + (h * 0.02).toInt();
  for (int i = 0; i < 3; i++) {
    final dotX = w ~/ 2 - 30 + i * 30;
    img.fillCircle(canvas, x: dotX, y: dotsY, radius: i == 0 ? 10 : 7, color: i == 0 ? cfg.primary : gray());
  }

  drawStatusBar(canvas, w, false);
  return canvas;
}

/// 03 - Home screen
img.Image paintHome(int w, int h, ClientConfig cfg) {
  final canvas = img.Image(width: w, height: h);
  img.fill(canvas, color: lightGray());

  // Header bar
  final headerH = (h * 0.13).toInt();
  img.fillRect(canvas, x1: 0, y1: 0, x2: w, y2: headerH, color: cfg.primary);

  // Avatar circle in header
  img.fillCircle(canvas, x: (w * 0.12).toInt(), y: headerH ~/ 2 + (h * 0.01).toInt(), radius: (headerH * 0.3).toInt(), color: lighten(cfg.primary, 0.3));

  // Greeting bars in header
  drawTextBar(canvas, (w * 0.22).toInt(), (headerH * 0.35).toInt(), (w * 0.35).toInt(), (h * 0.016).toInt(), white());
  drawTextBar(canvas, (w * 0.22).toInt(), (headerH * 0.57).toInt(), (w * 0.25).toInt(), (h * 0.012).toInt(), white(), opacity: 0.7);

  // Notification bell icon on right
  img.fillCircle(canvas, x: (w * 0.88).toInt(), y: headerH ~/ 2, radius: (headerH * 0.2).toInt(), color: lighten(cfg.primary, 0.3));

  // Featured banner card
  final bannerX = (w * 0.04).toInt();
  final bannerY = headerH + (h * 0.025).toInt();
  final bannerW = (w * 0.92).toInt();
  final bannerH = (h * 0.18).toInt();
  for (int y = bannerY; y < bannerY + bannerH; y++) {
    final t = (y - bannerY) / bannerH;
    final c = img.ColorRgb8(
      (cfg.secondary.r + (darken(cfg.secondary, 0.1).r - cfg.secondary.r) * t).toInt(),
      (cfg.secondary.g + (darken(cfg.secondary, 0.1).g - cfg.secondary.g) * t).toInt(),
      (cfg.secondary.b + (darken(cfg.secondary, 0.1).b - cfg.secondary.b) * t).toInt(),
    );
    img.drawLine(canvas, x1: bannerX, y1: y, x2: bannerX + bannerW, y2: y, color: c);
  }
  fillRoundRect(canvas, bannerX, bannerY, bannerW, bannerH, 20, cfg.secondary);

  drawTextBar(canvas, bannerX + (w * 0.05).toInt(), bannerY + (bannerH * 0.25).toInt(), (bannerW * 0.5).toInt(), (h * 0.02).toInt(), white());
  drawTextBlock(canvas, bannerX + (w * 0.05).toInt(), bannerY + (bannerH * 0.45).toInt(), (bannerW * 0.55).toInt(), (h * 0.018).toInt(), 2, white(), opacity: 0.8);

  // "Latest Courses" section title
  final sectionY = bannerY + bannerH + (h * 0.025).toInt();
  drawTextBar(canvas, (w * 0.04).toInt(), sectionY, (w * 0.35).toInt(), (h * 0.018).toInt(), nearBlack());

  // Course cards row
  final cardY = sectionY + (h * 0.04).toInt();
  final cardW = (w * 0.43).toInt();
  final cardH = (h * 0.22).toInt();
  for (int i = 0; i < 2; i++) {
    final cx = (w * 0.04).toInt() + i * ((w * 0.48).toInt());
    drawCard(canvas, cx, cardY, cardW, cardH);
    // Thumbnail
    final thumbH = (cardH * 0.5).toInt();
    fillRoundRect(canvas, cx, cardY, cardW, thumbH, 20, lighten(cfg.primary, 0.4));
    placeLogo(canvas, cfg.logo, cx + cardW ~/ 2, cardY + thumbH ~/ 2, (cardW * 0.5).toInt());
    // Text
    drawTextBar(canvas, cx + (cardW * 0.07).toInt(), cardY + thumbH + (cardH * 0.1).toInt(), (cardW * 0.75).toInt(), (h * 0.015).toInt(), nearBlack());
    drawTextBar(canvas, cx + (cardW * 0.07).toInt(), cardY + thumbH + (cardH * 0.22).toInt(), (cardW * 0.45).toInt(), (h * 0.012).toInt(), darkGray(), opacity: 0.6);
    // Rating dots
    for (int s = 0; s < 5; s++) {
      img.fillCircle(canvas, x: cx + (cardW * 0.07).toInt() + s * 14, y: cardY + thumbH + (cardH * 0.38).toInt(), radius: 5, color: s < 4 ? cfg.primary : gray());
    }
  }

  drawBottomNav(canvas, w, h, cfg.primary);
  drawStatusBar(canvas, w, false);
  return canvas;
}

/// 04 - Courses listing
img.Image paintCourses(int w, int h, ClientConfig cfg) {
  final canvas = img.Image(width: w, height: h);
  img.fill(canvas, color: lightGray());

  // Header
  final headerH = (h * 0.11).toInt();
  img.fillRect(canvas, x1: 0, y1: 0, x2: w, y2: headerH, color: cfg.primary);
  drawTextBar(canvas, (w * 0.1).toInt(), headerH ~/ 2 - (h * 0.01).toInt(), (w * 0.5).toInt(), (h * 0.02).toInt(), white());

  // Search bar
  final searchY = headerH + (h * 0.02).toInt();
  final searchH = (h * 0.055).toInt();
  drawCard(canvas, (w * 0.04).toInt(), searchY, (w * 0.92).toInt(), searchH, radius: searchH ~/ 2);
  img.fillCircle(canvas, x: (w * 0.1).toInt(), y: searchY + searchH ~/ 2, radius: (searchH * 0.22).toInt(), color: gray());
  drawTextBar(canvas, (w * 0.16).toInt(), searchY + searchH ~/ 2 - (h * 0.008).toInt(), (w * 0.35).toInt(), (h * 0.013).toInt(), gray());

  // Category chips
  final chipY = searchY + searchH + (h * 0.02).toInt();
  final chipH = (h * 0.04).toInt();
  final chipLabels = [true, false, false, false];
  for (int i = 0; i < 4; i++) {
    final chipX = (w * 0.04).toInt() + i * ((w * 0.23).toInt());
    final chipW = (w * 0.2).toInt();
    fillRoundRect(canvas, chipX, chipY, chipW, chipH, chipH ~/ 2, chipLabels[i] ? cfg.primary : white());
    drawTextBar(canvas, chipX + (chipW * 0.2).toInt(), chipY + chipH ~/ 2 - (h * 0.006).toInt(), (chipW * 0.6).toInt(), (h * 0.011).toInt(), chipLabels[i] ? white() : gray());
  }

  // Course list items
  final listStartY = chipY + chipH + (h * 0.025).toInt();
  final itemH = (h * 0.13).toInt();
  final itemGap = (h * 0.015).toInt();

  for (int i = 0; i < 4; i++) {
    final itemY = listStartY + i * (itemH + itemGap);
    if (itemY + itemH > h - (h * 0.1).toInt()) break;
    drawCard(canvas, (w * 0.04).toInt(), itemY, (w * 0.92).toInt(), itemH);
    // Thumbnail
    final thumbW = (itemH * 0.85).toInt();
    fillRoundRect(canvas, (w * 0.05).toInt(), itemY + (itemH * 0.08).toInt(), thumbW, (itemH * 0.84).toInt(), 12, lighten(cfg.primary, 0.35));
    placeLogo(canvas, cfg.logo, (w * 0.05).toInt() + thumbW ~/ 2, itemY + itemH ~/ 2, (thumbW * 0.65).toInt());
    // Text
    final textX = (w * 0.05).toInt() + thumbW + (w * 0.04).toInt();
    drawTextBar(canvas, textX, itemY + (itemH * 0.2).toInt(), (w * 0.42).toInt(), (h * 0.016).toInt(), nearBlack());
    drawTextBar(canvas, textX, itemY + (itemH * 0.4).toInt(), (w * 0.3).toInt(), (h * 0.012).toInt(), darkGray(), opacity: 0.6);
    // Progress bar
    final progY = itemY + (itemH * 0.65).toInt();
    img.fillRect(canvas, x1: textX, y1: progY, x2: textX + (w * 0.42).toInt(), y2: progY + (h * 0.006).toInt(), color: lightGray());
    img.fillRect(canvas, x1: textX, y1: progY, x2: textX + (w * (0.1 + i * 0.08)).toInt(), y2: progY + (h * 0.006).toInt(), color: cfg.primary);
  }

  drawBottomNav(canvas, w, h, cfg.primary);
  drawStatusBar(canvas, w, false);
  return canvas;
}

/// 05 - Video player
img.Image paintVideoPlayer(int w, int h, ClientConfig cfg) {
  final canvas = img.Image(width: w, height: h);
  img.fill(canvas, color: nearBlack());

  // Video area (top 40%)
  final videoH = (h * 0.4).toInt();
  img.fillRect(canvas, x1: 0, y1: 0, x2: w, y2: videoH, color: img.ColorRgb8(12, 16, 28));
  // Play button
  final cx = w ~/ 2;
  final cy = videoH ~/ 2;
  final btnR = (w * 0.08).toInt();
  img.fillCircle(canvas, x: cx, y: cy, radius: btnR, color: img.ColorRgba8(255, 255, 255, 200));
  // Triangle (crude)
  for (int py = cy - (btnR ~/ 2); py <= cy + (btnR ~/ 2); py++) {
    final row = py - (cy - btnR ~/ 2);
    final rowW = (row * 0.7).toInt();
    img.drawLine(canvas, x1: cx - rowW ~/ 4, y1: py, x2: cx - rowW ~/ 4 + rowW, y2: py, color: cfg.primary);
  }
  // Logo watermark top left
  placeLogo(canvas, cfg.logo, (w * 0.1).toInt(), (h * 0.035).toInt(), (w * 0.15).toInt());

  // Progress bar
  final progY = videoH - (h * 0.025).toInt();
  img.fillRect(canvas, x1: 0, y1: progY, x2: w, y2: progY + (h * 0.006).toInt(), color: img.ColorRgba8(255, 255, 255, 50));
  img.fillRect(canvas, x1: 0, y1: progY, x2: (w * 0.38).toInt(), y2: progY + (h * 0.006).toInt(), color: cfg.primary);

  // Bottom panel (dark card)
  final panelY = videoH + (h * 0.01).toInt();
  final panelH = h - panelY;
  img.fillRect(canvas, x1: 0, y1: panelY, x2: w, y2: h, color: img.ColorRgb8(22, 28, 42));

  // Course title
  drawTextBar(canvas, (w * 0.06).toInt(), panelY + (h * 0.04).toInt(), (w * 0.7).toInt(), (h * 0.022).toInt(), white());
  drawTextBar(canvas, (w * 0.06).toInt(), panelY + (h * 0.075).toInt(), (w * 0.45).toInt(), (h * 0.014).toInt(), gray(), opacity: 0.7);

  // Lesson list
  final lessonStart = panelY + (h * 0.13).toInt();
  for (int i = 0; i < 5; i++) {
    final ly = lessonStart + i * (h * 0.065).toInt();
    final isActive = i == 2;
    if (isActive) {
      img.fillRect(canvas, x1: 0, y1: ly - (h * 0.005).toInt(), x2: w, y2: ly + (h * 0.06).toInt(), color: img.ColorRgb8(30, 38, 58));
      img.fillRect(canvas, x1: 0, y1: ly - (h * 0.005).toInt(), x2: (w * 0.005).toInt(), y2: ly + (h * 0.06).toInt(), color: cfg.primary);
    }
    img.fillCircle(canvas, x: (w * 0.07).toInt(), y: ly + (h * 0.025).toInt(), radius: (h * 0.018).toInt(), color: isActive ? cfg.primary : img.ColorRgba8(255, 255, 255, 40));
    drawTextBar(canvas, (w * 0.14).toInt(), ly + (h * 0.015).toInt(), (w * 0.5).toInt(), (h * 0.013).toInt(), isActive ? white() : gray(), opacity: isActive ? 1.0 : 0.6);
    drawTextBar(canvas, (w * 0.14).toInt(), ly + (h * 0.035).toInt(), (w * 0.25).toInt(), (h * 0.01).toInt(), gray(), opacity: 0.4);
  }

  drawStatusBar(canvas, w, true);
  return canvas;
}

/// 06 - Profile screen
img.Image paintProfile(int w, int h, ClientConfig cfg) {
  final canvas = img.Image(width: w, height: h);
  img.fill(canvas, color: lightGray());

  // Header with gradient
  final headerH = (h * 0.28).toInt();
  for (int y = 0; y < headerH; y++) {
    final t = y / headerH;
    final c = img.ColorRgb8(
      (cfg.primary.r + (darken(cfg.primary, 0.2).r - cfg.primary.r) * t).toInt(),
      (cfg.primary.g + (darken(cfg.primary, 0.2).g - cfg.primary.g) * t).toInt(),
      (cfg.primary.b + (darken(cfg.primary, 0.2).b - cfg.primary.b) * t).toInt(),
    );
    img.drawLine(canvas, x1: 0, y1: y, x2: w, y2: y, color: c);
  }

  // Avatar
  final avatarR = (w * 0.12).toInt();
  final avatarCX = w ~/ 2;
  final avatarCY = (headerH * 0.55).toInt();
  img.fillCircle(canvas, x: avatarCX, y: avatarCY, radius: avatarR + 6, color: white());
  img.fillCircle(canvas, x: avatarCX, y: avatarCY, radius: avatarR, color: lighten(cfg.primary, 0.3));
  placeLogo(canvas, cfg.logo, avatarCX, avatarCY, (avatarR * 1.2).toInt());

  // Name & role bars
  drawTextBar(canvas, w ~/ 2 - (w * 0.22).toInt(), (headerH * 0.78).toInt(), (w * 0.44).toInt(), (h * 0.02).toInt(), white());
  drawTextBar(canvas, w ~/ 2 - (w * 0.14).toInt(), (headerH * 0.88).toInt(), (w * 0.28).toInt(), (h * 0.013).toInt(), white(), opacity: 0.75);

  // Stats row
  final statsY = headerH + (h * 0.02).toInt();
  final statsH = (h * 0.1).toInt();
  drawCard(canvas, (w * 0.04).toInt(), statsY, (w * 0.92).toInt(), statsH);
  for (int i = 0; i < 3; i++) {
    final sx = (w * 0.18).toInt() + i * (w ~/ 3);
    drawTextBar(canvas, sx - (w * 0.06).toInt(), statsY + (statsH * 0.2).toInt(), (w * 0.12).toInt(), (h * 0.02).toInt(), cfg.primary);
    drawTextBar(canvas, sx - (w * 0.07).toInt(), statsY + (statsH * 0.55).toInt(), (w * 0.14).toInt(), (h * 0.012).toInt(), darkGray(), opacity: 0.6);
    if (i < 2) img.drawLine(canvas, x1: sx + (w * 0.09).toInt(), y1: statsY + (statsH * 0.2).toInt(), x2: sx + (w * 0.09).toInt(), y2: statsY + statsH - (statsH * 0.2).toInt(), color: lightGray());
  }

  // Menu items
  final menuItems = 5;
  final menuStartY = statsY + statsH + (h * 0.025).toInt();
  final menuItemH = (h * 0.075).toInt();
  for (int i = 0; i < menuItems; i++) {
    final my = menuStartY + i * (menuItemH + (h * 0.012).toInt());
    drawCard(canvas, (w * 0.04).toInt(), my, (w * 0.92).toInt(), menuItemH, radius: 16);
    // Icon circle
    img.fillCircle(canvas, x: (w * 0.11).toInt(), y: my + menuItemH ~/ 2, radius: (menuItemH * 0.28).toInt(), color: lighten(cfg.primary, 0.7));
    img.fillCircle(canvas, x: (w * 0.11).toInt(), y: my + menuItemH ~/ 2, radius: (menuItemH * 0.15).toInt(), color: cfg.primary);
    // Label
    drawTextBar(canvas, (w * 0.18).toInt(), my + menuItemH ~/ 2 - (h * 0.008).toInt(), (w * 0.45).toInt(), (h * 0.015).toInt(), nearBlack());
    // Arrow
    img.fillRect(canvas, x1: (w * 0.84).toInt(), y1: my + menuItemH ~/ 2 - 4, x2: (w * 0.88).toInt(), y2: my + menuItemH ~/ 2 + 4, color: gray());
  }

  drawBottomNav(canvas, w, h, cfg.primary);
  drawStatusBar(canvas, w, false);
  return canvas;
}
