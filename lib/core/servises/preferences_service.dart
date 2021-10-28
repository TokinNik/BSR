import 'package:bsr/core/data/preferences.dart';

abstract class PreferencesService {
  Future<Preferences> getPreferences();

  Future<void> setPreferences(Preferences session);

  Future<void> clearPreferences();
}
