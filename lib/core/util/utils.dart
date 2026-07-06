import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static String get osType => Platform.isAndroid ? 'android' : 'ios';

  static String countryCodeToEmoji(String countryCode) {
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}

class MyMedia {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage(bool isGallery) async {
    XFile? image;
    try {
      image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    } catch (e) {
      debugPrint('Error=> $e ' * 100);
    }
    return image;
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
      return image != null ? File(image.path) : null;
    } catch (e) {
      log('$e');
      final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
      return image != null ? File(image.path) : null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
      return image != null ? File(image.path) : null;
    } catch (e) {
      log('$e');
      final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
      return image != null ? File(image.path) : null;
    }
    // final check = await handelCameraPermission();
    // if (check != true) return null;
    // final image =
    //     await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    // return image != null ? File(image.path) : null;
  }
}
