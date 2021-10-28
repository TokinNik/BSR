import 'dart:convert';

import 'package:bsr/core/data/preferences.dart';
import 'package:bsr/core/servises/preferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bsr/core/data/session.dart';
import 'package:bsr/core/data/token.dart';
import 'package:bsr/core/dio/errors/error_unwrapper.dart';
import 'package:bsr/core/servises/session_service.dart';
import 'package:bsr/utils/logger.dart';

class PreferencesServiceImpl implements PreferencesService {
  var prefs = FlutterSecureStorage();

  PreferencesServiceImpl();

  Future<Preferences> getPreferences() async {
    try {
      var rawPreferences = await prefs.read(key: "PREFERENCES");
      logD("getPrefs: $rawPreferences");
      if (rawPreferences == null) {
        return Preferences();
      } else {
        Preferences preferences = preferencesFromJson(rawPreferences);
        return preferences;
      }
    } catch (e) {
      logE("getPrefs: $e");
      logE("getPrefs: ${e.stackTrace}");
      return null;
    }
  }

  Future<void> setPreferences(Preferences session) async {
    await prefs.write(key: "PREFERENCES", value: preferencesToJson(session));
  }

  Future<void> clearPreferences() async {
    await prefs.deleteAll();
  }
}

Preferences preferencesFromJson(String str) =>
    Preferences.fromMap(json.decode(str));

String preferencesToJson(Preferences data) => json.encode(data.toMap());
