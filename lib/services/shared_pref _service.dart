import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<Map<String, dynamic>> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if (value != null) {
      return json.decode(value);
    }
    throw Exception();
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
