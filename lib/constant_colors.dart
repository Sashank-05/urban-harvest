/*
class AppColors {
  static const Color primaryColor = Color.fromRGBO(216, 243, 220,1);
  static const Color secondaryColor = Color.fromRGBO(183, 228, 199,1);
  static const Color secondaryColor2 = Color.fromRGBO(149, 213, 178,1);
  static const Color secondaryColor3 = Color.fromRGBO(116, 198, 157,1);
  static const Color tertiaryColor = Color.fromRGBO(82, 183, 136,1);
  static const Color tertiaryColor2 = Color.fromRGBO(64, 145, 108,1);
  static const Color backgroundColor = Color.fromRGBO(8, 28, 21, 1);
  static const Color backgroundColor2 = Color.fromRGBO(27, 67, 50, 1);
  static const Color backgroundColor3 = Color.fromRGBO(45, 106, 79,1);
  static const Color textColorLight = Color.fromRGBO(0, 0, 0, 1);
  static const Color textColorDark = Color.fromRGBO(167, 255, 230, 1.0);

}





class AppColors {
  static const Color primaryColor = Color.fromRGBO(114, 215, 136, 1);
  static const Color secondaryColor = Color.fromRGBO(154, 219, 171, 1);
  static const Color secondaryColor2 = Color.fromRGBO(191, 233, 204, 1);
  static const Color secondaryColor3 = Color.fromRGBO(225, 247, 237, 1);
  static const Color tertiaryColor = Color.fromRGBO(161, 255, 211, 1.0);
  static const Color tertiaryColor2 = Color.fromRGBO(225, 244, 233, 1);
  static const Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color backgroundColor2 = Color.fromRGBO(33, 52, 27, 1.0);
  static const Color backgroundColor3 = Color.fromRGBO(33, 75, 33, 1.0);
  static const Color textColorLight = Color.fromRGBO(0, 0, 0, 1);
  static const Color textColorDark = Color.fromRGBO(8, 8, 8, 1);
}

class AppColors {
  static const Color primaryColor = Color.fromRGBO(39, 12, 35,1);
  static const Color secondaryColor = Color.fromRGBO(72, 27, 56,1);
  static const Color secondaryColor2 = Color.fromRGBO(106, 42, 77,1);
  static const Color secondaryColor3 = Color.fromRGBO(139, 57, 98,1);
  static const Color tertiaryColor = Color.fromRGBO(173, 72, 119,1);
  static const Color tertiaryColor2 = Color.fromRGBO(191, 110, 147,1);
  static const Color backgroundColor = Color.fromRGBO(247, 227, 234, 1);
  static const Color backgroundColor2 = Color.fromRGBO(228, 188, 205, 1);
  static const Color backgroundColor3 = Color.fromRGBO(210, 149, 176,1);
  static const Color textColorLight = Color.fromRGBO(255, 255, 255, 1);
  static const Color textColorDark = Color.fromRGBO(88, 0, 25, 1.0);
}


*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors extends ChangeNotifier {
  static bool isDarkMode = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void initState() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    await AppColors.loadThemePreference();
  }

  static Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
  }

  static Future<void> saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = value;
    await prefs.setBool('isDarkMode', value);
  }

  static Color get primaryColor => isDarkMode
      ? const Color.fromRGBO(14, 39, 12, 1.0)
      : const Color.fromRGBO(216, 243, 220, 1);

  static Color get secondaryColor => isDarkMode
      ? const Color.fromRGBO(27, 72, 33, 1.0)
      : const Color.fromRGBO(183, 228, 199, 1);

  static Color get secondaryColor2 => isDarkMode
      ? const Color.fromRGBO(63, 106, 42, 1.0)
      : const Color.fromRGBO(149, 213, 178, 1);

  static Color get secondaryColor3 => isDarkMode
      ? const Color.fromRGBO(60, 139, 57, 1.0)
      : const Color.fromRGBO(116, 198, 157, 1);

  static Color get tertiaryColor => isDarkMode
      ? const Color.fromRGBO(75, 173, 72, 1.0)
      : const Color.fromRGBO(82, 183, 136, 1);

  static Color get tertiaryColor2 => isDarkMode
      ? const Color.fromRGBO(128, 191, 110, 1.0)
      : const Color.fromRGBO(64, 145, 108, 1);

  static Color get backgroundColor => isDarkMode
      ? const Color.fromRGBO(234, 247, 227, 1.0)
      : const Color.fromRGBO(8, 28, 21, 1);

  static Color get backgroundColor2 => isDarkMode
      ? const Color.fromRGBO(189, 228, 188, 1.0)
      : const Color.fromRGBO(27, 67, 50, 1);

  static Color get backgroundColor3 => isDarkMode
      ? const Color.fromRGBO(149, 210, 150, 1.0)
      : const Color.fromRGBO(45, 106, 79, 1);

  static Color get textColorLight => isDarkMode
      ? const Color.fromRGBO(0, 0, 0, 1.0)
      : const Color.fromRGBO(171, 239, 172, 1.0);

  static Color get textColorDark => isDarkMode
      ? const Color.fromRGBO(35, 88, 0, 1.0)
      : const Color.fromRGBO(167, 255, 230, 1.0);
}
