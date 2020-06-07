import 'package:shared_preferences/shared_preferences.dart';

class PrefUtil {
  static getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }
}
