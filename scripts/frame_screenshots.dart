import 'dart:convert';
import 'dart:io';
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

  final clientConfigFile = File('clients/$client/client_config.json');
  String appName = client;
  img.Color brandColor = img.ColorRgb8(37, 99, 235);

  if (clientConfigFile.existsSync()) {
    final cfg = jsonDecode(await clientConfigFile.readAsString());
    appName = cfg['appName'] ?? client;
    if (cfg['fallbackPrimaryColor'] != null) {
      final hex = (cfg['fallbackPrimaryColor'] as String)
          .replaceAll('#', '')
          .replaceAll('0x', '')
          .replaceAll('FF', '');
      if (hex.length == 6) {
        final r = int.parse(hex.substring(0, 2), radix: 16);
        final g = int.parse(hex.substring(2, 4), radix: 16);
        final b = int.parse(hex.substring(4, 6), radix: 16);
        brandColor = img.ColorRgb8(r, g, b);
      }
    }
  }

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
    ]
  };

  final screenshotFiles = [
    '01_splash.png',
    '02_onboarding_or_login.png',
    '03_guest_home.png',
    '04_main_screen.png',
    '05_library_screen.png',
    '06_profile_screen.png',
  ];

  for (var entry in targets.entries) {
    final store = entry.key;
    final sizes = entry.value;

    for (var sizeMap in sizes) {
      final sizeName = sizeMap['name'] as String;
      final tw = sizeMap['w'] as int;
      final th = sizeMap['h'] as int;

      final outFolder = Directory('$outputDir/$client/$store/$sizeName');
      if (!outFolder.existsSync()) outFolder.createSync(recursive: true);

      for (var file in screenshotFiles) {
        final rawPath = '$inputDir/$file';
        final rawFile = File(rawPath);

        img.Image canvas = img.Image(width: tw, height: th);
        img.fill(canvas, color: brandColor);

        img.Image? rawImg;
        if (rawFile.existsSync()) {
          rawImg = img.decodeImage(rawFile.readAsBytesSync());
        }

        if (rawImg == null) {
          rawImg = img.Image(width: 800, height: 1600);
          img.fill(rawImg, color: img.ColorRgb8(240, 243, 246));
        }

        // Scale screenshot to fit canvas
        final headerMargin = (th * 0.10).toInt();
        final deviceWidth = (tw * 0.84).toInt();
        final scaled = img.copyResize(rawImg, width: deviceWidth);

        final posX = (tw - scaled.width) ~/ 2;
        final posY = headerMargin;

        img.compositeImage(canvas, scaled, dstX: posX, dstY: posY);

        final outFile = File('${outFolder.path}/$file');
        outFile.writeAsBytesSync(img.encodePng(canvas));
        print('✅ Generated framed store screenshot: ${outFile.path} (${tw}x${th})');
      }
    }
  }
}
