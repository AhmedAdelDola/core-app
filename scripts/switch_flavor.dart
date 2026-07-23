import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart scripts/switch_flavor.dart <client_name>');
    exit(1);
  }

  final clientName = args.first;
  final clientDir = Directory('clients/${clientName}');

  if (!clientDir.existsSync()) {
    print('Error: Client folder "${clientName}" does not exist in clients/');
    exit(1);
  }

  print('Switching flavor to ${clientName}...');

  // 1. Load config
  final configFile = File('${clientDir.path}/client_config.json');
  if (!configFile.existsSync()) {
    print('Error: client_config.json not found in ${clientDir.path}');
    exit(1);
  }
  final configStr = await configFile.readAsString();
  final config = jsonDecode(configStr);

  final appName = config['appName'];
  final packageName = config['packageName'];
  final slogan = config['slogan'] ?? '';
  final fallbackPrimaryColor = config['fallbackPrimaryColor'];

  // 2. Copy files
  void copyIfExists(String src, String dest) {
    final srcFile = File(src);
    if (srcFile.existsSync()) {
      srcFile.copySync(dest);
      print('Copied ${src} -> ${dest}');
    }
  }

  copyIfExists('${clientDir.path}/.env', '.env');
  copyIfExists('${clientDir.path}/firebase_options.dart', 'lib/firebase_options.dart');
  copyIfExists('${clientDir.path}/google-services.json', 'android/app/google-services.json');
  copyIfExists('${clientDir.path}/GoogleService-Info.plist', 'ios/Runner/GoogleService-Info.plist');
  
  final logoDir = Directory('${clientDir.path}/logo');
  if (logoDir.existsSync()) {
    final logoFiles = logoDir.listSync();
    for (var file in logoFiles) {
      if (file is File) {
        final fileName = file.uri.pathSegments.last;
        copyIfExists(file.path, 'assets/images/logo/${fileName}');
      }
    }
  }

  // 3. Rewrite client_config.dart
  final clientConfigDart = File('lib/core/consts/client_config.dart');
  if (clientConfigDart.existsSync()) {
    final colorVal = fallbackPrimaryColor != null ? "'$fallbackPrimaryColor'" : "null";
    clientConfigDart.writeAsStringSync('''class ClientConfig {
  static const String appName = '${appName}';
  static const String slogan = '${slogan}';
  static const String? fallbackPrimaryColor = $colorVal;
}
''');
    print('Updated lib/core/consts/client_config.dart');
  }

  // 4. Update android/app/build.gradle.kts
  final buildGradle = File('android/app/build.gradle.kts');
  if (buildGradle.existsSync()) {
    var content = buildGradle.readAsStringSync();
    content = content.replaceAll(RegExp(r'applicationId\s*=\s*".*"'), 'applicationId = "${packageName}"');
    content = content.replaceAll(RegExp(r'namespace\s*=\s*".*"'), 'namespace = "${packageName}"');
    buildGradle.writeAsStringSync(content);
    print('Updated applicationId and namespace in android/app/build.gradle.kts');
  }

  // 4b. Update package declaration in MainActivity.kt (or .java)
  final mainActivityKt = File('android/app/src/main/kotlin/com/example/elhanbly/MainActivity.kt');
  if (mainActivityKt.existsSync()) {
    var content = mainActivityKt.readAsStringSync();
    content = content.replaceAll(RegExp(r'^package\s+.*$', multiLine: true), 'package ${packageName}');
    mainActivityKt.writeAsStringSync(content);
    print('Updated package declaration in MainActivity.kt');
  }

  // 5. Update android strings.xml
  final stringsXml = File('android/app/src/main/res/values/strings.xml');
  if (stringsXml.existsSync()) {
    var content = stringsXml.readAsStringSync();
    content = content.replaceAll(RegExp(r'<string name="app_name">.*</string>'), '<string name="app_name">${appName}</string>');
    stringsXml.writeAsStringSync(content);
    print('Updated app_name in android strings.xml');
  }

  // 6. Update iOS bundle identifier
  final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj');
  if (pbxproj.existsSync()) {
    var content = pbxproj.readAsStringSync();
    content = content.replaceAll(RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*[^;]+;'), 'PRODUCT_BUNDLE_IDENTIFIER = ${packageName};');
    pbxproj.writeAsStringSync(content);
    print('Updated PRODUCT_BUNDLE_IDENTIFIER in ios/Runner.xcodeproj/project.pbxproj');
  }

  // 7. Update iOS Info.plist
  final infoPlist = File('ios/Runner/Info.plist');
  if (infoPlist.existsSync()) {
    var content = infoPlist.readAsStringSync();
    
    // Replace CFBundleDisplayName
    content = content.replaceAllMapped(RegExp(r'(<key>CFBundleDisplayName</key>\s*<string>)(.*?)(</string>)'), (match) {
      return '${match[1]}${appName}${match[3]}';
    });
    
    // Replace CFBundleName
    // We can use a simplified version of appName (no spaces) for CFBundleName
    final simpleName = appName.replaceAll(' ', '');
    content = content.replaceAllMapped(RegExp(r'(<key>CFBundleName</key>\s*<string>)(.*?)(</string>)'), (match) {
      return '${match[1]}${simpleName}${match[3]}';
    });
    
    infoPlist.writeAsStringSync(content);
    print('Updated CFBundleDisplayName and CFBundleName in ios/Runner/Info.plist');
  }

  // 8. Run flutter_launcher_icons
  print('Running flutter pub run flutter_launcher_icons...');
  final result = await Process.run('flutter', ['pub', 'run', 'flutter_launcher_icons'], runInShell: true);
  if (result.exitCode == 0) {
    print('Launcher icons updated successfully.');
  } else {
    print('Error updating launcher icons:');
    print(result.stdout);
    print(result.stderr);
  }

  print('');
  print('✅ Successfully switched to flavor: ${clientName}');
}
