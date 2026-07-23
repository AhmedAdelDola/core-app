import 'package:elhanbly/core/consts/client_config.dart';
import 'package:elhanbly/core/local/user_preferences/user_preferences_helper.dart';
import 'package:elhanbly/models/general/settings_response.dart';
import 'package:flutter/material.dart';

class AppColors {
 
  // Compute primary color at runtime from stored settings or ClientConfig
  static Color get kPrimary {
    final SettingsResponse? settings = UserPreferencesHelper().getAppSettings();
    final String? hex = settings?.branding?.primaryColor ?? getPrimaryHex() ?? ClientConfig.fallbackPrimaryColor;
    if (hex != null && hex.isNotEmpty) {
      final cleaned = hex.replaceAll('#', '').replaceAll('0x', '');
      final normalized = (cleaned.length == 6) ? 'FF$cleaned' : cleaned;
      final value = int.parse(normalized, radix: 16);
      return Color(value);
    }
    return const Color(0xFFFFAF4E);
  }
    
  

  /// Return stored primary color hex string, if any.
  static String? getPrimaryHex() => UserPreferencesHelper().getPrimaryColor();

  /// Persist primary color hex string (e.g. "#RRGGBB" or "#AARRGGBB").
  static void setPrimaryHex(String hex) => UserPreferencesHelper().setPrimaryColor(hex);
  static const Color textFieldBorderColor = Color(0xffA0B1C4);
  static const Color textColor = Color(0xFF061A40);
  static const Color textColor2 = Color(0xFF6A7887);
  static const Color textColor3 = Color(0xFF071F1E);
  static const Color textColor4 = Color(0xFF6A768C);
  static const Color textColor5 = Color(0xFF434A51);
  static const Color red = Color(0xFFD72027);
  static const Color hintColor = Color(0xFF959595);
  static const Color disabledBtnColor = Color(0xFFF0F2F5);
  static const Color borderColor = Color(0xFFCED4DA);
  static const Color kGreen = Color(0xff41C980);
  static const Color kGold = Color(0xffFFD700);
  static const Color indicatorBg = Color(0xffE6EAEF);

  /// ================================================================================================
  static const Color kPrimaryBackground = Color(0xff87279F);
  static const Color kBackground = Color(0xfffefbff);
  static const Color kWhite = Color(0xffFFFFFF);
  static const Color kBlack = Color(0xff000000);
  static const Color kIndicatorColor = Color(0xff2a2a2a);
  static const Color kSplashBgColor = Color(0xff19191A);
  static const Color kRed = Color(0xffE30613);
  static const Color kOrange = Color(0xffFA6400);
  static const Color kGray = Color(0xff777777);
  static const Color kLightGray = Color(0xffC1C9D2);
  static const Color kDarkGray = Color(0xff7E7E7E);
  static const Color kGrayText = Color(0xff7C7C7C);
  static const Color kDarkGreyText = Color(0xff535353);
  static const Color kBottomNavColor = Color(0xffFEFBFF);
  // ================================================================

  static const Color kDarkModePrimaryBackground = Color(0xff535178);
  static const Color kDarkModePrimary = Color(0xff535178);
  static const Color kDarkModeBackground = Color(0xff604c78);
  static const Color kDarkModeBlack = Color(0xff000000);
  static const Color kDarkModeIndicatorColor = Color(0xff2a2a2a);
  static const Color kDarkModeSplashBgColor = Color(0xff19191A);
  static const Color kDarkModeRed = Color(0xffE30613);
  static const Color kDarkModeOrange = Color(0xffFA6400);
  static const Color kDarkModeGreen = Color(0xff1EB10D);
  static const Color kDarkModeGray = Color(0xff777777);
  static const Color kDarkModeLightGray = Color(0xffC1C9D2);
  static const Color kDarkModeDarkGray = Color(0xff7E7E7E);
  static const Color kDarkModeGrayText = Color(0xff7C7C7C);
  static const Color kDarkModeDarkGreyText = Color(0xff535353);
  static const Color kDarkModeBottomNavColor = Color(0xffFEFBFF);
}
