import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const dailyRecomendation = 'DAILY_RECOMENDATION';
  static const firstTime = 'IS_FIRST_TIME';

  Future<bool> get isDailyRecomendationActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyRecomendation) ?? false;
  }

  void setDailyRecomendation(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyRecomendation, value);
  }

  Future<bool> get isFirstTime async {
    final prefs = await sharedPreferences;
    return prefs.getBool(firstTime) ?? true;
  }

  void setFirstTime(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(firstTime, value);
  }
}
