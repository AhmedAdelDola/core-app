import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/ui_helpers/alert_message.dart';

class AppLauncher {
  AppLauncher._();

  static dynamic launchTel(String phone) async {
    try {
      Uri schema = Uri(scheme: 'tel', path: phone);

      await launchUrl(schema);
    } catch (e) {
      debugPrint(e.toString());
      showErrorToast(e.toString());
    }
  }

  static void openURL(Uri url) async =>
      await canLaunchUrl(url) ? await launchUrl(url) : throw 'Could not launch $url';

  static dynamic launchSms(String phone) async {
    try {
      Uri scheme = Uri(scheme: 'sms', path: phone);

      await launchUrl(scheme);
    } catch (e) {
      debugPrint(e.toString());
      showErrorToast(e.toString());
    }
  }

  static dynamic launchEmail({
    required String email,
    required String subject,
    required String body,
  }) async {
    try {
      Uri scheme = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {'subject': subject, 'body': body},
      );

      await launchUrl(scheme);
    } catch (e) {
      debugPrint(e.toString());
      showErrorToast(e.toString());
    }
  }

  static void launchWhatsApp({required String number}) async {
    /// TODO: add number in every where
    var whatsAppUrl = 'https://wa.me/$number';
    final Uri url = Uri.parse(whatsAppUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'حدث خطأ ما';
    }
  }

  static void launchTelegram({required String number}) async {
    var telegramUrl = 'https://t.me/$number';
    final Uri url = Uri.parse(telegramUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'حدث خطأ ما';
    }
  }

  static void phoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
