import 'app_theme_mode.dart';

class AppThemeController {
  AppThemeController(this._mode);

  AppThemeMode _mode;

  AppThemeMode get mode => _mode;

  void updateMode(AppThemeMode mode) {
    _mode = mode;
  }

  bool get usesDarkTheme => _mode == AppThemeMode.dark;
}
